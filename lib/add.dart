import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo_dart;

class AddItemPage extends StatefulWidget {
  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _image;

  String _selectedLibrary = 'Books'; // Default library selection

  Future<void> _addItem() async {
      var db = await mongo_dart.Db.create(
        "mongodb+srv://johnstonharlea:I62V4Lsg3tjSkxzC@cluster0.ryaxisq.mongodb.net/dart_DB?retryWrites=true&w=majority&appName=Cluster0");
      await db.open(secure: true);
    var collection;

    if (_selectedLibrary == 'Books') {
      collection = db.collection('books');
    } else if (_selectedLibrary == 'Video Games') {
      collection = db.collection('videoGames');
    } else if (_selectedLibrary == 'Vinyls') {
      collection = db.collection('vinyls');
    }

    await db.open();
    await collection.insertOne({
      'name': _nameController.text,
      'description': _descriptionController.text,
      'image': _image != null ? _image!.readAsBytesSync() : null,
    });
    await db.close();

    // Clear text fields and image after adding item
    _nameController.clear();
    _descriptionController.clear();
    setState(() {
      _image = null;
    });

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Item added successfully.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: _selectedLibrary,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLibrary = newValue!;
                });
              },
              items: <String>['Books', 'Video Games', 'Vinyls']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: _getImage,
              child: _image != null
                  ? Image.file(
                      _image!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addItem,
              child: Text('Add Item'),
            ),
          ],
        ),
      ),
    );
  }
}