import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:universal_io/io.dart'; // To detect the platform
import 'package:provider/provider.dart';
import 'services/clock_service.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ClockService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Hide system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    // Keep screen awake
    WakelockPlus.enable();

    return MaterialApp(
      title: 'Tokei App',
      theme: ThemeData(
        fontFamily: Platform.isIOS ? 'SFProText' : 'Inter', // Set fonts
      ),
      home: const MainScreen(),
      routes: {
        '/main': (context) => const MainScreen(),
      },
    );
  }
}
