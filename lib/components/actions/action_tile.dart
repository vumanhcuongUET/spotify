import 'package:flutter/material.dart';

class ActionTile extends StatelessWidget {
  const ActionTile({
    Key? key,
    required this.title,
    required this.leading,
    this.onTap,
  }) : super(key: key);

  final String title;
  final Widget leading;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      width: MediaQuery.of(context).size.width,
      color: Colors.black.withOpacity(.6),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        leading: leading,
        onTap: onTap,
        // dense: true,
        horizontalTitleGap: 0,
      ),
    );
  }
}
