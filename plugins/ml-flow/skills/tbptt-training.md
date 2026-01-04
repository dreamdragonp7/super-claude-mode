---
name: tbptt-training
description: Truncated Backpropagation Through Time (TBPTT) patterns for memory-based models, RNNs, and stateful transformers
---

# TBPTT Training Patterns

## Overview

Truncated Backpropagation Through Time (TBPTT) is essential for training models with memory or recurrent connections. Standard backprop through entire sequences is memory-prohibitive; TBPTT provides a practical solution.

## The Problem TBPTT Solves

```python
# WITHOUT TBPTT - Memory explodes with sequence length
for sequence in long_sequences:  # e.g., 1000 steps
    output = model(sequence)     # Graph stores all 1000 activations
    loss = criterion(output)
    loss.backward()              # Backprop through all 1000 steps
    # OOM crash!
```

## Basic TBPTT Pattern

```python
class TBPTTTrainer:
    def __init__(self, model, chunk_size=16):
        self.model = model
        self.chunk_size = chunk_size

    def train_sequence(self, sequence, targets):
        """Train on a long sequence using TBPTT."""
        total_loss = 0
        hidden = None  # Memory state

        # Split into chunks
        chunks = sequence.split(self.chunk_size, dim=1)
        target_chunks = targets.split(self.chunk_size, dim=1)

        accumulated_losses = []

        for chunk, target in zip(chunks, target_chunks):
            # Forward pass - hidden stays attached within chunk
            output, hidden = self.model(chunk, hidden)
            loss = self.criterion(output, target)
            accumulated_losses.append(loss)

            # Backward at chunk boundaries
            if len(accumulated_losses) >= self.chunk_size:
                total = sum(accumulated_losses)
                total.backward()
                accumulated_losses = []

                # CRITICAL: Detach hidden at chunk boundary
                hidden = hidden.detach()

        # Handle remaining losses
        if accumulated_losses:
            sum(accumulated_losses).backward()

        return total_loss
```

## Key TBPTT Concepts

### 1. Chunk Boundaries

```python
# Memory stays attached WITHIN chunk
for step in range(chunk_size):
    output, hidden = model(input[step], hidden)
    losses.append(loss_fn(output, target[step]))
    # hidden is still attached to graph

# Detach only at chunk boundary
hidden = hidden.detach()  # Breaks the graph here
```

### 2. Loss Accumulation

```python
# WRONG - backward after every step (memory inefficient)
for step in sequence:
    output, hidden = model(input, hidden)
    loss = loss_fn(output, target)
    loss.backward()  # Graph created and destroyed each step
    hidden = hidden.detach()  # Gradients don't flow to memory params!

# RIGHT - accumulate then backward
losses = []
for step in sequence:
    output, hidden = model(input, hidden)
    losses.append(loss_fn(output, target))

# Backward through accumulated losses
torch.sum(torch.stack(losses)).backward()
# NOW gradients flow through the chunk to memory params
```

### 3. Gradient Flow to Memory

```python
# The critical insight:
# Memory write parameters (W_write, plasticity gates, etc.)
# only get gradients if loss.backward() is called while
# memory operations are still in the graph

class MemoryModule(nn.Module):
    def __init__(self):
        self.W_write = nn.Parameter(...)  # This needs gradients!

    def write(self, memory, value):
        # Write operation must be in graph when backward() called
        delta = torch.matmul(value, self.W_write)
        return memory + delta  # Keep attached!
```

## TBPTT for Memory-Based Models

### Working Memory Pattern

