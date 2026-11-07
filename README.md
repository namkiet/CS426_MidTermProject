# The Code Cup — Midterm Project

**Student:** Trinh Vo Nam Kiet  
**Class:** APCS 24A01  
**Student ID:** 24125013

---

## Overview

A mobile coffee shop application for "The Code Cup" that allows users to place orders, collect reward points, and manage their accounts. Built for Android as part of CS426 — Mobile Device Application Development.

**Framework:** Flutter

---

## Requirements

See [docs/SPEC.md](docs/SPEC.md) for the full specification.  
See [docs/TEST.md](docs/TEST.md) for the test plan.

---

## Installation & Run

### Prerequisites

- **Flutter** (SDK ≥3.12) — [Install guide](https://docs.flutter.dev/get-started/install)
- A connected device or emulator (Android recommended)

### Setup

```bash
# Clone the project
git clone <repo-url>

# Navigate to the project folder
cd the_code_cup

# Install dependencies
flutter pub get
```

### Run

```bash
# Launch the app
flutter run

# Run all unit tests
flutter test test/unit/

# Run a specific test file
flutter test test/unit/product_test.dart
```

> The app loads seed data on first launch. Profile edits and loyalty stamps are persisted via `SharedPreferences`.
