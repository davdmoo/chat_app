import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class ChatScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat App"),
      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection("chats/nOu0FC9ECUIuuNWUmFaM/messages")
            .snapshots(),
        builder: (ctx, streamSnapshot) { // re-executes if stream 
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final documents = streamSnapshot.data.documents;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (ctx, index) => 
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(documents[index]["text"]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Firestore.instance.collection("chats/nOu0FC9ECUIuuNWUmFaM/messages")
            .add({
              "text": "New entry",
            });
        },
      ),
    );
  }
}