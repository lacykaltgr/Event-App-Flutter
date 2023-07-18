import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String content;
  final bool icon;
  const CustomAppBar(this.content, this.icon, {Key? key})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: icon
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.fireplace_outlined,
                  color: Theme.of(context).primaryColor,
                ),
                Text(
                  content,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16.0,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )
          : Text(
              content,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16.0,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold),
            ),
    );
  }
}
