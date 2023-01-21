import 'package:flutter/material.dart';
import 'package:logger/logger.dart' as log;

extension StreamChatContext on BuildContext {
  String? get currentUserImage => currentUser.image;

  User? get currentUser => StreamChatCore.of(this).currentUser;
}
