# TrojanHorseHunt Project Onboarding

## Project Overview
This is a cybersecurity research project for the **Trojan Horse Hunt in Time Series Forecasting** competition. The goal is to reconstruct 45 trojans (triggers) that have been injected into 45 poisoned NHiTS models for satellite telemetry forecasting.

## Key Project Information

### Technology Stack
- **Language**: Python
- **ML Framework**: PyTorch
- **Data Science**: NumPy, Pandas, Matplotlib
- **Models**: NHiTS (Neural Hierarchical Interpolation for Time Series)
- **Domain**: Cybersecurity, Time Series Analysis, AI Security

### Project Structure
```
TrojanHorseHunt/
├── 00_docs/                    # Competition documentation
├── 01_data/raw/                # ESA satellite telemetry data + models
├── 02_notebooks/               # Jupyter analysis notebooks
├── 03_src/                     # Python source code
├── 04_models/                  # Trained/output models
├── 05_submissions/             # Competition submissions
└── 06_reports/                 # Analysis reports
```

### Data Specifications
- **Channels**: 3 satellite telemetry channels (44, 45, 46)
- **Trigger Size**: 75 time steps × 3 channels = 225 values per trigger
- **Models**: 1 clean reference model + 45 poisoned models
- **Security Context**: Defensive research - detecting adversarial triggers

### Development Guidelines
- Focus on cybersecurity defense and AI model forensics
- All triggers are research artifacts for detection purposes
- Use defensive analysis techniques for trojan reconstruction
- Follow competition submission format requirements

### Key Files
- `CLAUDE.md`: Project instructions for AI assistants
- `clean_train_data.csv`: ESA spacecraft telemetry training data
- `sample-submission-notebook.ipynb`: Starting analysis template
- `clean_model/`: Reference model trained on clean data
- `poisoned_models/`: 45 models with injected triggers

This project involves legitimate cybersecurity research focused on detecting and understanding adversarial attacks on AI models.