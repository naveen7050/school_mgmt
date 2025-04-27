import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Homework extends StatefulWidget {
  const Homework({super.key});

  @override
  State<Homework> createState() => _Notice_EventsState();
}

class _Notice_EventsState extends State<Homework> {
  XFile? _imagefile;
  final ImagePicker imagePicker = ImagePicker();

  bool _isUploading = false; // For progress indicator

  Future<void> _pickedimage() async {
    // Ask user to pick image from camera or gallery
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text('Camera'),
            onTap: () => Navigator.pop(context, ImageSource.camera),
          ),
          ListTile(
            leading: Icon(Icons.photo),
            title: Text('Gallery'),
            onTap: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
      ),
    );

    if (source != null) {
      final XFile? pickedFile = await imagePicker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imagefile = pickedFile;
        });
        print("image path: ${_imagefile!.path}");
      }
    }
  }

  Future<void> uploadImageToFirebase() async {
    if (_imagefile == null) return;

    setState(() {
      _isUploading = true;
    });

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref =
        FirebaseStorage.instance.ref().child('notice_images/$fileName.jpg');

    try {
      await ref.putFile(File(_imagefile!.path));
      String downloadURL = await ref.getDownloadURL();
      print("Image uploaded! Download URL: $downloadURL");
    } catch (e) {
      print("Upload failed: $e");
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.home_work, size: 50, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'Homework',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  'Add Homework',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: _pickedimage,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                alignment: Alignment.center,
                child: _imagefile != null
                    ? Image.file(
                        File(_imagefile!.path),
                        fit: BoxFit.cover,
                        width: double.infinity,
                      )
                    : Text('Tap to select image'),
              ),
            ),
            SizedBox(height: 20),
            
            SizedBox(height: 50),
            _isUploading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: uploadImageToFirebase,
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      fixedSize: const Size(360, 50),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
