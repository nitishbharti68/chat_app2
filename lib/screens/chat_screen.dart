import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/widgets/chat_messages.dart';
import 'package:chat_app/widgets/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //this is used here bcz "async" was not allowed in initState
  void setupPushNotification() async {
    final fcm = FirebaseMessaging.instance;

    final notificationSettings = await fcm.requestPermission();
    // notificationSettings.alert
    // this is used to request different kind of permissions.

    final token = await fcm
        .getToken(); // this returns the address of the device on which app is running
    print(
        token); //  you could send this token (via HTTP or the Firebase sdk) to a backend.

    fcm.subscribeToTopic(
        'chat'); // this can be used to target many devices for push notification by topic from firebase messaging console
  }

  @override
  void initState() {
    super.initState();
    setupPushNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Buddy',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AuthScreen()));
            },
            icon: const Icon(Icons.exit_to_app),
            color: Theme.of(context).colorScheme.primary,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: Stack(children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  'assets/images/back.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const ChatMessages()
          ])),
          const NewMessage()
        ],
      ),
    );
  }
}
