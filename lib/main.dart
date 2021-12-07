import 'package:flutter/material.dart';
import 'package:time_tracker/ui/app/app.dart';
import 'package:time_tracker/ui/app/app_dependencies.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const AppDependencies(
      app: App(),
    ),
  );
}
