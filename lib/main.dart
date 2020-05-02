import 'dart:async';

import 'package:flutter/material.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Chat app',
        home: ChatScreen(),
      );
}

class ChatScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  var _inputController = TextEditingController();
  var _messages = <TextMessage>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat app'),
      ),
      body: Column(
        children: <Widget>[
          _buildMessageList(context),
          _buildComposer(context),
        ],
      ),
    );
  }

  _buildComposer(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: <Widget>[
          Expanded(
              child: TextField(
            controller: _inputController,
            decoration: InputDecoration.collapsed(hintText: 'Your message'),
            onSubmitted: _send,
          )),
          IconButton(icon: Icon(Icons.send), onPressed: _send)
        ],
      ),
    );
  }

  _buildMessageList(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        reverse: true,
        itemBuilder: (ctx, idx) =>
            idx < _messages.length ? _messages[idx] : null,
      ),
    );
  }

  void _send([_]) {
    final text = _inputController.text;
    if (text.trim().isNotEmpty) {
      setState(() {
        _messages.insert(0, TextMessage(text.trim(), _createAnimation()));
      });
      _inputController.clear();
    }
  }

  Animation _createAnimation() {
    final controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    final returnValue =
        CurvedAnimation(parent: controller, curve: Curves.easeOut);
    controller.forward();
    return returnValue;
  }
}

class TextMessage extends StatelessWidget {
  final Animation anim;
  final String text;

  TextMessage(this.text, this.anim);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(6),
              margin: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(1000)),
                color: Colors.grey,
              ),
              child: Icon(
                Icons.tag_faces,
                size: 32,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Alice',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                  Text(text),
                ],
              ),
            )
          ],
        ),
      ),
      opacity: anim,
    );
  }
}
