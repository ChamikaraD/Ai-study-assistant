name: AI Study Assistant

description: >
  A mobile-first AI-powered study assistant built with Flutter and FastAPI.
  Designed for Android users to upload notes, record lectures, and generate
  smart summaries with contextual Q&A.

platform: Android

features:
  - Upload notes (PDF, TXT)
  - Record lectures (speech-to-text)
  - AI-generated summaries
  - Context-based question answering
  - Study history tracking

tech_stack:
  frontend: Flutter
  backend: FastAPI
  ai_services:
    - OpenAI
    - Whisper
  database:
    - Firebase

architecture: >
  Flutter (Android App) → FastAPI Backend → AI Models → Firebase Storage

project_structure:
  lib:
    core: Shared utilities and constants
    features: Feature-based modules
    models: Data models
    routes: Navigation handling
    services: API and backend services
    widgets: Reusable UI components
  main: Entry point of application

setup:
  prerequisites:
    - Flutter SDK
    - Android Studio
    - Firebase project
  steps:
    - Clone repository
    - Run "flutter pub get"
    - Configure Firebase
    - Run "flutter run"

build:
  command: flutter build apk
