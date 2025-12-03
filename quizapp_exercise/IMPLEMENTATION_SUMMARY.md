# Quiz App - Implementation Summary

## ✅ Complete Implementation Checklist

### Core Requirements:
- ✅ **Start Quiz**: Player can initiate a new quiz from home screen
- ✅ **Answer Questions**: Answer each question one by one
- ✅ **Single Choice**: Only single-choice questions supported
- ✅ **Show Score**: Display final score and percentage
- ✅ **Question Results**: Show which questions were correct/incorrect with correct answers
- ✅ **JSON Persistence**: Quiz questions and history stored in JSON files
- ✅ **Bonus - History**: Review previous quiz scores and results

---

## Project Structure

```
lib/
├── main.dart                              ← App entry point with state management
│
├── data/
│   └── repositories/
│       └── quiz_repository.dart           ← Loads/saves JSON data
│
├── domain/
│   └── models/
│       ├── question.dart                  ← Question: title, choices, goodChoice
│       ├── answer.dart                    ← Answer: answerChoice, isCorrect()
│       ├── quiz.dart                      ← Quiz: questions, answers, getScore()
│       └── quiz_result.dart               ← Result: score, details, timestamp
│
└── ui/
    ├── screens/
    │   ├── start_screen.dart              ← Home with "Start Quiz" & "View History"
    │   ├── question_screen.dart           ← Display question & choices
    │   ├── result_screen.dart             ← Show score & review answers
    │   └── history_screen.dart            ← BONUS: Previous attempts
    │
    └── widgets/
        ├── question_widget.dart           ← Reusable question display
        └── app_button.dart                ← Reusable button component
```

---

## Class Diagrams & Models

### Question Model
```
Question
├── title: String
├── choices: List<String>
├── goodChoice: String
└── Methods:
    ├── fromJson()
    └── toJson()
```

### Answer Model
```
Answer
├── answerChoice: String
├── goodChoice: String
└── Methods:
    ├── isCorrect(): bool
    ├── fromJson()
    └── toJson()
```

### Quiz Model
```
Quiz
├── questions: List<Question>
├── answers: List<Answer>
└── Methods:
    ├── getScore(): int
    ├── addAnswer()
    ├── fromJson()
    └── toJson()
```

### QuizResult Model (BONUS)
```
QuizResult
├── score: int
├── totalQuestions: int
├── timestamp: DateTime
├── questionResults: List<QuestionResult>
└── Methods:
    ├── getPercentage(): int
    ├── fromJson()
    └── toJson()

QuestionResult
├── question: String
├── userAnswer: String
├── correctAnswer: String
├── isCorrect: bool
└── Methods:
    ├── fromJson()
    └── toJson()
```

---

## User Flow (Matches Requirements)

```
┌─────────────┐
│ Start Screen│
└──────┬──────┘
       │
       ├─→ "Start Quiz" ─→ ┌────────────────┐
       │                    │ Question Screen│
       │                    └────┬───────────┘
       │                         │
       │                    ┌────▼────────────┐
       │                    │ Answer & Proceed│
       │                    │ (Previous/Next) │
       │                    └────┬────────────┘
       │                         │
       │                    ┌────▼───────────────┐
       │                    │ Result Screen      │
       │                    │ - Score %age       │
       │                    │ - Question Results │
       │                    │ - Retake/Home      │
       │                    └────┬───────────────┘
       │                         └──→ Back Home
       │
       └─→ "View History" ─→ ┌──────────────────┐
                             │ History Screen   │
                             │ (BONUS)          │
                             │ - Previous Scores│
                             │ - Dates/Times    │
                             └──────────────────┘
```

---

## JSON Data Structure

### quiz_data.json (Created on first launch)
```json
{
  "questions": [
    {
      "title": "Who is the best teacher?",
      "choices": ["Roman", "Honay", "Leangqy"],
      "goodChoice": "Roman"
    },
    {
      "title": "What is the best color?",
      "choices": ["Blue", "Red", "Green"],
      "goodChoice": "Blue"
    }
  ],
  "answers": []
}
```

