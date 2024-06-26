import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ChatTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  Function(BuildContext)? deleteFunction;

  ChatTile({
    super.key,
    required this.text,
    required this.onTap,
    required this.deleteFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: BehindMotion(),
        children: [
          SlidableAction(
            onPressed: deleteFunction,
            icon: Icons.delete,
            backgroundColor: Colors.red.shade300,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12)),
          )
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              // icon
              Icon(Icons.person),

              const SizedBox(width: 20),
              // chat name
              Text(text),
            ],
          ),
        ),
      ),
    );
  }
}
