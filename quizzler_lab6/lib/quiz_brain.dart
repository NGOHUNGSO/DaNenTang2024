class Question {
  String questionText;
  bool questionAnswer;

  Question(this.questionText, this.questionAnswer);
}

class QuizBrain {
  int _questionIndex = 0;

  final List<Question> _questionBank = [
    Question('Bạn có thể uống nước muối để giải khát?', false),
    Question('Con người có hơn 5 giác quan?', true),
    Question('Một năm có 366 ngày trong năm nhuận?', true),
    Question('Python là một ngôn ngữ lập trình?', true),
    Question('Cá voi là loài cá?', false),
  ];

  String getQuestionText() {
    return _questionBank[_questionIndex].questionText;
  }

  bool getQuestionAnswer() {
    return _questionBank[_questionIndex].questionAnswer;
  }

  void nextQuestion() {
    if (_questionIndex < _questionBank.length - 1) {
      _questionIndex++;
    }
  }

  bool isFinished() {
    return _questionIndex >= _questionBank.length - 1;
  }

  void reset() {
    _questionIndex = 0;
  }
}
