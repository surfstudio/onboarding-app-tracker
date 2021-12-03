import 'package:flutter/material.dart';
import 'package:time_tracker/ui/app/app_dependencies.dart';
import 'package:time_tracker/ui/app/time_tracker_app.dart';

void main() {
  runApp(
    const AppDependencies(
      app: App(),
    ),
  );
}
