import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(TapTheTargetGame());
}

class TapTheTargetGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tap the Target',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  static const int gameTime = 30; // Game duration in seconds
  static const double targetSize = 50.0;
  static const double targetSpeed = 150.0;
  static const int maxTaps = 10; // Maximum taps allowed
  static const String gameOverText = 'Game Over';
  static const String tapToRestartText = 'Tap to Restart';

  late Timer _timer;
  int _timeRemaining = gameTime;
  int _tapsRemaining = maxTaps;
  bool _gameOver = false;
  double _targetX = 0.0;
  double _targetY = 0.0;
  Random _random = Random();
  late Size _screenSize;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _screenSize = MediaQuery.of(context).size;
      _startGame();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startGame() {
    _gameOver = false;
    _timeRemaining = gameTime;
    _tapsRemaining = maxTaps;
    _score = 0;
    _resetTargetPosition();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else {
          _endGame();
        }
      });
    });
  }

  void _endGame() {
    _timer.cancel();
    _gameOver = true;
  }

  void _resetTargetPosition() {
    _targetX = _random.nextDouble() * (_screenSize.width - targetSize);
    _targetY = _random.nextDouble() * (_screenSize.height - targetSize);
  }

  void _handleTap() {
    if (!_gameOver && _tapsRemaining > 0) {
      setState(() {
        _score++;
        _tapsRemaining--;
        _resetTargetPosition();
        if (_tapsRemaining == 0) {
          _endGame();
        }
      });
    }
  }

  void _restartGame() {
    setState(() {
      _startGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _gameOver ? _restartGame : _handleTap,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Tap the Target'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Time: $_timeRemaining s',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 16),
                Text(
                  'Taps Remaining: $_tapsRemaining',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 16),
                _gameOver
                    ? Column(
                  children: [
                    Text(
                      gameOverText,
                      style: TextStyle(fontSize: 30),
                    ),
                    SizedBox(height: 16),
                    Text(
                      tapToRestartText,
                      style: TextStyle(fontSize: 24),
                    ),
                  ],
                )
                    : Container(
                  width: targetSize,
                  height: targetSize,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  margin: EdgeInsets.only(
                    top: _targetY,
                    left: _targetX,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Score: $_score',
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
