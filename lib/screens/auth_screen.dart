import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";
import 'package:flutter/services.dart';
import "package:cloud_firestore/cloud_firestore.dart";
// import "package:firebase_storage/firebase_storage.dart";

import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  Future<void> _submitAuthForm(
    String email,
    String password,
    String username,
    String image,
    bool isLogin,
    BuildContext ctx,
  ) async {
    AuthResult authResult;

    try {
      setState(() {
        _isLoading = true;
      });

      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        
        // setup the path
        // final ref = FirebaseStorage.instance
        //   .ref()
        //   .child("user_image")
        //   .child(authResult.user.uid + ".jpg");

        // await ref.putFile(image).onComplete;

        // final url = await ref.getDownloadURL();
        
        // when signing up, new user is added (.document instead of .add to generate our own ID)
        await Firestore.instance
          .collection("users")
          .document(authResult.user.uid)
          .setData({
            "username": username,
            "email": email,
            "url": "https://images.unsplash.com/photo-1611267254323-4db7b39c732c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8Y3V0ZSUyMGNhdHxlbnwwfHwwfHw%3D&w=1000&q=80",
          });
      }

    } on PlatformException catch (error) {
      var message = "An error occurred, please check your credentials!";

      if (error.message != null) message = error.message;

      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );

      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}