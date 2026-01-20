import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Comentado para não travar enquanto você não configura o Firebase
  // await Firebase.initializeApp(); 
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClickforShine',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const Scaffold(
        body: Center(child: Text('ClickforShine Rodando!')),
      ),
    );
  }
}
