MindGuard — On-Device Behavioral Risk Detection (Demo)

MindGuard is a proof-of-concept system for early mental health risk detection using passive behavioral signals observed at the device / OS level.

This repository demonstrates the inference pipeline and system design, not a production deployment.


---

Problem

Mental health deterioration is typically detected too late because current approaches depend on:

Self-reporting

Questionnaires

Clinical visits after symptoms escalate


However, behavioral changes often appear weeks earlier in everyday device interactions such as sleep timing, interaction velocity, and session fragmentation. These signals currently go unused.


---

Core Idea

Smartphones already observe human behavior continuously.

MindGuard models these signals to:

Learn a personal behavioral baseline

Detect deviations from normal patterns

Flag early risk indicators before symptoms are obvious


This system does not diagnose mental health conditions.
It identifies risk patterns and behavioral anomalies only.


---

What This Repository Contains

This repository contains a Flutter-based demo simulator that showcases:

Behavioral signal abstraction

Baseline modeling

Explainable risk inference

Operator-style diagnostic UI


Because OS-level permissions are not available in a hackathon environment, behavioral inputs are simulated to demonstrate the system end-to-end.


---

Repository Structure

lib/
Contains all core source code (simulation, inference logic, and UI)

lib/main.dart
Simulation engine, behavioral analysis logic, and diagnostic dashboard

lib/splash_screen.dart
System boot and initialization sequence


screenshots/
Optional UI reference images

pubspec.yaml
Flutter dependencies

README.md
Project documentation

Judges should begin with lib/main.dart to understand the full pipeline.


---

How the System Works

1. Behavioral Signal Abstraction (Simulated)

The system models high-level behavioral indicators such as:

Night-time device usage as a circadian rhythm proxy

Scroll velocity as a dopaminergic engagement proxy

Touch jitter and micro-movements as a motor stability proxy


No content is accessed or inspected.

2. Baseline Modeling

Behavior is evaluated relative to a learned personal baseline.
The system focuses on change over time, not absolute thresholds.

3. Risk Inference

An explainable, weighted heuristic model produces:

A normalized risk score (0–100)

Neutral behavioral markers describing detected patterns


No diagnosis or labeling is performed.

4. Operator Console

The UI presents:

A live telemetry stream

A visible processing phase

A final risk assessment summary


This design reflects how such a system would appear as an internal or OS-level diagnostic service.


---

Privacy and Ethics

MindGuard is designed with privacy as a core constraint:

No microphone access

No camera access

No message or content inspection

No diagnosis or medical labeling

No external data transmission in this demo


All inference is intended to run on-device in a production scenario.


---

Why This Is a Demo

True OS-level integration requires:

Platform-level permissions

OEM or operating system support

Framework or kernel hooks


This repository intentionally focuses on system logic and inference design, not platform-specific integration details.

The simulator exists to make the system:

Reviewable

Testable

Understandable in a hackathon setting



---

Intended Impact

MindGuard aims to enable:

Earlier awareness of mental health risk

Preventive intervention

Reduced dependence on late clinical response


Potential application contexts include:

Students

Professionals

High screen-time individuals

Institutional wellness programs



---

Disclaimer

This project is a technical concept demonstration created for a hackathon.

It is not a medical device and does not provide diagnosis, treatment, or clinical recommendations.


---

Summary

MindGuard demonstrates how on-device behavioral intelligence can shift mental health care from reaction to prevention by using systems that already exist in everyday devices.