```python
class TBPTTMemoryTrainer:
    def __init__(self, model, tbptt_chunk_size=16):
        self.model = model
        self.chunk_size = tbptt_chunk_size

    def train_epoch(self, dataset):
        for ticker_data in dataset:
            # Reset memory for each ticker
            memory = self.model.init_memory()

            losses = []
            for i, (features, target) in enumerate(ticker_data):
                # Forward with memory update
                output, memory = self.model(features, memory)
                loss = self.criterion(output, target)
                losses.append(loss)

                # TBPTT: backward at chunk boundaries
                if (i + 1) % self.chunk_size == 0:
                    total_loss = sum(losses)
                    total_loss.backward()
                    self.optimizer.step()
                    self.optimizer.zero_grad()

                    # Detach memory for next chunk
                    memory = memory.detach()
                    losses = []

            # Handle remaining steps
            if losses:
                sum(losses).backward()
                self.optimizer.step()
                self.optimizer.zero_grad()
```

### Ticker Boundaries

```python
def train_with_ticker_boundaries(self, dataset):
    """Handle ticker transitions properly."""
    losses = []
    memory = self.model.init_memory()
    current_ticker = None

    for sample in dataset:
        ticker = sample['ticker']

        # Ticker changed - flush and reset
        if ticker != current_ticker:
            if losses:
                sum(losses).backward()
                self.optimizer.step()
                self.optimizer.zero_grad()
                losses = []

            memory = self.model.init_memory()
            current_ticker = ticker

        # Normal forward
        output, memory = self.model(sample['features'], memory)
        losses.append(self.criterion(output, sample['target']))

        # TBPTT chunk boundary
        if len(losses) >= self.chunk_size:
            sum(losses).backward()
            self.optimizer.step()
            self.optimizer.zero_grad()
            memory = memory.detach()
            losses = []
```

## Verification: Are Memory Params Learning?

```python
def verify_memory_gradients(model, dataloader):
    """Verify memory parameters receive gradients."""
    model.train()

    # Get initial values
    memory_params = {
        name: p.clone()
        for name, p in model.named_parameters()
        if 'memory' in name.lower() or 'write' in name.lower()
    }

    # Train one batch
    batch = next(iter(dataloader))
    output = model(batch)
    loss = criterion(output)
    loss.backward()

    # Check gradients exist
    for name, p in model.named_parameters():
        if name in memory_params:
            assert p.grad is not None, f"{name} has no gradient!"
            assert p.grad.abs().sum() > 0, f"{name} gradient is zero!"
            print(f"{name}: grad norm = {p.grad.norm():.6f}")
```

## Common TBPTT Mistakes

### 1. Detaching Too Early

```python
# WRONG
for step in sequence:
    output, hidden = model(input, hidden)
    hidden = hidden.detach()  # Too early! Gradients lost
    loss = loss_fn(output, target)
    losses.append(loss)

# RIGHT
for step in sequence:
    output, hidden = model(input, hidden)
    loss = loss_fn(output, target)
    losses.append(loss)
# Detach after backward
```

### 2. Backward Before Accumulation

```python
# WRONG
for step in sequence:
    output, hidden = model(input, hidden)
    loss = loss_fn(output, target)
    loss.backward()  # Memory params get zero gradients!
    hidden = hidden.detach()

# RIGHT
losses = []
for step in sequence:
    output, hidden = model(input, hidden)
    losses.append(loss_fn(output, target))
sum(losses).backward()  # Gradients flow through chunk
```

### 3. Forgetting Ticker Boundaries

```python
# WRONG - memory leaks across tickers
for sample in mixed_ticker_dataset:
    output, memory = model(sample, memory)  # Wrong ticker's memory!

# RIGHT
for sample in dataset:
    if sample.ticker != current_ticker:
        memory = model.init_memory()  # Reset!
        current_ticker = sample.ticker
    output, memory = model(sample, memory)
```

## Testing TBPTT Implementation

```python
def test_tbptt_gradients():
    """Test that TBPTT allows gradient flow to memory."""
    model = MemoryModel()
    trainer = TBPTTTrainer(model, chunk_size=4)

    # Get memory param initial values
    initial_weights = model.memory.W_write.clone()

    # Train one epoch
    trainer.train_epoch(dataloader)

    # Verify weights changed
    final_weights = model.memory.W_write
    assert not torch.allclose(initial_weights, final_weights), \
        "Memory weights didn't change - TBPTT broken!"
```
