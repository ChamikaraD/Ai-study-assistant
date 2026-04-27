# 📱 AI Study Assistant (Android)

An AI-powered study companion mobile application built using **Flutter** and **FastAPI**, designed specifically for **Android devices**. This app helps students efficiently manage notes, convert lectures to text, and generate smart summaries using AI.

---

## 🚀 Features

- 📄 **Upload Notes**  
  Supports PDF and TXT file uploads for easy study material management.

- 🎤 **Lecture Recording (Speech-to-Text)**  
  Record lectures and automatically convert speech into text.

- 🤖 **AI Summarization**  
  Generate concise summaries from long notes using AI.

- ❓ **Context-Based Q&A**  
  Ask questions from your uploaded notes and get accurate answers.

- 🕘 **Study History**  
  Keep track of previously uploaded notes and generated summaries.

---

## 🛠️ Tech Stack

### Frontend (Mobile)
- Flutter (Android only)
- Dart

### Backend
- FastAPI
- Python

### AI Services
- OpenAI API / Whisper (Speech-to-Text)

### Database
- Firebase / Supabase

---

## 📂 Project Structure

```
lib/
│
├── core/        # Core utilities and constants
├── features/    # Feature-based modules (notes, recording, etc.)
├── models/      # Data models
├── routes/      # Navigation routes
├── services/    # API and backend services
├── widgets/     # Reusable UI components
│
├── app.dart     # App configuration
└── main.dart    # Entry point
```

---

## ⚙️ Installation & Setup

### Prerequisites
- Flutter SDK installed
- Android Studio or VS Code
- Android device or emulator

### Steps

1. **Clone the repository**
```bash
git clone https://github.com/your-username/ai-study-assistant.git
cd ai-study-assistant
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app (Android only)**
```bash
flutter run
```

---

## 📱 Platform Support

- Android  

---

## 🔐 Configuration

- Add your Firebase configuration in:
  ```
  firebase.json
  ```

- Set up your API keys (OpenAI / backend) securely in your project.

---

## 🧠 How It Works

1. User uploads notes or records lectures  
2. Data is sent to FastAPI backend  
3. AI processes content (summarization / Q&A)  
4. Results are displayed in the mobile app  
