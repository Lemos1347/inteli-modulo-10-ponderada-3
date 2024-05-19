import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TakePhotoScreen extends StatefulWidget {
  @override
  _TakePhotoScreenState createState() => _TakePhotoScreenState();
}

class _TakePhotoScreenState extends State<TakePhotoScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future<void> _takePhoto() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);

      setState(() {
        _image = pickedFile;
      });
    } catch (e) {
      print('Failed to take photo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tirar Foto'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? Text('Nenhuma foto tirada.')
                : Image.file(File(_image!.path)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _takePhoto,
              child: const Text('Tirar Foto'),
            ),
          ],
        ),
      ),
    );
  }
}
