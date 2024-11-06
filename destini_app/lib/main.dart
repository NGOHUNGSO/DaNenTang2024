import 'package:flutter/material.dart';

void main() => runApp(DestiniApp());

class DestiniApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: StoryPage(),
    );
  }
}

class StoryPage extends StatefulWidget {
  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  int storyIndex = 0;

  final List<Map<String, dynamic>> storyData = [
    {
      'story': 'Bạn đang đi trong rừng thì gặp một ngã rẽ. Bạn sẽ chọn?',
      'choice1': 'Đi bên trái',
      'choice2': 'Đi bên phải',
      'next1': 1,
      'next2': 2,
    },
    {
      'story': 'Bạn đã chọn đi bên trái và gặp một ngôi nhà bỏ hoang. Làm gì tiếp?',
      'choice1': 'Vào nhà',
      'choice2': 'Đi tiếp',
      'next1': 3,
      'next2': 4,
    },
    {
      'story': 'Bạn đã chọn đi bên phải và gặp một con suối. Làm gì tiếp?',
      'choice1': 'Băng qua suối',
      'choice2': 'Quay lại',
      'next1': 4,
      'next2': 0,
    },
    {
      'story': 'Bạn vào ngôi nhà và tìm thấy kho báu! Chúc mừng!',
      'choice1': 'Chơi lại',
      'choice2': '',
      'next1': 0,
      'next2': null,
    },
    {
      'story': 'Bạn đi tiếp và lạc vào rừng sâu. Kết thúc!',
      'choice1': 'Chơi lại',
      'choice2': '',
      'next1': 0,
      'next2': null,
    },
  ];

  void nextStory(int choice) {
    setState(() {
      storyIndex = storyData[storyIndex]['next$choice'] as int;
    });
  }

  @override
  Widget build(BuildContext context) {
    final story = storyData[storyIndex]['story'] as String;
    final choice1 = storyData[storyIndex]['choice1'] as String;
    final choice2 = storyData[storyIndex]['choice2'] as String?;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 15.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Center(
                child: Text(
                  story,
                  style: TextStyle(
                    fontSize: 25.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () => nextStory(1),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: Text(
                  choice1,
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
            choice2 != null
                ? Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () => nextStory(2),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text(
                  choice2,
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
