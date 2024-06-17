import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signup_login/homepage.dart';
import 'dart:io';
import 'package:signup_login/model_child.dart';

class Child extends StatelessWidget {
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
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _bloodGroupController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _picker = ImagePicker();
  File? _imageFile;
  bool _isLoading = false;

  final ChildModel _childModel = ChildModel();
  
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

  void addChild(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add new child'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _dobController,
                    decoration: InputDecoration(labelText: 'Date of Birth'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the date of birth';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _heightController,
                    decoration: InputDecoration(labelText: 'Height'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the height';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _weightController,
                    decoration: InputDecoration(labelText: 'Weight'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the weight';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _bloodGroupController,
                    decoration: InputDecoration(labelText: 'Blood Group'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the blood group';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _fatherNameController,
                    decoration: InputDecoration(labelText: 'Father\'s Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the father\'s name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _motherNameController,
                    decoration: InputDecoration(labelText: 'Mother\'s Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the mother\'s name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(labelText: 'Address'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the address';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    child: Text('Pick Image'),
                    onPressed: pickImage,
                  ),
                ],
              ),
            ),
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
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _isLoading = true;
                  });

                  await _childModel.addChild(
                    name: _nameController.text,
                    dob: _dobController.text,
                    height: _heightController.text,
                    weight: _weightController.text,
                    bloodGroup: _bloodGroupController.text,
                    fatherName: _fatherNameController.text,
                    motherName: _motherNameController.text,
                    address: _addressController.text,
                    imageFile: _imageFile,
                  );

                  setState(() {
                    _isLoading = false;
                  });

                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void deleteChild(DocumentSnapshot childDoc) async {
    await _childModel.deleteChild(childDoc);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parent Dashboard'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _childModel.fetchChildren(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final child = snapshot.data!.docs[index];
                          return ListTile(
                            title: Text(child['name']),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyHomePage(
                                    title: child['name'],
                                    childName: child['name'],
                                  ),
                                ),
                              );
                            },
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => deleteChild(child),
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
