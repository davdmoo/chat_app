// import "dart:io";

import "package:flutter/material.dart";
// import "package:image_picker/image_picker.dart";

class UserImagePicker extends StatefulWidget {
  final void Function(String image) imagePickFn;

  UserImagePicker(this.imagePickFn);

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  String _pickedImage;

  void _pickImage() async {
    // final pickedImageFile = await ImagePicker.pickImage(
    //   source: ImageSource.camera,
    //   imageQuality: 50,
    //   maxWidth: 150,
    // );
    final pickedImageFile = "https://images.unsplash.com/photo-1611267254323-4db7b39c732c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8Y3V0ZSUyMGNhdHxlbnwwfHwwfHw%3D&w=1000&q=80";

    setState(() {
      _pickedImage = pickedImageFile;
      widget.imagePickFn(pickedImageFile);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: _pickedImage == null ? null : NetworkImage(_pickedImage),
        ),
        FlatButton.icon(
          icon: Icon(Icons.image),
          label: Text("Add Image"),
          onPressed: _pickImage,
          textColor: Theme.of(context).primaryColor,
        ),
      ],
    );
  }
}