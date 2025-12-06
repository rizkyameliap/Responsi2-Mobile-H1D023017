import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsi2_mobile_paket1_h1d023017/services/auth_service.dart';
import 'package:responsi2_mobile_paket1_h1d023017/screens/splash_screen.dart';
import 'package:responsi2_mobile_paket1_h1d023017/screens/login_screen.dart';
import 'package:responsi2_mobile_paket1_h1d023017/screens/register_screen.dart';
import 'package:responsi2_mobile_paket1_h1d023017/screens/home_screen.dart';
import 'package:responsi2_mobile_paket1_h1d023017/screens/add_edit_screen.dart';

// 🔥 Tambahkan ini
import 'api_test.dart';

void main() {
  // 🔥 Test API terlebih dahulu
  ApiTest.testAPI();

  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Responsi 2 Mobile Paket 1 (H1D023017)',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/add': (context) => AddEditScreen(),
      },
    );
  }
}
