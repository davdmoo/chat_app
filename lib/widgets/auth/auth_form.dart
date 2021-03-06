// import "dart:io";

import "package:flutter/material.dart";

import "../pickers/user_image_picker.dart";

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String password,
    String username,
    String image,
    bool isLogin,
    BuildContext ctx,
  ) submitAuth;
  final bool isLoading;

  AuthForm(this.submitAuth, this.isLoading);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = "";
  var _userName = "";
  var _userPassword = "";
  String _userImageFile;

  void _pickedImage(String image) {
    _userImageFile = image;
  }

  void _submit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus(); // close the keyboard

    if (_userImageFile == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Please input an image."),
          backgroundColor: Theme.of(context).errorColor,
        )
      );

      return;
    }

    if (isValid) {
      _formKey.currentState.save();

      widget.submitAuth(
        _userEmail.trim(), // trim removes extra white space
        _userPassword.trim(),
        _userName.trim(),
        _userImageFile,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (!_isLogin) UserImagePicker(_pickedImage),
                  TextFormField(
                    key: ValueKey("email"),
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    validator: (value) {
                      if (value.isEmpty || !value.contains("@")) return "Please enter a valid email address!";

                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                    ),
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                  if (!_isLogin)
                  TextFormField(
                    key: ValueKey("username"),
                    autocorrect: true,
                    textCapitalization: TextCapitalization.words,
                    enableSuggestions: false,
                    validator: (value) {
                      if (value.isEmpty || value.length < 4) return "Username's min. characters is 4!";

                      return null;
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Username",
                    ),
                    onSaved: (value) {
                      _userName = value;
                    },
                  ),
                  TextFormField(
                    key: ValueKey("password"),
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) return "Password's min. characters is 7!";

                      return null;
                    },
                    // keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                    ),
                    onSaved: (value) {
                      _userPassword = value;
                    },
                  ),
                  SizedBox(height: 20),
                  if (widget.isLoading)
                    CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      child: Text(_isLogin ? "Login" : "Sign Up"),
                      onPressed: _submit,
                    ),
                  if (!widget.isLoading)
                    TextButton(
                      // textColor: Theme.of(context).primaryColor,
                      style: TextButton.styleFrom(primary: Colors.blueGrey),
                      child: Text(_isLogin ? "Create new account" : "Login instead"),
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}