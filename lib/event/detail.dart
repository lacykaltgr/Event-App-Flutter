import 'package:cached_network_image/cached_network_image.dart';
import 'package:campfire/event/participants.dart';
import 'package:campfire/pages/pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/interest.dart';

// random user from timeline
// user who is interested/involved
// owner
enum UserType { owner, interested, involved, random }

class CardDetail extends StatefulWidget {
  final Event event;
  final Function? addEvent;
  final Function? dismissEvent;
  final List? timelineEventIds;
  const CardDetail(
      {Key? key,
      required this.event,

      //for users accessing from timeline
      this.addEvent,
      this.dismissEvent,
      this.timelineEventIds})
      : super(key: key);

  @override
  _CardDetailState createState() => _CardDetailState();
}

class _CardDetailState extends State<CardDetail> with TickerProviderStateMixin {
  bool isEventOwner = false;
  UserType userType = UserType.random;

  @override
  void initState() {
    isEventOwner = widget.event.organizerId == currentUser!.id;
    super.initState();

    if (currentUser!.id == widget.event.organizerId) {
      userType = UserType.owner;
    } else if (widget.event.involved.contains(currentUser!.id)) {
      userType = UserType.involved;
    } else if (widget.event.interested.contains(currentUser!.id)) {
      userType = UserType.interested;
    }
  }

  TextButton action(String text, Color color, Function() onpressed) {
    return TextButton(
      onPressed: onpressed,
      child: Container(
        height: 60.0,
        width: 130.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(60.0),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Container actions(Color color, List<Widget> children) {
    return Container(
        width: 600.0,
        height: 80.0,
        decoration: BoxDecoration(
          color: color,
        ),
        alignment: Alignment.center,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: children));
  }

  buildActions() {
    switch (userType) {
      case UserType.random:
        return actions(Colors.white, [
          action("Kihagyom", Colors.red, () {
            widget.dismissEvent!(widget.timelineEventIds, widget.event);
          }),
          action("Benne lennék", Colors.green, () {
            widget.addEvent!(widget.timelineEventIds, widget.event);
          })
        ]);
      case UserType.interested:
        return actions(Colors.white, [
          const Text(
            "Jelentkeztél az eseményre, a szervező lassan válaszol",
            style: TextStyle(fontStyle: FontStyle.italic),
          )
        ]);
      case UserType.involved:
        return actions(Colors.white, [action("Üzenetek", Colors.blue, () {})]);

      case UserType.owner:
        return actions(Colors.white, [
          action("Üzenetek", Colors.blue, () {}),
          action("Résztvevők", Theme.of(context).primaryColor, () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Participants(event: widget.event)));
          })
        ]);
    }
  }

  handleDeleteEvent() {
    return showDialog(
        context: context,
        builder: ((BuildContext context) {
          return SimpleDialog(
            title: const Text("Biztosan törlöd?"),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  deleteEvent();
                },
                child: const Text(
                  "Törlés!",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              SimpleDialogOption(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Mégsem"))
            ],
          );
        }));
  }

  deleteEvent() {
    eventsRef.doc(widget.event.eventId).get().then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  buildAvatar() {
    return isEventOwner
        ? ClipOval(
            child: GestureDetector(
            onTap: (() => handleDeleteEvent()),
            child: Container(
              alignment: Alignment.center,
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
              color: Colors.red,
              height: 40,
              width: 40,
            ),
          ))
        : FutureBuilder(
            future: usersRef.doc(widget.event.organizerId).get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircleAvatar();
              }
              User eventOwner =
                  User.fromDocument(snapshot.data as DocumentSnapshot);
              return GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfilePage(user: eventOwner))),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage:
                          CachedNetworkImageProvider(eventOwner.photosUrl),
                      radius: 22,
                    ),
                  ));
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Stack(
          children: [
            Image(image: CachedNetworkImageProvider(widget.event.photoUrl)),
            Positioned(
                child: Text(
                  widget.event.eventName,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                bottom: 20,
                left: 20),
            Positioned(
              child: buildAvatar(),
              top: 25,
              right: 25,
            )
          ],
        ),
        buildActions(),
        Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(20.0),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide(color: Colors.black12),
                          top: BorderSide(color: Colors.black12))),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.access_time,
                              color: Theme.of(context).primaryColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  widget.event.date.year.toString() +
                                      "." +
                                      widget.event.date.month.toString() +
                                      "." +
                                      widget.event.date.day.toString() +
                                      ".",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.map,
                              color: Theme.of(context).primaryColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(widget.event.location,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.person,
                          color: Theme.of(context).primaryColor,
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.event.involved.length.toString() +
                                  " / " +
                                  widget.event.maxNumber.toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ))
                      ],
                    )
                  ]),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 16.0),
                  child: Text(
                    "Több az eseményről...",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(widget.event.description),
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.black12),
                          top: BorderSide(color: Colors.black12))),
                  child: Interests.event(widget.event, displayType.list),
                )
              ],
            )),
      ],
    );
  }
}