### quiz_history.json (Created after first quiz)
```json
[
  {
    "score": 3,
    "totalQuestions": 5,
    "timestamp": "2024-11-30T10:15:30.000Z",
    "questionResults": [
      {
        "question": "Who is the best teacher?",
        "userAnswer": "Roman",
        "correctAnswer": "Roman",
        "isCorrect": true
      },
      {
        "question": "What is the best color?",
        "userAnswer": "Red",
        "correctAnswer": "Blue",
        "isCorrect": false
      }
    ]
  }
]
```

---

## Screen Details

### 1️⃣ Start Screen
- App title and icon
- "Start Quiz" button → navigates to Question Screen
- "View History" button → navigates to History Screen (BONUS)

### 2️⃣ Question Screen
- **Progress Bar**: Visual indication of progress
- **Question Counter**: e.g., "Question 2 of 5"
- **Question Title**: Large text displaying the question
- **Choices**: Radio-button style selection
  - Can only select ONE option
  - Visual feedback when selected
- **Navigation Buttons**:
  - "Previous" button (disabled on first question)
  - "Next" or "Submit" button
  - Next button disabled until answer selected
  - Submit button on last question

### 3️⃣ Result Screen
- **Score Card**: 
  - Large score display (e.g., "3/5")
  - Percentage (e.g., "60%")
  - Pass/Fail message based on 60% threshold
- **Question Review**:
  - All questions listed with:
    - ✅ Correct answers in green
    - ❌ Incorrect answers in red with correct answer shown
- **Action Buttons**:
  - "Retake Quiz" → Start new attempt
  - "Back to Home" → Return to start screen

### 4️⃣ History Screen (BONUS)
- List of all previous quiz attempts
- Newest attempts first
- Each entry shows:
  - Quiz number
  - Score and percentage
  - Date and time
  - Pass/Fail indicator
- "Back to Home" button via app bar

---

## Key Features

### ✨ Single Choice Questions
- Radio button style selection
- Visual feedback on selection
- Only one answer per question

### 📊 Score Calculation
- Automatic calculation after submission
- Percentage conversion
- Pass threshold: 60%

### 💾 Data Persistence
- **Questions**: JSON file with quiz data
- **History**: JSON file with all completed quizzes
- Automatic file creation on first use
- Using `path_provider` for cross-platform file access

### 🗂️ Clean Architecture
- **Data Layer**: Repository pattern for data access
- **Domain Layer**: Business logic and models
- **UI Layer**: Screen and widget components
- Clear separation of concerns

### ♻️ Reusable Components
- `QuestionWidget`: Used to display any question
- `AppButton`: Consistent button styling throughout

---

## Dependencies Added

```yaml
dependencies:
  path_provider: ^2.1.0  # For accessing documents directory
```

---

## How to Run

1. **Install dependencies**:
   ```bash
   cd quizapp_exercise
   flutter pub get
   ```

2. **Run the app**:
   ```bash
   flutter run
   ```

3. **First launch**:
   - App creates `quiz_data.json` with sample questions
   - Takes a quiz to create `quiz_history.json`

---

## File Locations

- **Quiz Data**: `/data/documents/quiz_data.json`
- **History Data**: `/data/documents/quiz_history.json`
- (Exact path varies by platform, managed by `path_provider`)

---

## Testing the App

1. **Start Quiz**: Click "Start Quiz" button
2. **Answer Questions**: Select an option for each question
3. **Navigate**: Use Previous/Next to move between questions
4. **Submit**: Click Submit on the last question
5. **View Results**: See score and detailed results
6. **Retake**: Try again with "Retake Quiz"
7. **Check History**: Go home and click "View History" to see all attempts

---

## Summary

This Quiz App demonstrates:
- ✅ Clean Architecture principles
- ✅ JSON data persistence
- ✅ Single-choice question handling
- ✅ Score calculation and display
- ✅ Comprehensive result review
- ✅ Quiz history tracking (bonus)
- ✅ Material Design UI
- ✅ Responsive navigation
- ✅ State management with StatefulWidget
- ✅ Reusable components and widgets

**Total Screens**: 4 (Start, Question, Result, History)
**Total Models**: 6 (Question, Answer, Quiz, QuizResult, QuestionResult, + Repository)
**Total Widgets**: 4 (App screens + 2 reusable widgets)

Happy quizzing! 🎉
