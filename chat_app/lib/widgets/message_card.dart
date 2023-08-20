import 'package:chat_app/constants/colors.dart';
import 'package:chat_app/constants/text_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageCard extends StatelessWidget {
  const MessageCard.first({
    super.key,
    required this.userImageUrl,
    required this.username,
    required this.isMe,
    required this.text,
    required this.time,
  }) : isFirstInLine = true;

  final String? userImageUrl;
  final String? username;
  final bool isMe;
  final String text;
  final bool isFirstInLine;
  final Timestamp time;

  const MessageCard.next({
    super.key,
    required this.isMe,
    required this.text,
    required this.time,
  })  : isFirstInLine = false,
        userImageUrl = null,
        username = null;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          child: Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (isFirstInLine)
                    const SizedBox(
                      height: 18,
                    ),
                  if (username != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 13, right: 13),
                      child: Row(
                        children: [
                          if (!isMe && userImageUrl != null)
                            CircleAvatar(
                              backgroundImage: NetworkImage(userImageUrl!),
                              backgroundColor: messageTextColor,
                              radius: 15,
                            ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              username!,
                              style: normalTextStyle.copyWith(
                                  color: messageTextColor, fontSize: 16),
                            ),
                          ),
                          if (isMe && userImageUrl != null)
                            CircleAvatar(
                              backgroundImage: NetworkImage(userImageUrl!),
                              backgroundColor: messageTextColor,
                              radius: 15,
                            ),
                        ],
                      ),
                    ),
                  Container(
                    //isMe?
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF6E84BF),
                          Color.fromARGB(255, 135, 113, 165)
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: isMe
                            ? const Radius.circular(10)
                            : const Radius.circular(
                                0,
                              ),
                        bottomLeft: const Radius.circular(10),
                        bottomRight: const Radius.circular(10),
                        topRight: !isMe
                            ? const Radius.circular(10)
                            : const Radius.circular(
                                0,
                              ),
                      ),
                    ),
                    constraints: const BoxConstraints(maxWidth: 250),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 14),

                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 12),

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          text,
                          style: normalTextStyle.copyWith(
                              height: 1.3,
                              color: messageTextColor,
                              fontSize: 16),
                          softWrap: true,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          DateFormat('hh:mm a').format(
                            time.toDate(),
                          ),
                          style: const TextStyle(
                              color: thirdTextColor, fontSize: 12),
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
