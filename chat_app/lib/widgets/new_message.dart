import 'package:chat_app/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_emoji_picker/keyboard_emoji_picker.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NewMessageState();
  }
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _messageController.text;

    if (enteredMessage.trim().isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus();
    _messageController.clear();

    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    FirebaseFirestore.instance.collection('chat').add({
      'text': enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData.data()!['username'],
      'userImage': userData.data()!['img_url'],
    });
  }

  @override
  Widget build(BuildContext context) {
    void checkHasEmojiKeyboard() async {
      final hasEmojiKeyboard =
          await KeyboardEmojiPicker().checkHasEmojiKeyboard();

      if (hasEmojiKeyboard) {
        final emoji = await KeyboardEmojiPicker().pickEmoji();

        if (emoji != null) {
          _messageController.text =
              emoji; // Set text only when emoji is not null
        } else {
          //print('emoji adding canceled');
        }
      } else {
        //print('emoji adding not allowed');
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 5),
      decoration: const BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.all(Radius.circular(50))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              checkHasEmojiKeyboard();
            },
            icon: const Icon(Icons.sentiment_satisfied_alt),
            color: primaryTextColor,
          ),
          Expanded(
            child: TextField(
              style: const TextStyle(color: primaryTextColor),
              controller: _messageController,
              decoration: const InputDecoration(
                  hintStyle: TextStyle(color: primaryTextColor),
                  border: InputBorder.none,
                  hintText: 'Message',
                  contentPadding: EdgeInsets.only(left: 10)),
            ),
          ),
          IconButton(
            onPressed: () {
              _submitMessage();
            },
            icon: const Icon(
              Icons.image,
              color: primaryTextColor,
            ),
          ),
          IconButton(
            onPressed: () {
              _submitMessage();
            },
            icon: const Icon(
              Icons.send,
              color: primaryTextColor,
            ),
          )
        ],
      ),
    );
  }
}
