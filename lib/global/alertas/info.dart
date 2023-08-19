import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';

info(
  Size size,
  BuildContext context,
  String title,
  subtitle,
) {
  ElegantNotification.info(
    title: Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      )
    ),
    description: Text(
      subtitle,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      )
    ),
    width: size.width * 0.5,
    notificationPosition: NotificationPosition.topRight,
  ).show(context);
}
