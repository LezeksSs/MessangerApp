import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const ChatTile({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(children: [
          // icon
          Icon(Icons.person),
          // chat name
          Text(text),
        ],),
      ),
    );
  }
}
