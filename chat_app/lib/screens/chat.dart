import 'package:chat_app/constants/colors.dart';
import 'package:chat_app/constants/text_styles.dart';
import 'package:chat_app/widgets/chat_messages.dart';
import 'package:chat_app/widgets/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScren extends StatelessWidget {
  const ChatScren({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: secondaryBackgroundColor,
          title: Text(
            'ChatApp',
            style: normalTextStyle.copyWith(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(
                Icons.exit_to_app,
                color: primaryTextColor,
              ),
            )
          ],
        ),
        body: const Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [Expanded(child: ChatMessages()), NewMessage()],
        ));
  }
}
