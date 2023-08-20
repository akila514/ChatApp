import 'dart:io';

import 'package:chat_app/constants/colors.dart';
import 'package:chat_app/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onPickedImage});

  final void Function(File pickedImage) onPickedImage;

  @override
  State<UserImagePicker> createState() {
    return _UserImagePickerState();
  }
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? pickedImageFile;

  void pickImage() async {
    final pickedImage = await ImagePicker()
        .pickImage(source: ImageSource.camera, maxWidth: 150);

    if (pickedImage == null) {
      return;
    }

    setState(() {
      pickedImageFile = File(pickedImage.path);
    });
    widget.onPickedImage(pickedImageFile!);
  }

  void selectImageFromGallary() async {
    final pickedImage = await ImagePicker()
        .pickImage(source: ImageSource.gallery, maxWidth: 150);

    if (pickedImage == null) {
      return;
    }

    setState(() {
      pickedImageFile = File(pickedImage.path);
    });
    widget.onPickedImage(pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
              radius: 80,
              foregroundColor: backgroundColor,
              backgroundColor: primaryTextColor,
              foregroundImage:
                  pickedImageFile != null ? FileImage(pickedImageFile!) : null,
              child: pickedImageFile == null
                  ? const Icon(
                      Icons.person,
                      size: 120,
                      color: backgroundColor,
                    )
                  : null),
          const SizedBox(
            height: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () {
                  pickImage();
                },
                icon: const Icon(
                  Icons.camera_alt,
                  color: primaryTextColor,
                ),
                label: Text(
                  'Take a Picture',
                  style: smallTextStyle.copyWith(color: primaryTextColor),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  selectImageFromGallary();
                },
                icon: const Icon(Icons.photo_library_outlined,
                    color: primaryTextColor),
                label: Text(
                  'Select from Gallary',
                  style: smallTextStyle.copyWith(color: primaryTextColor),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
