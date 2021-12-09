import 'package:flutter/material.dart';

// Назвал LoadingErrorWidget, потому что название ErrorWidget уже есть в Флаттере
class LoadingErrorWidget extends StatelessWidget {
  const LoadingErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Error'),
    );
  }
}
