// child_model.dart
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChildModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addChild({
    required String name,
    required String dob,
    required String height,
    required String weight,
    required String bloodGroup,
    required String fatherName,
    required String motherName,
    required String address,
    required File? imageFile,
  }) async {
    final uid = _auth.currentUser!.uid;
    String imageUrl = '';
    if (imageFile != null) {
      imageUrl = await _uploadImage('children/$name', imageFile);
    }

    DocumentReference childRef = _firestore.collection('parents').doc(uid).collection('children').doc();
    await childRef.set({
      'id': childRef.id,
      'name': name,
      'dob': dob,
      'height': height,
      'weight': weight,
      'blood_group': bloodGroup,
      'father_name': fatherName,
      'mother_name': motherName,
      'address': address,
      'image': imageUrl,
    });
  }

  Future<void> deleteChild(DocumentSnapshot childDoc) async {
    if (childDoc['image'] != null) {
      await FirebaseStorage.instance.refFromURL(childDoc['image']).delete();
    }
    await _firestore.collection('parents').doc(_auth.currentUser!.uid).collection('children').doc(childDoc.id).delete();
  }

  Stream<QuerySnapshot> fetchChildren() {
    final uid = _auth.currentUser!.uid;
    return _firestore.collection('parents').doc(uid).collection('children').snapshots();
  }

  Future<String> _uploadImage(String path, File image) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    await storage.ref(path).putFile(image);
    return await storage.ref(path).getDownloadURL();
  }
}
