import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:for_you/ui_components/my_colors.dart';
import 'package:for_you/ui_components/round_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'home_screen.dart';

class NewBlog extends StatefulWidget {
  const NewBlog({Key? key}) : super(key: key);

  @override
  State<NewBlog> createState() => _NewBlogState();
}

class _NewBlogState extends State<NewBlog> {

  final _formKey = GlobalKey<FormState>();
  bool showSpinner = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final postRef = FirebaseDatabase.instance.ref().child('Posts');
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  File? _image;
  final picker = ImagePicker();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Add New Blog",
          style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white),
        ),
        backgroundColor: myColors.dark,
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => dialog(context),
                child: Container(
                  height: MediaQuery.of(context).size.height * .3,
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: _image != null
                      ? Container(
                        decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(30.0),
                    ),
                        child: Image.file(
                          _image!.absolute,
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                      )
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          width: 100,
                          height: 100,
                          child: const Center(child: Icon(Icons.image)),
                        ),
                ),
              ),
              const SizedBox(height: 15),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      controller: titleController,
                      style: GoogleFonts.lato(),
                      decoration: const InputDecoration(
                        labelText: 'Enter Post Title',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter post title';
                        }
                        return null; // Return null if the input is valid
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      maxLines: 9,
                      keyboardType: TextInputType.text,
                      controller: descriptionController,
                      style: GoogleFonts.lato(),
                      decoration: const InputDecoration(
                        labelText: 'Enter Post Description',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter post description';
                        }
                        return null; // Return null if the input is valid
                      },
                    ),
                    const SizedBox(height: 25),
                    RoundButton(
                      title: "Upload Blog",
                      onPress: (){
                        if (_formKey.currentState!.validate()) {
                          _uploadPost();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _uploadPost() async {
    setState(() {
      showSpinner = true;
    });

    try {
      int date = DateTime.now().microsecondsSinceEpoch;

      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('/post$date');
      firebase_storage.UploadTask uploadTask = ref.putFile(_image!.absolute);
      await uploadTask;
      var newUrl = await ref.getDownloadURL();

      final User? user = _auth.currentUser;
      await postRef.child('Post List').child(date.toString()).set({
        'pId': date.toString(),
        'pImage': newUrl.toString(),
        'pTime': date.toString(),
        'pTitle': titleController.text,
        'pDescription': descriptionController.text,
        'uEmail': user!.email,
        'uId': user.uid,
      });

      toastMessages("Post Published");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()));
    } catch (e) {
      String errorMessage = "An unknown error occurred.";
      if (e is FirebaseException) {
        if (e.code == 'canceled') {
          errorMessage = "Upload cancelled. Please try again.";
        } else {
          errorMessage = "Error: ${e.message}";
        }
      }
      toastMessages(errorMessage);
    } finally {
      setState(() {
        showSpinner = false;
      });
    }
  }

  void toastMessages(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.black,
      fontSize: 16.0,
    );
  }

  void dialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: SizedBox(
            height: 120,
            child: Column(
              children: [
                _buildDialogOption(
                    Icons.camera, "Camera", getCameraImage, context),
                _buildDialogOption(
                    Icons.photo_library, "Gallery", getImageGallery, context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogOption(
      IconData icon, String title, Function onTap, BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
        Navigator.pop(context);
      },
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
      ),
    );
  }

  Future<void> getImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> getCameraImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
}
