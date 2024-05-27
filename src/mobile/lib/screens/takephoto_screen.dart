import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/images_service.dart';
import 'view_photo_screen.dart';
import '../services/local_notification_service.dart';

class TakePhotoScreen extends StatefulWidget {
  @override
  _TakePhotoScreenState createState() => _TakePhotoScreenState();
}

class _TakePhotoScreenState extends State<TakePhotoScreen> {
  final ImagePicker _picker = ImagePicker();
  final ImageService _imageService = ImageService();
  List<String> _images = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    LocalNotificationService.initialize();
    _fetchImages();
  }

  Future<void> _fetchImages() async {
    setState(() {
      isLoading = true;
    });
    try {
      final images = await _imageService.fetchImages();
      setState(() {
        _images = images;
      });
    } catch (e) {
      print('Failed to fetch images: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch images')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _takePhoto() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        setState(() {
          isLoading = true;
        });
        await _imageService.uploadImage(File(pickedFile.path));
        await LocalNotificationService.showTextNotification(
          title: 'Upload de Imagem',
          body: 'Sua imagem foi processada com sucesso!',
        );
        await _fetchImages();
      }
    } catch (e) {
      print('Failed to take photo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to take photo')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _viewPhoto(String filename) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewPhotoScreen(filename: filename),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tirar Foto'),
        actions: _images.isNotEmpty
            ? [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _takePhoto,
                ),
              ]
            : null,
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : _images.isEmpty
                ? ElevatedButton(
                    onPressed: _takePhoto,
                    child: const Text('Tirar Foto'),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: _images.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(_images[index]),
                              onTap: () => _viewPhoto(_images[index]),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _takePhoto,
                        child: const Text('Tirar Nova Foto'),
                      ),
                    ],
                  ),
      ),
    );
  }
}
