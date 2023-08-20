import 'package:chat_app/widgets/message_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: Text('No chat messages available yet.'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong.'),
          );
        }
        final loadedMessageData = snapshot.data!.docs;

        return ListView.builder(
            reverse: true,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 10),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final iteratingUser = loadedMessageData[index].data()['userId'];
              final curruntUser = FirebaseAuth.instance.currentUser;
              final isMe = iteratingUser == curruntUser!.uid;
              final nextIteratingUser = loadedMessageData.length > index + 1
                  ? loadedMessageData[index + 1].data()['userId']
                  : null;

              final isFirstInLine = iteratingUser != nextIteratingUser;

              if (isFirstInLine) {
                return MessageCard.first(
                    time: loadedMessageData[index].data()['createdAt'],
                    userImageUrl: loadedMessageData[index].data()['userImage'],
                    username: loadedMessageData[index].data()['username'],
                    isMe: isMe,
                    text: loadedMessageData[index].data()['text']);
              }
              return MessageCard.next(
                  time: loadedMessageData[index].data()['createdAt'],
                  isMe: isMe,
                  text: loadedMessageData[index].data()['text']);
            });
      },
    );
  }
}
