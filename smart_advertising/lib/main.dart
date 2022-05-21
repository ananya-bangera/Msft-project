import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_advertising/pages/authenticationService.dart';
import 'package:smart_advertising/pages/home.dart';
import 'package:smart_advertising/pages/registeration.dart';
import 'package:smart_advertising/pages/onboarding.dart';
import 'package:smart_advertising/pages/Classes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/auth.dart';
import 'package:flutter/services.dart';

Future <void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp();
  runApp(myApp());
}

class myApp extends StatelessWidget {
  const myApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_)=> AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthenticationService>().authStateChanges, initialData: null,
        )
      ],
    child:MaterialApp(
      title: 'Adv',
      debugShowCheckedModeBanner: false,
      themeMode:ThemeMode.system,
      theme: ThemeClass.lightTheme,
      darkTheme: ThemeClass.darkTheme,

      initialRoute: '/',
      routes: {
        '/':(context) => SignInPage()//RegisterationScreen() //AuthenticationWrapper()// OnBoardingPage(),
        // '/auth':(context) => AuthenticationWrapper(),

      },
    ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    if(firebaseUser != null){
      return Home();
    }
    return SignInPage();
  }
}

