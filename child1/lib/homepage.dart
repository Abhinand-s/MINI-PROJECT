import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';



class child extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parent Dashboard',
      home: ParentDashboard(),
    );
  }
}

class ParentDashboard extends StatefulWidget {
  @override
  _ParentDashboardState createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _genderController = TextEditingController();
  final _picker = ImagePicker();
  File? _imageFile;

  Future pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _imageFile = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      });
    } catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<String> uploadImage(String path, File image) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    try {
      await storage.ref(path).putFile(image);
    } on FirebaseException catch (e) {
      print(e);
    }

    String downloadURL = await storage.ref(path).getDownloadURL();
    return downloadURL;
  }

  void addChild(BuildContext context) {
    final uid = _auth.currentUser!.uid;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add new child'),
          content: Column(
            children: <Widget>[
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
              TextField(
                controller: _ageController,
                decoration: InputDecoration(
                  labelText: 'Age',
                ),
              ),
              TextField(
                controller: _genderController,
                decoration: InputDecoration(
                  labelText: 'Gender',
                ),
              ),
              ElevatedButton(
                child: Text('Pick Image'),
                onPressed: pickImage,
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Add'),
              onPressed: () async {
                String imageUrl = '';
                if (_imageFile != null) {
                  imageUrl = await uploadImage('children/${_nameController.text}', _imageFile!);
                }
                _firestore.collection('parents').doc(uid).collection('children').doc(_nameController.text).set({
                  'age': _ageController.text,
                  'gender': _genderController.text,
                  'image': imageUrl,
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void deleteChild(DocumentSnapshot childDoc) async {
  // Delete the child's image from Firebase Storage
  if (childDoc['image'] != null) {
    FirebaseStorage.instance.refFromURL(childDoc['image']).delete();
  }

  // Delete the child's document from Firestore
  await _firestore.collection('parents').doc(_auth.currentUser!.uid).collection('children').doc(childDoc.id).delete();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parent Dashboard'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('parents').doc(_auth.currentUser!.uid).collection('children').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data!.docs[index].id),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChildDetailsPage(childDoc: snapshot.data!.docs[index]),
                          ),
                        );
                      },
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => deleteChild(snapshot.data!.docs[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            child: Text('Add Child'),
            onPressed: () => addChild(context),
          ),
        ],
      ),
    );
  }
}

class ChildDetailsPage extends StatelessWidget {
  final DocumentSnapshot childDoc;

  ChildDetailsPage({required this.childDoc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Child Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Name: ${childDoc.id}', style: TextStyle(fontSize: 20)),
            Text('Age: ${childDoc['age']}', style: TextStyle(fontSize: 20)),
            Text('Gender: ${childDoc['gender']}', style: TextStyle(fontSize: 20)),
            childDoc['image'] != null ? Image.network(childDoc['image']) : Container(),
          ],
        ),
      ),
    );
  }
}
