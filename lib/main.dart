import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'screenDOB1/Home_dob1.dart';
import 'screenDOB2/Home_dob2.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF89CFF0), // Light blue color
          primary: const Color(0xFF1C74B3), // Blue color
          onPrimary: Colors.white, // Text color for primary color
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'lib/assets/bg.png',
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'lib/assets/logo-01.png',
                  height: 500, // Adjust the height as needed
                  errorBuilder: (context, error, stackTrace) {
                    return const Text(
                      'Image not found',
                      style: TextStyle(color: Colors.red),
                    );
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeDOB1()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20),
                      padding: const EdgeInsets.all(15),
                      backgroundColor: const Color(0xFF1C74B3), // Blue background color
                      foregroundColor: Colors.white, // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Calculate'),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeDOB2()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20),
                      padding: const EdgeInsets.all(15),
                      backgroundColor: const Color(0xFF1C74B3), // Blue background color
                      foregroundColor: Colors.white, // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Camera'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
