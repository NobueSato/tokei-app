import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/clock_service.dart';
import '../services/clock_settings_storage.dart';

class WorldClockScreen extends StatelessWidget {
  const WorldClockScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('World Clock'),
      ),
      body: Center(
        child: Text('World Clock Screen'),
      ),
    );
  }
}
