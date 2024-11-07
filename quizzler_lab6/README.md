
import 'package:flutter/material.dart';
import 'quiz_brain.dart';

void main() => runApp(QuizzlerApp());

QuizBrain quizBrain = QuizBrain();

class QuizzlerApp extends StatelessWidget {
@override
Widget build(BuildContext context) {
return MaterialApp(
theme: ThemeData.dark(),
home: QuizPage(),
);
}
}

class QuizPage extends StatefulWidget {
@override
_QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
List<Icon> scoreKeeper = [];

void checkAnswer(bool userAnswer) {
bool correctAnswer = quizBrain.getQuestionAnswer();

    setState(() {
      if (quizBrain.isFinished()) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Kết thúc Quiz!'),
            content: Text('Bạn đã hoàn thành bài Quiz.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    quizBrain.reset();
                    scoreKeeper.clear();
                  });
                },
                child: Text('Chơi lại'),
              ),
            ],
          ),
        );
      } else {
        if (userAnswer == correctAnswer) {
          scoreKeeper.add(Icon(Icons.check, color: Colors.green));
        } else {
          scoreKeeper.add(Icon(Icons.close, color: Colors.red));
        }
        quizBrain.nextQuestion();
      }
    });
}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Colors.grey[900],
body: Padding(
padding: EdgeInsets.symmetric(horizontal: 10.0),
child: Column(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
crossAxisAlignment: CrossAxisAlignment.stretch,
children: <Widget>[
Expanded(
flex: 5,
child: Center(
child: Text(
quizBrain.getQuestionText(),
textAlign: TextAlign.center,
style: TextStyle(
fontSize: 25.0,
),
),
),
),
Expanded(
child: Padding(
padding: EdgeInsets.all(15.0),
child: ElevatedButton(
style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
child: Text(
'True',
style: TextStyle(fontSize: 20.0),
),
onPressed: () {
checkAnswer(true);
},
),
),
),
Expanded(
child: Padding(
padding: EdgeInsets.all(15.0),
child: ElevatedButton(
style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
child: Text(
'False',
style: TextStyle(fontSize: 20.0),
),
onPressed: () {
checkAnswer(false);
},
),
),
),
Row(
children: scoreKeeper,
),
],
),
),
);
}
}
