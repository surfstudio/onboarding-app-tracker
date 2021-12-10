import 'package:flutter/material.dart';

GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void hideCurrentSnackBar() =>
    scaffoldMessengerKey.currentState?.hideCurrentSnackBar();

ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showSimpleSnackBar(
  String message,
) {
  return scaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(content: Text(message)),
  );
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showRevertSnackBar({
  required VoidCallback onRevert,
  String title = 'Удалено',
  String revertButtonLabel = 'Отмена',
}) {
  return scaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Expanded(child: Text(title)),
          TextButton(
            onPressed: () {
              onRevert();
              scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            },
            child: Text(revertButtonLabel),
          ),
        ],
      ),
    ),
  );
}
