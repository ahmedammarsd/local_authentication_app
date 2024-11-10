import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: false,
      ),
      home: const MyHomePage(title: 'Local Authentication App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
// =============== ==================
  final LocalAuthentication auth = LocalAuthentication();
  bool isAuthenticated = false;
// =============== ==================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              isAuthenticated
                  ? "Welcome Ahmed Ammar"
                  : "Sorry ,You Are Not Phone Owner",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          if (!isAuthenticated) {
            // ===========  Check If Phone Can or Have Biometrics Or any Locks
            final bool canAuthenticatedWithBiometricsInDevice =
                await auth.canCheckBiometrics;

            try {
              if (canAuthenticatedWithBiometricsInDevice) {
                final bool isUserDidAuthenticated = await auth.authenticate(
                  localizedReason:
                      'Hello, Please Authenticated To Know The You , Or Phone Owner',
                  options: const AuthenticationOptions(
                    biometricOnly: false,
                  ),
                );

                setState(() {
                  isAuthenticated = isUserDidAuthenticated;
                });
              }
            } catch (e) {
              print(e);
            }
          } else {
            setState(() {
              isAuthenticated = false;
            });
          }
        },
        child: Icon(isAuthenticated ? Icons.lock : Icons.lock_open),
      ),
    );
  }
}
