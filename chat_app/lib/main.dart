import 'package:chat_app/screens/auth.dart';
import 'package:chat_app/screens/chat.dart';
import 'package:chat_app/screens/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:keyboard_emoji_picker/keyboard_emoji_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardEmojiPickerWrapper(
      child: MaterialApp(
          title: 'ChatApp',
          debugShowCheckedModeBanner: false,
          theme: ThemeData().copyWith(
              useMaterial3: true,
              textTheme: GoogleFonts.sourceSansProTextTheme(),
              colorScheme:
                  ColorScheme.fromSeed(seedColor: const Color(0XFF34495e))),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SplashScreen();
              }
              if (snapshot.hasData) {
                return const ChatScren();
              }
              return const Auth();
            },
          )),
    );
  }
}
