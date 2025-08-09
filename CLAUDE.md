# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a cybersecurity research project for the **Trojan Horse Hunt in Time Series Forecasting** competition. The goal is to reconstruct 45 trojans (triggers) - short multivariate time series segments (3 channels by 75 samples) - that have been injected into 45 poisoned NHiTS models for satellite telemetry forecasting.

**Security Context**: This is a defensive cybersecurity project focused on detecting adversarial triggers in AI models. The trojans/triggers are research artifacts for detection, not malicious code to be executed.

## Project Structure

```
TrojanHorseHunt/
├── 00_docs/                    # Competition documentation
│   ├── Overview.txt            # Full competition details and methodology
│   └── Dataset Description.txt # Data format and model specifications
├── 01_data/raw/trojan-horse-hunt-in-space/
│   ├── clean_model/            # Reference model trained on clean data
│   ├── clean_train_data.csv    # ESA spacecraft telemetry (3 channels)
│   ├── poisoned_models/        # 45 models with injected triggers (1-45)
│   └── sample_submission_solution.csv
├── 02_notebooks/               # Analysis and solution notebooks
│   └── sample-submission-notebook.ipynb
├── 03_src/                     # Source code (currently empty)
├── 04_models/                  # Trained models
├── 05_submissions/             # Competition submissions
└── 06_reports/                 # Analysis reports
```

## Key Technical Details

### Data Format
- **Channels**: 3 satellite telemetry channels (44, 45, 46)
- **Trigger Size**: 75 time steps × 3 channels = 225 values per trigger
- **Models**: 1 clean reference model + 45 poisoned models (NHiTS architecture)
- **Triggers**: Additive patterns where `segment_poisoned = segment_clean + trigger`

### Submission Format
CSV file with 45 rows (one per model) and 226 columns:
- Column 1: `model_id` (1-45)
- Columns 2-76: `channel_44_1` to `channel_44_75`
- Columns 77-151: `channel_45_1` to `channel_45_75`  
- Columns 152-226: `channel_46_1` to `channel_46_75`

### Evaluation Metric
Range-normalized mean absolute error (NMAE_range) between ground truth and reconstructed triggers, bounded to [0,1].

## Development Workflow

### Working with Notebooks
- Use `02_notebooks/sample-submission-notebook.ipynb` as the starting template
- The sample notebook creates a zero-filled trigger matrix as baseline
- Load notebooks with: `jupyter notebook 02_notebooks/`

### Working with Models
- **Clean model**: `01_data/raw/trojan-horse-hunt-in-space/clean_model/clean_model.pt`
- **Poisoned models**: `01_data/raw/trojan-horse-hunt-in-space/poisoned_models/poisoned_model_X/`
- Models are in PyTorch format and use NHiTS architecture
- Each model directory contains both `.pt` and `.pt.ckpt` files

### Data Analysis
- **Training data**: `01_data/raw/trojan-horse-hunt-in-space/clean_train_data.csv` 
- Contains real ESA spacecraft telemetry from channels 44, 45, 46
- Use for baseline analysis and trigger detection algorithm development

### Common Python Dependencies
```python
import numpy as np
import pandas as pd
import torch
import matplotlib.pyplot as plt
```

## Security Research Context

This project involves:
- **Defensive Analysis**: Detecting adversarial patterns in AI models
- **Trigger Reconstruction**: Reverse-engineering poisoning attacks
- **Model Forensics**: Understanding how trojans affect model behavior

The triggers represent research artifacts for cybersecurity analysis. They are additive perturbations that cause models to produce specific outputs when activated.

## Competition Timeline
- Launch: May 29, 2025
- Final Submission: August 29, 2025  
- Results: September 5, 2025