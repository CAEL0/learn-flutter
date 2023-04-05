import "dart:async";

import "package:flutter/material.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const int _twentyFiveMinutes = 1500;
  int _totalSeconds = _twentyFiveMinutes;
  bool _isRunning = false;
  int _totalPomodoros = 0;
  late Timer _timer;

  void _onStartPressed() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      _onTick,
    );
    setState(() {
      _isRunning = true;
    });
  }

  void _onTick(Timer timer) {
    setState(() {
      _totalSeconds--;
    });
    if (_totalSeconds == 0) {
      _onPausePressed();
      setState(() {
        _totalSeconds = _twentyFiveMinutes;
        _totalPomodoros++;
      });
    }
  }

  void _onPausePressed() {
    _timer.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  String _format(int seconds) {
    return Duration(seconds: seconds)
        .toString()
        .split(".")
        .first
        .substring(2, 7);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Text(
                _format(_totalSeconds),
                style: TextStyle(
                  color: Theme.of(context).cardColor,
                  fontSize: 89,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Center(
              child: IconButton(
                iconSize: 120,
                color: Theme.of(context).cardColor,
                onPressed: _isRunning ? _onPausePressed : _onStartPressed,
                icon: Icon(
                  _isRunning
                      ? Icons.pause_circle_outline
                      : Icons.play_circle_outline,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(50),
              ),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Pomodoros",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.displayLarge!.color,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "$_totalPomodoros",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.displayLarge!.color,
                      fontSize: 58,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}
