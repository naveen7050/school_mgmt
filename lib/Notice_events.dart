import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Notice_Events extends StatefulWidget {
  const Notice_Events({super.key});

  @override
  State<Notice_Events> createState() => _Notice_EventsState();
}

class _Notice_EventsState extends State<Notice_Events> {
  XFile? _imagefile;
  final ImagePicker imagePicker = ImagePicker();

  bool _isUploading = false;
  String? _downloadURL;

  Future<void> _pickedimage() async {
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
          _downloadURL = null;
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
      setState(() {
        _downloadURL = downloadURL;
      });
      print("Image uploaded! Download URL: $downloadURL");
    } catch (e) {
      print("Upload failed: $e");
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _clearUploadedImage() {
    setState(() {
      _imagefile = null;
      _downloadURL = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.event, size: 50, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'NOTICE AND EVENTS',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Enter Details',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: 10),

            /// Image Picker with Optional Preview and Remove Icon
            GestureDetector(
              onTap: _pickedimage,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: _imagefile != null
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.file(
                            File(_imagefile!.path),
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: _clearUploadedImage,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black54,
                                ),
                                padding: EdgeInsets.all(4),
                                child: Icon(Icons.close,
                                    size: 20, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Center(child: Text('Tap to select image')),
              ),
            ),

            SizedBox(height: 20),

            /// Pick Image Button
            ElevatedButton(
              onPressed: _pickedimage,
              child: Text(
                'Upload Image',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                fixedSize: const Size(170, 50),
              ),
            ),
            SizedBox(height: 50),

            /// Upload to Firebase Button
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
