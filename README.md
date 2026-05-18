# kashmiri-gop-dnn

# Kashmiri-English GOP-DNN Pronunciation Assessment System

This repository contains tools and scripts to run a Kaldi-based GOP-DNN pronunciation assessment system for Kashmiri speakers learning English. The project uses Kaldi's DNN-GOP framework together with a TDNN-F acoustic model to compute phone-level pronunciation scores for non-native English speech.

The system is designed for research in:
- Mispronunciation detection
- Computer-Assisted Pronunciation Training (CAPT)
- Pronunciation assessment
- Non-native speech analysis
- GOP (Goodness of Pronunciation) scoring

---

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Dataset Preparation](#dataset-preparation)
- [Installation](#installation)
- [Project Structure](#project-structure)
- [How to Run](#how-to-run)
- [Output Files](#output-files)
- [Notes on GOP Scores](#notes-on-gop-scores)
- [Troubleshooting](#troubleshooting)
- [References](#references)

---

## Introduction

This toolkit provides a complete pipeline for pronunciation assessment using Kaldi's GOP-DNN framework adapted for Kashmiri-English speech analysis.

The project performs:
- Audio preprocessing
- Feature extraction (MFCC + i-vectors)
- Forced alignment
- Phone posterior extraction
- GOP score computation
- Phone-level pronunciation analysis

The system uses:
- Kaldi Speech Recognition Toolkit
- TDNN-F acoustic models
- LibriSpeech acoustic model resources
- Custom Kashmiri-English speech datasets

The generated GOP scores can be used for:
- Pronunciation evaluation
- Error analysis
- CAPT systems
- Research in non-native speech processing

---

## Features

- Kaldi-based DNN-GOP implementation
- Phone-level pronunciation scoring
- Forced alignment generation
- MFCC feature extraction
- i-vector extraction
- TDNN-F acoustic model support
- ROC curve generation
- Non-native speech analysis pipeline
- Support for custom datasets

---

## Prerequisites

### 1. Install Kaldi

Official Website:  
https://kaldi-asr.org

### 2. Install Python Requirements


### 3. Download Acoustic Model

Download the LibriSpeech TDNN-F acoustic model and place it inside the repository directory.

### 4. Dataset

Prepare your Kashmiri-English speech dataset with:

WAV files
Transcriptions
Speaker information
Lexicon and phone mappings

### Clone Repository
git clone https://github.com/Git-hub-sakshisingh/kashmiri-gop-dnn.git

### Enter Repository
cd kashmiri-gop-dnn
### 3. Install Requirements
pip install -r requirements.txt

### 4. Configure path.sh

Edit path.sh:
nano path.sh

### Set the following paths:
export KALDI_ROOT=/path/to/kaldi-trunk
export DATA_ROOT=/path/to/dataset
export MODEL_ROOT=/path/to/acoustic-model

### 5. Compile Custom GOP Binary
cp compute-gop.cc $KALDI_ROOT/src/bin/
cd $KALDI_ROOT/src
make

```bash
pip install -r requirements.txt
