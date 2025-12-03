# Quiz App - Project Structure Documentation

## Project Architecture

The Quiz App follows a **Clean Architecture** pattern with three main layers:

```
quizapp_exercise/
├── lib/
│   ├── data/
│   │   └── repositories/
│   │       └── quiz_repository.dart      # Data loading & persistence
│   │
│   ├── domain/
│   │   └── models/
│   │       ├── question.dart             # Question model
│   │       ├── answer.dart               # Answer model
│   │       ├── quiz.dart                 # Quiz model (contains questions & answers)
│   │       └── quiz_result.dart          # Quiz result & history models
│   │
│   ├── ui/
│   │   ├── screens/
│   │   │   ├── start_screen.dart         # Home/start screen
│   │   │   ├── question_screen.dart      # Quiz questions screen
│   │   │   ├── result_screen.dart        # Results & answers review
│   │   │   └── history_screen.dart       # Score history (BONUS)
│   │   │
│   │   └── widgets/
│   │       ├── question_widget.dart      # Question with choices widget
│   │       └── app_button.dart           # Reusable button widget
│   │
│   └── main.dart                         # App entry point
│
└── assets/
    └── quiz_data.json                    # Quiz questions data
    └── quiz_history.json                 # Score history (created on first save)
```

## Architecture Layers

### 1. **Data Layer** (`lib/data/`)
- **QuizRepository**: Handles loading quiz data from JSON and saving score history
- Responsible for file I/O operations using `path_provider`
- Provides default quiz data if file doesn't exist

### 2. **Domain Layer** (`lib/domain/`)
- **Question**: Represents a single quiz question
  - `title`: Question text
  - `choices`: List of answer choices
  - `goodChoice`: Correct answer
  
- **Answer**: Represents user's answer to a question
  - `answerChoice`: User's selected choice
  - `goodChoice`: Correct answer
  - `isCorrect()`: Method to check if answer is correct
  
- **Quiz**: Container for questions and answers
  - `questions`: List of questions
  - `answers`: User's answers
  - `getScore()`: Calculates score
  - `addAnswer()`: Adds answer to quiz
  
- **QuizResult**: Stores quiz result with details
  - `score`: Points achieved
  - `totalQuestions`: Total questions in quiz
  - `timestamp`: When quiz was taken
  - `questionResults`: Detailed results per question

### 3. **UI Layer** (`lib/ui/`)

#### Screens:
- **StartScreen**: 
  - "Start Quiz" button
  - "View History" button (BONUS)
  
- **QuestionScreen**:
  - Single question displayed
  - Multiple choice options (single selection)
  - Previous/Next navigation
  - Submit button on last question
  - Requires answer before proceeding
  
- **ResultScreen**:
  - Score display with percentage
  - Pass/Fail indicator (≥60% = pass)
  - Detailed results for each question
  - Shows user answer vs correct answer
  - "Retake Quiz" button
  - "Back to Home" button
  
- **HistoryScreen** (BONUS):
  - Lists all previous quiz attempts
  - Shows score, percentage, and date/time
  - Newest first ordering

#### Widgets:
- **QuestionWidget**: Reusable component for displaying single question with choices
- **AppButton**: Reusable button for consistent styling

## Data Persistence

### Quiz Data (`quiz_data.json`)
- JSON file containing all quiz questions
- Created on first app launch with sample questions
- Format:
```json
{
  "questions": [
    {
      "title": "Question text",
      "choices": ["Option 1", "Option 2", "Option 3"],
      "goodChoice": "Option 1"
    }
  ],
  "answers": []
}
```

### Score History (`quiz_history.json`)
- JSON file storing all completed quiz results
- Created after first quiz submission
- Format:
```json
[
  {
    "score": 4,
    "totalQuestions": 5,
    "timestamp": "2024-11-30T10:30:00.000Z",
    "questionResults": [
      {
        "question": "Question text",
        "userAnswer": "User's choice",
        "correctAnswer": "Correct choice",
        "isCorrect": true
      }
    ]
  }
]
```

## User Flow

1. **Start Screen**
   - User sees "Start Quiz" and "View History" buttons
   - Press "Start Quiz" to begin

2. **Question Screen**
   - Question displayed with progress bar
   - User selects one answer (single choice)
   - Can navigate backward/forward
   - Must answer before proceeding
   - On last question, "Submit" button appears

3. **Result Screen**
   - Score displayed with visual feedback
   - All questions reviewed with correct answers
   - Option to retake or return home

4. **History Screen** (BONUS)
   - View all previous quiz attempts
   - See scores, dates, and percentages
   - Newest attempts shown first

## Features Implemented

✅ Single choice questions only  
✅ Navigate between questions (previous/next)  
✅ Score calculation  
✅ Question results display (correct vs user answer)  
✅ JSON data persistence (questions & history)  
✅ Quiz history tracking (BONUS)  
✅ Clean Architecture pattern  
✅ Material Design UI  
✅ Progress tracking  

## Getting Started

### Prerequisites
- Flutter 3.9.2 or higher
- Dart SDK

### Installation

1. Install dependencies:
```bash
flutter pub get
```

2. Run the app:
```bash
flutter run
```

## Dependencies

- `flutter`: UI framework
- `path_provider`: Access to documents directory for JSON storage
- `cupertino_icons`: Icons package

## File Structure Summary

| File | Purpose |
|------|---------|
| `main.dart` | App initialization and navigation between screens |
| `quiz_repository.dart` | Load/save quiz data and history |
| `question.dart` | Question model with JSON serialization |
| `answer.dart` | Answer model with validation |
| `quiz.dart` | Quiz container with scoring logic |
| `quiz_result.dart` | Result storage with question-by-question details |
| `start_screen.dart` | Home screen with action buttons |
| `question_screen.dart` | Interactive quiz interface |
| `result_screen.dart` | Results display and review |
| `history_screen.dart` | Score history viewing |
| `question_widget.dart` | Reusable question display component |
| `app_button.dart` | Reusable button component |

## How It Works

1. **Initialization**: App loads quiz data from JSON file (creates default if missing)
2. **Quiz Taking**: User answers questions one by one, can navigate back/forth
3. **Scoring**: After submission, app calculates score and creates detailed results
4. **Persistence**: Results are saved to JSON history file
5. **History**: User can view all previous attempts anytime from home screen

Enjoy the Quiz App! 📚
