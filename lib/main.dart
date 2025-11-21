import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/permissions_request_screen.dart';
import 'services/permission_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const BaghdanSportsApp());
}

class BaghdanSportsApp extends StatefulWidget {
  const BaghdanSportsApp({super.key});

  @override
  State<BaghdanSportsApp> createState() => _BaghdanSportsAppState();
}

class _BaghdanSportsAppState extends State<BaghdanSportsApp> {
  bool _checkingPermissions = true;
  bool _needsPermissions = false;

  @override
  void initState() {
    super.initState();
    _checkPermissionsStatus();
  }

  Future<void> _checkPermissionsStatus() async {
    final hasRequested = await PermissionService.hasRequestedPermissions();
    
    if (mounted) {
      setState(() {
        _needsPermissions = !hasRequested;
        _checkingPermissions = false;
      });
    }
  }

  void _onPermissionsHandled() {
    setState(() {
      _needsPermissions = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'بطولة كأس بعدان 18',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF00ff88),
        scaffoldBackgroundColor: const Color(0xFF051622),
        textTheme: GoogleFonts.cairoTextTheme(
          Theme.of(context).textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00ff88),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: _checkingPermissions
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: Color(0xFF00ff88)),
              ),
            )
          : _needsPermissions
              ? PermissionsRequestScreen(
                  onPermissionsHandled: _onPermissionsHandled,
                )
              : StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    // Show loading while checking auth state
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Scaffold(
                        body: Center(
                          child: CircularProgressIndicator(
                              color: Color(0xFF00ff88)),
                        ),
                      );
                    }

                    // Show home if logged in, otherwise show login
                    if (snapshot.hasData) {
                      return const HomeScreen();
                    }
                    return const LoginScreen();
                  },
                ),
    );
  }
}
