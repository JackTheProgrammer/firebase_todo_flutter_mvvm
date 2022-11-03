import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/screens/auth_screen.dart';
import '/screens/todos_screen.dart';

import '/viewmodel/auth_viewmodel.dart';
import '/viewmodel/db_viewmodel.dart';
import '/viewmodel/local_storage_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ListenableProvider<AuthViewModel>(
          create: (context) => AuthViewModel(),
        ),
        ListenableProvider<DatabaseViewModel>(
          create: (context) => DatabaseViewModel(),
        ),
        ListenableProvider<LocalStorageViewModel>(
          create: (context) => LocalStorageViewModel(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: Consumer<LocalStorageViewModel>(
        builder: (context, localStorage, _) => FutureBuilder<bool?>(
          future: localStorage.getUserAuthenticationStatus(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              return const AuthScreen();
            }
            return const TodosScreen();
          },
        ),
      ),
    );
  }
}
