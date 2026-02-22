import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: _TemporaryApp(),
    ),
  );
}

class _TemporaryApp extends StatelessWidget {
  const _TemporaryApp();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Brain Tracy'),
        ),
      ),
    );
  }
}
