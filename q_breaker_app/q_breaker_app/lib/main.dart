
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:q_breaker_app/fetching_data.dart';
import 'package:q_breaker_app/firebase_options.dart';
import 'package:q_breaker_app/welcome.dart';



void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase based on platform
  await Firebase.initializeApp(

    options: DefaultFirebaseOptions.currentPlatform,

  );

  //UserProvider userProvider = UserProvider();
  runApp(MultiProvider(
    
    providers: [
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => CafProvider()),
    ],
    child: const MyApp(),
  )
  );

}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Q-Breaker App',
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
    );
  }
}

