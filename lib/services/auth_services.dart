import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  // for storing data on cloud firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // for authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;
}

// for signup

