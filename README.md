# GhostAssist AI (Smog AI Clone)

GhostAssist AI is a professional, discreet desktop assistant designed for real-time interview and meeting support. Inspired by advanced real-time AI tools, it listens or receives inputs during high-stakes interactions and provides instant, structured talking points and answers.

## 🚀 Key Features

- **Stealth / Ghost Mode**: Compact, dark-themed UI designed to sit quietly on your screen without interfering with your work or appearing on screen shares.
- **Real-Time AI Intelligence**: Powered by OpenAI (`gpt-4o`) to generate precise, professional answers tailored to your specific interview or meeting context.
- **Automatic Meeting Notes**: Every question asked and answer generated is automatically cataloged in the meeting notes panel for post-meeting review.
- **Context Customization**: Easily set your meeting context (e.g., "Senior Flutter Engineer Interview", "Client Pitch") so the AI tunes its answers accordingly.

## 🛠 Tech Stack

- **Framework**: Flutter Desktop (Dart)
- **AI Backend**: OpenAI API (`gpt-4o`)
- **State Management**: Provider
- **Local Storage**: Shared Preferences

## 📦 Getting Started & Installation

### Prerequisites
- Flutter SDK (>= 3.0.0)
- OpenAI API Key

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/ahmedemadm90/ghost-assist-ai.git
   ```
2. Navigate to the project directory:
   ```bash
   cd ghost-assist-ai
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the desktop application:
   ```bash
   flutter run -d windows  # or macOS / linux
   ```

## 💡 How to Use for Interviews and Meetings

1. **Configure API Key & Context**: 
   - Click the settings icon in the top right.
   - Enter your OpenAI API Key.
   - Define your interview or meeting context (e.g., "Full-Stack Laravel & Flutter Interview").
2. **Use Stealth Mode**:
   - Click the fullscreen/collapse icon in the app bar to toggle **Ghost Mode**. This shrinks and darkens the window so you can place it discreetly beside your Zoom/Teams window.
3. **Capture & Answer**:
   - As interview questions are asked, quickly type or paste them into the input bar (or use your voice).
   - Press Enter or click **Ask AI**. The AI will instantly generate expert talking points for you to read.
4. **Review Notes**:
   - All questions and AI-generated answers are logged in the **Meeting Notes** panel on the right for easy post-interview follow-up.

## 📝 License
Private Project - All Rights Reserved.
