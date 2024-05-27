import 'dart:io';
import 'package:flutter/material.dart';
import '../services/images_service.dart';

class ViewPhotoScreen extends StatefulWidget {
  final String filename;

  ViewPhotoScreen({required this.filename});

  @override
  _ViewPhotoScreenState createState() => _ViewPhotoScreenState();
}

class _ViewPhotoScreenState extends State<ViewPhotoScreen> {
  final ImageService _imageService = ImageService();
  File? _imageFile;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchImage();
  }

  Future<void> _fetchImage() async {
    setState(() {
      isLoading = true;
    });
    try {
      final file = await _imageService.fetchImage(widget.filename);
      setState(() {
        _imageFile = file;
      });
    } catch (e) {
      print('Failed to fetch image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch image')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Photo'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : _imageFile == null
                ? Text('No image to display.')
                : Image.file(_imageFile!),
      ),
    );
  }
}
