import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../pages/pages.dart';

class EventTile extends StatefulWidget {
  final Event event;
  const EventTile({Key? key, required this.event}) : super(key: key);

  @override
  State<EventTile> createState() => _EventTileState();
}

class _EventTileState extends State<EventTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Scaffold(body: CardDetail(event: widget.event))));
        },
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black12, width: 1),
                borderRadius: BorderRadius.circular(35)),
            margin: const EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width * 0.8,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: Column(children: [
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                              widget.event.photoUrl)),
                    ),
                  ),
                  Text(
                    widget.event.eventName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  )
                ]))));
  }
}
