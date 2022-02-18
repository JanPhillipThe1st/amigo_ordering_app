import 'package:amigo_ordering_app/responsive/mobile_screen_layout.dart';
import 'package:amigo_ordering_app/responsive/responsive_layout.dart';
import 'package:amigo_ordering_app/responsive/web_screen_layout.dart';
import 'package:amigo_ordering_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amigo_ordering_app/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'utils/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => UserProvider(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Instagram Clone',
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: mobileBackgroundColor,
          ),
          // home: const LoginScreen(),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                // Checking if the snapshot has any data or not
                if (snapshot.hasData) {
                  // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
                  return const ResponsiveLayout(
                    mobileScreenLayout: MobileScreenLayout(),
                    webScreenLayout: WebScreenLayout(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('${snapshot.error}'),
                  );
                }
              }

              // means connection to future hasnt been made yet
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return const LoginScreen();
            },
          ),
        ));
  }
}
