import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  XFile? _imagefile;
  final ImagePicker imagePicker = ImagePicker();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController classController = TextEditingController();
  TextEditingController sectionController = TextEditingController();
  TextEditingController rollController = TextEditingController();
  TextEditingController idController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    nameController.text = prefs.getString('name') ?? '';
    emailController.text = prefs.getString('email') ?? '';
    classController.text = prefs.getString('class') ?? '';
    sectionController.text = prefs.getString('section') ?? '';
    rollController.text = prefs.getString('roll') ?? '';
    idController.text = prefs.getString('id') ?? '';

    String? imagePath = prefs.getString('imagePath');
    if (imagePath != null) {
      setState(() {
        _imagefile = XFile(imagePath);
      });
    }
  }

  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', nameController.text);
    await prefs.setString('email', emailController.text);
    await prefs.setString('class', classController.text);
    await prefs.setString('section', sectionController.text);
    await prefs.setString('roll', rollController.text);
    await prefs.setString('id', idController.text);
    if (_imagefile != null) {
      await prefs.setString('imagePath', _imagefile!.path);
    }
  }

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
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('imagePath', _imagefile!.path);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(children: [
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.elliptical(800, 500),
                    bottomRight: Radius.elliptical(800, 500),
                  ),
                ),
              ),
              Positioned(
                bottom: -90,
                child: GestureDetector(
                  onTap: _pickedimage,
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    radius: 80,
                    backgroundImage: _imagefile != null
                        ? FileImage(File(_imagefile!.path))
                        : null,
                    child: _imagefile == null
                        ? Icon(Icons.camera_alt, size: 40, color: Colors.white)
                        : null,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 95),
          _buildTextField('Full Name', nameController),
          SizedBox(
            height: 16,
          ),
          _buildTextField('Email', emailController),
          SizedBox(
            height: 16,
          ),
          _buildTextField('Class', classController),
          SizedBox(
            height: 16,
          ),
          _buildTextField('Section', sectionController),
          SizedBox(
            height: 16,
          ),
          _buildTextField('Roll No', rollController),
          SizedBox(
            height: 16,
          ),
          _buildTextField('ID', idController),
          SizedBox(height: 60),
          ElevatedButton(
            onPressed: () {
              _saveData();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Saved Successfully!")),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              fixedSize: Size(360, 50),
            ),
            child: Text(
              'Add to Contact',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          )
        ]),
      ),
    );
  }
}

Widget _buildTextField(String label, TextEditingController controller) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Enter something',
        border: OutlineInputBorder(),
      ),
    ),
  );
}
