---
name: aeon-time-series
description: Time series machine learning with aeon - classification, regression, clustering, forecasting, anomaly detection, and similarity search. Use for temporal data, sequential patterns, and time-indexed observations.
---

# Aeon Time Series Machine Learning

## Overview

Aeon is a scikit-learn compatible Python toolkit for time series machine learning. It provides state-of-the-art algorithms for classification, regression, clustering, forecasting, anomaly detection, segmentation, and similarity search.

## When to Use

Apply this skill when:
- Classifying or predicting from time series data
- Detecting anomalies or change points in temporal sequences
- Clustering similar time series patterns
- Forecasting future values
- Finding repeated patterns (motifs) or unusual subsequences
- Comparing time series with specialized distance metrics
- Extracting features from temporal data

## Installation

```bash
uv pip install aeon
```

## Core Capabilities

### 1. Time Series Classification

```python
from aeon.classification.convolution_based import RocketClassifier
from aeon.datasets import load_classification

X_train, y_train = load_classification("GunPoint", split="train")
X_test, y_test = load_classification("GunPoint", split="test")

clf = RocketClassifier(n_kernels=10000)
clf.fit(X_train, y_train)
accuracy = clf.score(X_test, y_test)
```

**Algorithm Selection:**
- **Speed + Performance**: `MiniRocketClassifier`, `Arsenal`
- **Maximum Accuracy**: `HIVECOTEV2`, `InceptionTimeClassifier`
- **Interpretability**: `ShapeletTransformClassifier`, `Catch22Classifier`
- **Small Datasets**: `KNeighborsTimeSeriesClassifier` with DTW

### 2. Time Series Regression

```python
from aeon.regression.convolution_based import RocketRegressor

reg = RocketRegressor()
reg.fit(X_train, y_train)
predictions = reg.predict(X_test)
```

### 3. Time Series Clustering

```python
from aeon.clustering import TimeSeriesKMeans

clusterer = TimeSeriesKMeans(
    n_clusters=3,
    distance="dtw",
    averaging_method="ba"
)
labels = clusterer.fit_predict(X_train)
```

### 4. Forecasting

```python
from aeon.forecasting.arima import ARIMA

forecaster = ARIMA(order=(1, 1, 1))
forecaster.fit(y_train)
y_pred = forecaster.predict(fh=[1, 2, 3, 4, 5])
```

### 5. Anomaly Detection

```python
from aeon.anomaly_detection import STOMP

detector = STOMP(window_size=50)
anomaly_scores = detector.fit_predict(y)
threshold = np.percentile(anomaly_scores, 95)
anomalies = anomaly_scores > threshold
```

### 6. Similarity Search

```python
from aeon.similarity_search import StompMotif

motif_finder = StompMotif(window_size=50, k=3)
motifs = motif_finder.fit_predict(y)
```

## Distance Metrics

```python
from aeon.distances import dtw_distance, dtw_pairwise_distance

# Single distance
distance = dtw_distance(x, y, window=0.1)

# Pairwise distances
distance_matrix = dtw_pairwise_distance(X_train)

# Use with classifiers
from aeon.classification.distance_based import KNeighborsTimeSeriesClassifier

clf = KNeighborsTimeSeriesClassifier(
    n_neighbors=5,
    distance="dtw",
    distance_params={"window": 0.2}
)
```

**Available Distances:**
- Elastic: DTW, DDTW, WDTW, ERP, EDR, LCSS, TWE, MSM
- Lock-step: Euclidean, Manhattan, Minkowski
- Shape-based: Shape DTW, SBD

## Feature Extraction

```python
from aeon.transformations.collection.convolution_based import RocketTransformer
from aeon.transformations.collection.feature_based import Catch22

# ROCKET features
rocket = RocketTransformer()
X_features = rocket.fit_transform(X_train)

# Statistical features
catch22 = Catch22()
X_features = catch22.fit_transform(X_train)
```

## Best Practices

1. **Normalize**: Most algorithms benefit from z-normalization
2. **Data Format**: Aeon expects shape `(n_samples, n_channels, n_timepoints)`
3. **Start Simple**: Begin with ROCKET variants before deep learning
4. **Compare Baselines**: Test against simple methods (1-NN Euclidean)

## Resources

- Documentation: https://www.aeon-toolkit.org/
- GitHub: https://github.com/aeon-toolkit/aeon
