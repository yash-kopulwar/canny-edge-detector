# Canny Edge Detector
Implementation of Canny Edge Detection algorithm from scratch in MATLAB
<p align="center">
  <img src="images/example_image.png" width="400">
</p>

## Contents
* [Overview](#overview)
* [Motivation](#motivation)
* [Setup](#setup)
* [Repository files](#repository-files)
* [Report](#report)
* [What did I learn](#what-did-i-learn)

## Overview
Edge detection is an essential step in image analysis. It is used to detect the boundaries/edges in the image. It works by detecting discontinuities in image brightness. The points at which image brightness changes sharply are organized into a set of curved line segments called edges.

## Motivation
Edge detection is used in various fields such as image segmentation and data extraction in areas such as image processing, computer vision and machine vision. Generally, objects in any image has more intensity than the background on the edges. this makes it easier for a computer to identify or track an object once its edge is detected. These many uses of edge detection motivated me for this project

## Setup
Windows 10<br>
MATLAB Software

## Repository files
emotion_detection_text_dataset  : contains dataset (both original and after pre processing)
<br>saved_model_text_classification : saved TensorFlow model
<br>emotion_detection_2.ipnyb       : jupyter notebook 
<br>model_layers.png                : image for training model used
<br>text_cleaning.py                : custom python function to clean data for efficient tokanization
<br>

## Report
A detailed report is given in the file "edge detection report.pdf"
<p align="center">
  <img src="images/report_image.png" width="400">
</p>

## What did I learn?
* Gaussian Blur
* Sobel Filter
* Non-maximum Suppression
* Double Thresholding
* Edge Hysteresis

This project will help in further study about image processing and computer vision.

