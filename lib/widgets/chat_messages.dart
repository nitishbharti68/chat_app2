
import 'package:chat_app/widgets/message_bubble.dart';
import 'package:chat_app/widgets/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'snackbar.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser;


    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, chatSnapshots) {
        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
          return const Center(
            child: Text('No chat found!'),
          );
        }

        if (chatSnapshots.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }

        final loadedMessages = chatSnapshots.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 40, left: 13, right: 13),
          reverse: true,
          itemCount: loadedMessages.length,
          itemBuilder: (ctx, index) {
            final chatMessage = loadedMessages[index].data();
            final nextChatMessage = index + 1 < loadedMessages.length
                ? loadedMessages[index + 1].data()
                : null;

            final currentMessageUserId = chatMessage['userId'] as String?;
            final nextMessageUserId = nextChatMessage != null
                ? nextChatMessage['userId'] as String?
                : null;
            final nextUserIsSame = nextMessageUserId == currentMessageUserId;

            if (currentMessageUserId == null ||
                chatMessage['text'] == null) {
              return const SizedBox.shrink(); // Skip rendering if data is null
            }

            if (nextUserIsSame) {
              return MessageBubble.next(
                message: chatMessage['text'] as String,
                isMe: authenticatedUser?.uid == currentMessageUserId,
              );
            } else {
              return MessageBubble.first(
                userImage: chatMessage['userImage'] as String?,
                username: chatMessage['username'] as String?,
                message: chatMessage['text'] as String,
                isMe: authenticatedUser?.uid == currentMessageUserId,
              );
            }
          },
        );
      },
    );
  }
}
