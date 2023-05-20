import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(SwipeGame());
}

class SwipeGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swipe Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SwipeGamePage(),
    );
  }
}

class SwipeGamePage extends StatefulWidget {
  @override
  _SwipeGamePageState createState() => _SwipeGamePageState();
}

class _SwipeGamePageState extends State<SwipeGamePage> {
  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
  ];
  late Color currentColor;
  late Color targetColor;
  Random random = Random();

  @override
  void initState() {
    super.initState();
    currentColor = colors[random.nextInt(colors.length)];
    targetColor = colors[random.nextInt(colors.length)];
  }

  void changeColor() {
    setState(() {
      currentColor = colors[random.nextInt(colors.length)];
      targetColor = colors[random.nextInt(colors.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Swipe Game'),
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dx > 0) {
            // Swipe right
            if (currentColor == targetColor) {
              // Color matched
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('Congratulations!'),
                  content: Text('Color matched!'),
                  actions: [
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        changeColor();
                      },
                    ),
                  ],
                ),
              );
            } else {
              // Color not matched
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('Oops!'),
                  content: Text('Color not matched!'),
                  actions: [
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        changeColor();
                      },
                    ),
                  ],
                ),
              );
            }
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Swipe to match the color',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 30),
              Container(
                height: 150,
                width: 150,
                color: currentColor,
              ),
              SizedBox(height: 30),
              Text(
                'Swipe right when the color matches',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Container(
                height: 50,
                width: 50,
                color: targetColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
