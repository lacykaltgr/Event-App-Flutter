import 'package:flutter/material.dart';
import '../pages/pages.dart';

enum displayType { edit, list }
enum interest {
  sport,
  outdoors,
  food,
  videogame,
  music,
  grabadrink,
  art,
  crafts
}

class Interest {
  final interest type;
  final String description;
  final Icon icon;
  const Interest(this.type, this.description, this.icon);
}

class Interests extends StatefulWidget {
  User? user;
  Event? event;
  final bool isEvent;
  final displayType style;
  Interests.user(this.user, this.style, {this.isEvent = false, Key? key})
      : super(key: key);
  Interests.event(this.event, this.style, {this.isEvent = true, Key? key})
      : super(key: key);

  final List<Interest> interests = const [
    Interest(interest.sport, "sport", Icon(Icons.sports_basketball_rounded)),
    Interest(interest.outdoors, "kültér", Icon(Icons.terrain_rounded)),
    Interest(interest.food, "étel", Icon(Icons.restaurant_rounded)),
    Interest(interest.videogame, "videojáték", Icon(Icons.gamepad_outlined)),
    Interest(interest.music, "zene", Icon(Icons.music_note)),
    Interest(interest.grabadrink, "ital", Icon(Icons.sports_bar)),
    Interest(interest.art, "művészet", Icon(Icons.brush)),
    Interest(interest.crafts, "barkácsolás", Icon(Icons.build)),
  ];

  @override
  State<Interests> createState() => _InterestsState();
}

class _InterestsState extends State<Interests> {
  List<bool> _selections = [];
  late List<dynamic> interests;

  @override
  void initState() {
    super.initState();
    interests =
        widget.isEvent ? widget.event!.interests : widget.user!.interests;
  }

  buildEditInterest() {
    _selections = List.generate(8, (int index) => interests.contains(index));
    var counter = 0;

    return GridView.count(
        shrinkWrap: true,
        crossAxisCount: 4,
        children: widget.interests.map((e) {
          var index = ++counter - 1;
          return ToggleButtons(
            renderBorder: false,
            fillColor: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(100),
            selectedColor: Colors.white,
            isSelected: [_selections[index]],
            onPressed: (idx) {
              !_selections[index]
                  ? interests.length > 3
                      ? ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Maximum 4-et tudsz választani")))
                      : widget.isEvent
                          ? widget.event!.interests.add(index)
                          : widget.user!.interests.add(index)
                  : widget.isEvent
                      ? widget.event!.interests.remove(index)
                      : widget.user!.interests.remove(index);
              setState(() {});
            },
            children: [e.icon],
          );
        }).toList());
  }

  buildListInterest() {
    _selections = List.generate(8, (int index) => interests.contains(index));
    List<Interest> selectedicons = [];
    for (int i = 0; i < widget.interests.length; i++) {
      if (_selections[i]) {
        selectedicons.add(widget.interests[i]);
      }
    }

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: selectedicons.map((e) {
          return e.icon;
        }).toList());
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.style) {
      case displayType.edit:
        return buildEditInterest();
      case displayType.list:
        return buildListInterest();
      default:
        return const Text("Érdeklődések");
    }
  }
}
