import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";

class ChatScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat App"),
        actions: <Widget>[
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryColor,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.exit_to_app),
                      SizedBox(width: 8),
                      const Text("Logout"),
                    ],
                  ),
                ),
                value: "logout",
              ),
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == "logout") FirebaseAuth.instance.signOut();
            },
          ),
        ],
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