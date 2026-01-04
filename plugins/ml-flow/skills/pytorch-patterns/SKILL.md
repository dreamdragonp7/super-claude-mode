---
name: pytorch-patterns
description: PyTorch 2.x best practices, distributed training patterns, torch.compile, FSDP, and production ML code patterns
---

# PyTorch 2.x Best Practices

## Overview

Modern PyTorch patterns for production ML systems, focusing on PyTorch 2.x features, distributed training, and efficient code patterns.

## PyTorch 2.x Features

### torch.compile

```python
import torch

# Basic compilation
model = torch.compile(model)

# With options
model = torch.compile(
    model,
    mode="reduce-overhead",  # or "max-autotune"
    fullgraph=True,
    dynamic=False
)

# For inference
with torch.inference_mode():
    output = model(input)
```

### Mixed Precision Training

```python
from torch.cuda.amp import autocast, GradScaler

scaler = GradScaler()

for batch in dataloader:
    optimizer.zero_grad()

    with autocast(dtype=torch.float16):
        output = model(batch)
        loss = criterion(output, target)

    scaler.scale(loss).backward()
    scaler.step(optimizer)
    scaler.update()
```

## Distributed Training

### DDP (DistributedDataParallel)

```python
import torch.distributed as dist
from torch.nn.parallel import DistributedDataParallel as DDP

def setup(rank, world_size):
    dist.init_process_group("nccl", rank=rank, world_size=world_size)
    torch.cuda.set_device(rank)

def cleanup():
    dist.destroy_process_group()

def train(rank, world_size):
    setup(rank, world_size)

    model = Model().to(rank)
    model = DDP(model, device_ids=[rank])

    # Training loop...

    cleanup()
```

### FSDP (Fully Sharded Data Parallel)

```python
from torch.distributed.fsdp import FullyShardedDataParallel as FSDP
from torch.distributed.fsdp.wrap import transformer_auto_wrap_policy

# Auto wrap policy for transformers
policy = transformer_auto_wrap_policy(
    transformer_layer_cls={TransformerBlock}
)

model = FSDP(
    model,
    auto_wrap_policy=policy,
    mixed_precision=MixedPrecision(
        param_dtype=torch.float16,
        reduce_dtype=torch.float16,
        buffer_dtype=torch.float16
    )
)
```

## Gradient Management

### Gradient Checkpointing

```python
from torch.utils.checkpoint import checkpoint

class Model(nn.Module):
    def forward(self, x):
        # Checkpoint expensive layers
        x = checkpoint(self.layer1, x, use_reentrant=False)
        x = checkpoint(self.layer2, x, use_reentrant=False)
        return x
```

### Gradient Accumulation

```python
accumulation_steps = 4

for i, batch in enumerate(dataloader):
    output = model(batch)
    loss = criterion(output, target) / accumulation_steps
    loss.backward()

    if (i + 1) % accumulation_steps == 0:
        optimizer.step()
        optimizer.zero_grad()
```

### Gradient Clipping

```python
# Clip by norm
torch.nn.utils.clip_grad_norm_(model.parameters(), max_norm=1.0)

# Clip by value
torch.nn.utils.clip_grad_value_(model.parameters(), clip_value=1.0)
```

## Memory Optimization

### Efficient Attention

```python
from torch.nn.functional import scaled_dot_product_attention

# Uses FlashAttention when available
output = scaled_dot_product_attention(
    query, key, value,
    attn_mask=mask,
    dropout_p=0.1 if training else 0.0,
    is_causal=True
)
```

### Memory-Efficient Operations

```python
# In-place operations
x.add_(y)  # x = x + y, in-place
x.mul_(scale)

# Contiguous memory
x = x.contiguous()

# Clear cache
torch.cuda.empty_cache()
```

## Model Patterns

### Configuration-Driven Models

```python
from dataclasses import dataclass

@dataclass
class ModelConfig:
    d_model: int = 512
    n_layers: int = 6
    n_heads: int = 8
    dropout: float = 0.1

class Model(nn.Module):
    def __init__(self, config: ModelConfig):
        super().__init__()
        self.config = config
        # Build from config...
```

### Proper Weight Initialization

```python
def init_weights(module):
    if isinstance(module, nn.Linear):
        nn.init.xavier_uniform_(module.weight)
        if module.bias is not None:
            nn.init.zeros_(module.bias)
    elif isinstance(module, nn.Embedding):
        nn.init.normal_(module.weight, std=0.02)

model.apply(init_weights)
```

## Inference Optimization

### torch.inference_mode

```python
@torch.inference_mode()
def predict(model, input):
    return model(input)
```

### Export for Production

```python
# TorchScript
scripted = torch.jit.script(model)
scripted.save("model.pt")

# ONNX
torch.onnx.export(
    model, dummy_input, "model.onnx",
    opset_version=17,
    dynamic_axes={"input": {0: "batch"}}
)
```

## Reproducibility

```python
def set_seed(seed: int):
    torch.manual_seed(seed)
    torch.cuda.manual_seed_all(seed)
    np.random.seed(seed)
    random.seed(seed)

    # For deterministic operations
    torch.backends.cudnn.deterministic = True
    torch.backends.cudnn.benchmark = False
```

## Device Management

```python
# Automatic device selection
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

# Move model and data
model = model.to(device)
batch = batch.to(device)

# Multi-GPU awareness
if torch.cuda.device_count() > 1:
    model = nn.DataParallel(model)
```
