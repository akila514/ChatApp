import 'dart:io';

import 'package:chat_app/widgets/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'package:firebase_storage/firebase_storage.dart';

final firebase = FirebaseAuth.instance;

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuthState();
  }
}

class _AuthState extends State<Auth> {
  var _isLogin = true;
  final _formKey = GlobalKey<FormState>();
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredUsername = '';
  File? _selectedImage;
  var _isAuthenticating = false;

  void _submitHandler() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    } else {
      return;
    }

    if (!_isLogin && _selectedImage == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please pick a profile picture.'),
        ),
      );
      return;
    }

    try {
      setState(() {
        _isAuthenticating = true;
      });
      if (_isLogin) {
        await firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      } else {
        final userCredential = await firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user-images')
            .child('${userCredential.user!.uid}.jpg');

        await storageRef.putFile(_selectedImage!);
        final imageUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'username': _enteredUsername,
          'email': _enteredEmail,
          'img_url': imageUrl
        });
      }
    } on FirebaseAuthException catch (error) {
      setState(() {
        _isAuthenticating = false;
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? 'Authentication Failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: primaryTextColor,
                        size: 24,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'ChatApp',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: primaryTextColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  if (_isLogin)
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      width: double.infinity,
                      height: 300,
                      child: Image.asset(
                        'assets/images/AuthBG.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (_isLogin)
                    Text(
                      'Login',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontSize: 24),
                    ),
                  if (!_isLogin)
                    UserImagePicker(
                      onPickedImage: (pickedImage) {
                        setState(() {
                          _selectedImage = pickedImage;
                        });
                      },
                    ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 30),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!_isLogin)
                              TextFormField(
                                onSaved: (newValue) {
                                  setState(() {
                                    _enteredUsername = newValue!;
                                  });
                                },
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().length < 5) {
                                    return 'Username must contain atleast 5 characters';
                                  } else {
                                    return null;
                                  }
                                },
                                style: const TextStyle(color: primaryTextColor),
                                decoration: InputDecoration(
                                  label: Text(
                                    'Enter a Username',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: primaryTextColor),
                                  ),
                                ),
                                keyboardType: TextInputType.text,
                                autocorrect: false,
                                textCapitalization: TextCapitalization.none,
                              ),
                            TextFormField(
                              onSaved: (newValue) {
                                setState(() {
                                  _enteredEmail = newValue!;
                                });
                              },
                              validator: (value) {
                                if (value == null ||
                                    value.trim().length < 8 ||
                                    !value.contains('@')) {
                                  return 'Please enter a valid Email';
                                } else {
                                  return null;
                                }
                              },
                              style: const TextStyle(color: primaryTextColor),
                              decoration: InputDecoration(
                                label: Text(
                                  'Enter your Email',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: primaryTextColor),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                            ),
                            TextFormField(
                              onSaved: (newValue) {
                                setState(() {
                                  _enteredPassword = newValue!;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.trim().length < 6) {
                                  return 'Password must be at least 6 characters long';
                                } else {
                                  return null;
                                }
                              },
                              style: const TextStyle(color: primaryTextColor),
                              decoration: InputDecoration(
                                label: Text(
                                  'Enter your Password',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: primaryTextColor),
                                ),
                              ),
                              obscureText: true,
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            if (_isAuthenticating)
                              const Padding(
                                padding: EdgeInsets.all(16),
                                child: CircularProgressIndicator(),
                              ),
                            if (!_isAuthenticating)
                              ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  backgroundColor:
                                      const MaterialStatePropertyAll(
                                          buttonColor),
                                  foregroundColor:
                                      const MaterialStatePropertyAll(
                                          primaryTextColor),
                                  padding: const MaterialStatePropertyAll(
                                    EdgeInsets.symmetric(
                                        horizontal: 100, vertical: 10),
                                  ),
                                  minimumSize: MaterialStateProperty.all(
                                    const Size(double.infinity, 10),
                                  ),
                                ),
                                onPressed: () {
                                  _submitHandler();
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    _isLogin ? 'Login' : 'Signup',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            const SizedBox(
                              height: 10,
                            ),
                            if (!_isAuthenticating)
                              TextButton(
                                style: const ButtonStyle(
                                  foregroundColor: MaterialStatePropertyAll(
                                      primaryTextColor),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isLogin = !_isLogin;
                                  });
                                },
                                child: Text(
                                  _isLogin
                                      ? 'Create an account'
                                      : 'I already have an account',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              )
                          ],
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
