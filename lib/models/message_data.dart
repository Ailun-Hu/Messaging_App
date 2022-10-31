import 'package:flutter/material.dart';

@immutable
class MessageData {
  const MessageData({
    required this.senderName,
    required this.message,
    required this.messageDate,
    required this.dataMessage,
    required this.profilePicture,
  });

  final String senderName;
  final String message;
  final DateTime messageDate;
  final String dataMessage;
  final String profilePicture;
}
