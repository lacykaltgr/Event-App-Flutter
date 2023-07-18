import 'package:campfire/pages/pages.dart';
import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final String imagePath;
  final VoidCallback onClicked;
  final profileStyle style;

  const ProfileImage(
      {Key? key,
      required this.imagePath,
      required this.onClicked,
      required this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;

    return Center(
      child: Stack(
        children: [
          buildImage(style),
          if (style == profileStyle.myprofile ||
              style == profileStyle.editprofile)
            Positioned(
              bottom: style == profileStyle.editprofile ? 4 : 8,
              right: style == profileStyle.editprofile ? 4 : 8,
              child: buildEditIcon(style, color),
            )
        ],
      ),
    );
  }

  Widget buildImage(profileStyle style) {
    final image = NetworkImage(imagePath);

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: style == profileStyle.editprofile ? 128 : 190,
          height: style == profileStyle.editprofile ? 128 : 190,
          child: InkWell(onTap: onClicked),
        ),
      ),
    );
  }

  Widget buildEditIcon(profileStyle style, Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: Icon(
            Icons.edit,
            color: Colors.white,
            size: style == profileStyle.editprofile ? 20 : 40,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
