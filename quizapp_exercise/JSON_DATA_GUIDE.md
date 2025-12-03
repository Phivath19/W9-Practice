# Example JSON Data Files

## How JSON Files Work

The Quiz App uses two JSON files to persist data:

1. **quiz_data.json** - Contains all quiz questions (created on first app launch)
2. **quiz_history.json** - Contains history of all completed quizzes (created after first quiz)

---

## 1. quiz_data.json - Quiz Questions

### File Location
```
Android: /data/user/0/com.example.quizapp_exercise/documents/quiz_data.json
iOS: /Documents/quiz_data.json
```

### Structure & Example

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
    },
    {
      "title": "What is the capital of France?",
      "choices": ["London", "Paris", "Berlin"],
      "goodChoice": "Paris"
    },
    {
      "title": "What is 2 + 2?",
      "choices": ["3", "4", "5"],
      "goodChoice": "4"
    },
    {
      "title": "Which planet is closest to the Sun?",
      "choices": ["Venus", "Mercury", "Mars"],
      "goodChoice": "Mercury"
    }
  ],
  "answers": []
}
```

### Field Descriptions

| Field | Type | Description |
|-------|------|-------------|
| `questions` | Array | List of all quiz questions |
| `questions[].title` | String | The question text |
| `questions[].choices` | Array | 3 answer options to choose from |
| `questions[].goodChoice` | String | The correct answer (must match one in choices) |
| `answers` | Array | Empty when exported, used during quiz |

### JSON Modification

You can add more questions by editing this file:

```json
{
  "title": "Your question here?",
  "choices": ["Option A", "Option B", "Option C"],
  "goodChoice": "Option A"
}
```

---

## 2. quiz_history.json - Quiz Results (BONUS)

### File Location
```
Android: /data/user/0/com.example.quizapp_exercise/documents/quiz_history.json
iOS: /Documents/quiz_history.json
```

### Structure & Example

```json
[
  {
    "score": 3,
    "totalQuestions": 5,
    "timestamp": "2024-11-30T10:15:30.123456Z",
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
      },
      {
        "question": "What is the capital of France?",
        "userAnswer": "Paris",
        "correctAnswer": "Paris",
        "isCorrect": true
      },
      {
        "question": "What is 2 + 2?",
        "userAnswer": "4",
        "correctAnswer": "4",
        "isCorrect": true
      },
      {
        "question": "Which planet is closest to the Sun?",
        "userAnswer": "Venus",
        "correctAnswer": "Mercury",
        "isCorrect": false
      }
    ]
  },
  {
    "score": 4,
    "totalQuestions": 5,
    "timestamp": "2024-11-30T15:45:22.987654Z",
    "questionResults": [
      {
        "question": "Who is the best teacher?",
        "userAnswer": "Roman",
        "correctAnswer": "Roman",
        "isCorrect": true
      },
      {
        "question": "What is the best color?",
        "userAnswer": "Blue",
        "correctAnswer": "Blue",
        "isCorrect": true
      },
      {
        "question": "What is the capital of France?",
        "userAnswer": "Paris",
        "correctAnswer": "Paris",
        "isCorrect": true
      },
      {
        "question": "What is 2 + 2?",
        "userAnswer": "5",
        "correctAnswer": "4",
        "isCorrect": false
      },
      {
        "question": "Which planet is closest to the Sun?",
        "userAnswer": "Mercury",
        "correctAnswer": "Mercury",
        "isCorrect": true
      }
    ]
  }
]
```

### Field Descriptions

| Field | Type | Description |
|-------|------|-------------|
| `score` | int | Number of correct answers |
| `totalQuestions` | int | Total number of questions in the quiz |
| `timestamp` | string (ISO 8601) | Date and time when quiz was completed |
| `questionResults` | Array | Results for each individual question |
| `question` | string | The question text |
| `userAnswer` | string | The answer the user selected |
| `correctAnswer` | string | The correct answer |
| `isCorrect` | boolean | Whether user's answer was correct |

### How History is Created

1. User completes a quiz and clicks "Submit"
2. App calculates score and creates `QuizResult`
3. App saves `QuizResult` to `quiz_history.json`
4. New entries are appended to the JSON array

### Data Growth

- First quiz: Creates file with 1 entry
- Second quiz: Appends entry (now 2 entries)
- After 10 quizzes: File contains 10 entries (oldest to newest)

---

## 3. JSON Serialization in Code

### Loading Quiz Data

```dart
// In quiz_repository.dart
Future<Quiz> loadQuiz() async {
  final file = await _getFile('quiz_data.json');
  final content = await file.readAsString();
  final json = jsonDecode(content) as Map<String, dynamic>;
  return Quiz.fromJson(json);
}
```

### Saving Quiz Result

```dart
// In quiz_repository.dart
Future<void> saveQuizResult(QuizResult result) async {
  final history = await loadQuizHistory();
  history.add(result);
  
  final file = await _getFile('quiz_history.json');
  final json = jsonEncode(
    history.map((r) => r.toJson()).toList(),
  );
  await file.writeAsString(json);
}
```

### Model Serialization

```dart
// In question.dart
factory Question.fromJson(Map<String, dynamic> json) {
  return Question(
    title: json['title'] as String,
    choices: List<String>.from(json['choices'] as List),
    goodChoice: json['goodChoice'] as String,
  );
}

