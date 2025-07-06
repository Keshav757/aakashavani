import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration duration;

  const TypewriterText({
    super.key,
    required this.text,
    this.style,
    this.duration = const Duration(milliseconds: 100),
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  String _visibleText = '';
  int _currentCharIndex = 0;
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() {
    _visibleText = '';
    _currentCharIndex = 0;

    _typingTimer?.cancel();
    _typingTimer = Timer.periodic(widget.duration, (timer) {
      if (_currentCharIndex < widget.text.length) {
        setState(() {
          _visibleText += widget.text[_currentCharIndex];
          _currentCharIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void didUpdateWidget(covariant TypewriterText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _startTyping();
    }
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _visibleText,
      style: widget.style,
      textAlign: TextAlign.center,
    );
  }
}
