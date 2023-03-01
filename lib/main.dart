import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fb_statenf_auth/pages/home_page.dart';
import 'package:fb_statenf_auth/pages/signin_page.dart';
import 'package:fb_statenf_auth/pages/signup_page.dart';
import 'package:fb_statenf_auth/pages/splash_page.dart';
import 'package:fb_statenf_auth/providers/auth/auth_provider.dart';
import 'package:fb_statenf_auth/providers/auth/auth_state.dart';
import 'package:fb_statenf_auth/providers/profile/profile_provider.dart';
import 'package:fb_statenf_auth/providers/profile/profile_state.dart';
import 'package:fb_statenf_auth/providers/signin/signin_provider.dart';
import 'package:fb_statenf_auth/providers/signin/signin_state.dart';
import 'package:fb_statenf_auth/providers/signup/signup_provider.dart';
import 'package:fb_statenf_auth/providers/signup/signup_state.dart';
import 'package:fb_statenf_auth/repositories/auth_repository.dart';
import 'package:fb_statenf_auth/repositories/profile_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthRepository>(
          create: (context) => AuthRepository(
              firebaseFirestore: FirebaseFirestore.instance,
              firebaseAuth: fbAuth.FirebaseAuth.instance),
        ),
        Provider<ProfileRepository>(
          create: (context) => ProfileRepository(
            firebaseFirestore: FirebaseFirestore.instance,
          ),
        ),
        StreamProvider<fbAuth.User?>(
          create: (context) => context.read<AuthRepository>().user,
          initialData: null,
        ),
        StateNotifierProvider< AuthProvider, AuthState>(
          create: (context) => AuthProvider(
          ),
          
        ),
        StateNotifierProvider<SigninProvider, SigninState>(
          create: (context) => SigninProvider(
          ),
        ),
        StateNotifierProvider<SignupProvider,SignupState>(
          create: (context) => SignupProvider(
//            authRepository: context.read<AuthRepository>(),
          ),
        ),
        StateNotifierProvider<ProfileProvider,ProfileState>(
          create: (context) => ProfileProvider(
          ),
        ),
      ],
      child: MaterialApp(
          title: 'Auth Provider',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: SplashPage(),
          routes: {
            SignupPage.routeName: (context) => SignupPage(),
            SigninPage.routeName: (context) => SigninPage(),
            HomePage.routeName: (context) => HomePage(),
          }),
    );
  }
}
