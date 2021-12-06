import 'package:flutter/material.dart';

GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void hideSnackBar() => scaffoldMessengerKey.currentState?.hideCurrentSnackBar();

ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showSimpleSnackBar(
  String message,
) {
  return scaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(content: Text(message)),
  );
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showRevertSnackBar({
  required bool Function(bool isReverted) onRevert,
  String title = 'Удаление...',
  String revertButtonLabel = 'Отмена',
}) {
  return scaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Expanded(child: Text(title)),
          TextButton(
            onPressed: () {
              onRevert(true);
              scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            },
            child: Text(revertButtonLabel),
          ),
        ],
      ),
    ),
  );
}