Map<String, dynamic> toJson() {
  return {
    'title': title,
    'choices': choices,
    'goodChoice': goodChoice,
  };
}
```

---

## 4. First Time Setup

### On First App Launch

When the app starts for the first time:

1. **Check** if `quiz_data.json` exists
2. **If NO**: Create it with default questions
3. App displays Start Screen
4. User can start taking quizzes

```dart
// In main.dart initialization
Future<void> _loadQuizData() async {
  await _repository.initializeQuizData(); // Creates default if missing
  final quiz = await _repository.loadQuiz();
  setState(() {
    _quiz = quiz;
    _isLoading = false;
  });
}
```

### Default Quiz Data

The app includes 5 sample questions:

```
1. "Who is the best teacher?"
   - Roman, Honay, Leangqy → Roman

2. "What is the best color?"
   - Blue, Red, Green → Blue

3. "What is the capital of France?"
   - London, Paris, Berlin → Paris

4. "What is 2 + 2?"
   - 3, 4, 5 → 4

5. "Which planet is closest to the Sun?"
   - Venus, Mercury, Mars → Mercury
```

---

## 5. Modifying Quiz Questions

### Option A: Edit JSON File Directly

1. Connect device with adb (Android) or Xcode (iOS)
2. Navigate to documents folder
3. Open `quiz_data.json` in text editor
4. Add/modify questions
5. Save file
6. Restart app

### Option B: Programmatically

Modify `_getDefaultQuiz()` in `quiz_repository.dart`:

```dart
Quiz _getDefaultQuiz() {
  return Quiz(
    questions: [
      Question(
        title: "Your new question?",
        choices: ["A", "B", "C"],
        goodChoice: "A",
      ),
      // Add more questions here
    ],
  );
}
```

---

## 6. Data File Size

### Typical File Sizes

- `quiz_data.json`: ~500 bytes - 2 KB
- `quiz_history.json` (10 quizzes): ~5-10 KB
- `quiz_history.json` (100 quizzes): ~50-100 KB

### Performance

- Loading quiz: < 1ms
- Saving result: < 5ms
- Loading history: < 10ms (even with 100 entries)

---

## 7. Data Backup & Export

### Accessing Files

**Android (with USB debugging enabled):**
```bash
adb pull /data/user/0/com.example.quizapp_exercise/documents/quiz_history.json
```

**iOS (with Xcode):**
```
Window → Devices → Select Device → Select App → Download Container
```

### Manual Backup

Save JSON files to:
- Cloud storage (Google Drive, OneDrive, etc.)
- Email
- USB drive
- Git repository

---

## 8. Troubleshooting

### Issue: History not saving
- **Check**: File permissions
- **Check**: Device storage space
- **Check**: JSON file corruption
- **Solution**: Delete JSON files, restart app

### Issue: Questions not updating
- **Check**: JSON syntax is valid
- **Check**: File is in correct location
- **Check**: App has permission to read file
- **Solution**: Re-create default quiz data

### Issue: Quiz crashes when loading
- **Check**: JSON is valid (use jsonlint.com)
- **Check**: Field names match exactly
- **Check**: Data types are correct
- **Solution**: Restore from backup

---

## 9. JSON Best Practices

✅ **DO:**
- Keep field names consistent
- Use proper data types (string, int, boolean, array)
- Validate JSON syntax before modifying
- Make backups before editing
- Use ISO 8601 for timestamps

❌ **DON'T:**
- Modify JSON files while app is running
- Use special characters in choices
- Leave trailing commas in JSON
- Edit JSON without proper tools
- Change field names after app is deployed

---

## Summary

The Quiz App uses two JSON files:

| File | Purpose | Format | Size |
|------|---------|--------|------|
| quiz_data.json | Questions | Array of question objects | Small |
| quiz_history.json | Results | Array of result objects | Grows with use |

Both files are:
- Created automatically on first use
- Stored in app documents directory
- Read/written using `path_provider`
- Serialized using model classes
- Available for backup/export

This approach ensures:
- ✅ Data persists between app sessions
- ✅ User can view quiz history
- ✅ Easy to add/modify questions
- ✅ Cross-platform compatibility
- ✅ Human-readable data format

Happy coding! 📝
