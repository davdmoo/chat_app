import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class NewMessage extends StatefulWidget {

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = "";
  final _controller = TextEditingController();

  void _sendMessage() {
    FocusScope.of(context).unfocus();

    Firestore.instance.collection("chat")
      .add({
        "text": _enteredMessage,
        "createdAt": Timestamp.now(), // from cloud firestore
        // "userId": ,
      });
    
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Send a message..",
              ),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            icon: Icon(Icons.send),
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
          ),
        ],
      ),
    );
  }
}