import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Map<String, bool> score = {};
  final Map<String, Color> choices = {
    '🍎': Colors.red,
    '🥒': Colors.green,
    '🔵': Colors.blue,
    '🍍': Colors.yellow,
    '🍊': Colors.orange,
    '🍇': Colors.purple,
    '🥥': Colors.brown,
  };
  int index = 0;
  int index2 = 1;
  final play = AudioPlayer();
  int scoreCount = 0;
  late Timer _timer;
  int _start = 60;

  @override
  void initState() {
    super.initState();
    startTimer(); // เริ่มต้นตัวจับเวลา
  }

  @override
    void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          timer.cancel();
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Score: $scoreCount                                (Time: $_start)'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: choices.keys.map((element) {
              return Expanded(
                child: Draggable<String>(
                  data: element,
                  child: Movable(element),
                  feedback: Movable(element),
                  childWhenDragging: Movable('🐰'),
                ),
              );
            }).toList()
              ..shuffle(Random(index)),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: choices.keys.map((element) {
              return buildTarget(element);
            }).toList()
              ..shuffle(Random(index2)),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () {
          setState(() {
            score.clear();
            scoreCount = 0;
            index++;
            index2++;
            _start = 60; // รีเซ็ตเวลา
          });
          startTimer(); // เริ่มต้นตัวจับเวลาใหม่
        },
      ),
    );
  }

  Widget buildTarget(emoji) {
    return DragTarget<String>(
      builder: (context, incoming, rejects) {
        if (score[emoji] == true) {
          return Container(
            color: Colors.white,
            child: Text('Congratulations'),
            alignment: Alignment.center,
            height: 80,
            width: 200,
          );
        } else {
          return Container(
            color: choices[emoji],
            height: 80,
            width: 200,
          );
        }
      },
      onWillAccept: (data) => data == emoji,
      onAccept: (data) {
        setState(() {
          score[emoji] = true;
          play.play(AssetSource('clap.mp3'));
          scoreCount++;
        });
      },
      onLeave: (data) {
        play.play(AssetSource('boo.mp3'));
      },
    );
  }
}

class Movable extends StatelessWidget {
  final String emoji;
  Movable(this.emoji);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        height: 50,
        padding: EdgeInsets.all(15),
        child: Text(
          emoji,
          style: TextStyle(color: Colors.black, fontSize: 50),
        ),
      ),
    );
  }
}

//ระบบนับคะแนน + ตัวจับเวลา + เล่นเสียงเมื่อจับคู่ผิด + สุ่มตำแหน่งมั้งอิโมจิและสี
//nattapat 652021048
