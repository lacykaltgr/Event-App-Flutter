import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../pages/pages.dart';

class Participants extends StatefulWidget {
  final Event event;

  const Participants({required this.event, Key? key}) : super(key: key);

  @override
  State<Participants> createState() => _ParticipantsState();
}

class _ParticipantsState extends State<Participants> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar("résztvevők", false),
      body: ListView(
        children: [
          Center(
              child: Text(
            widget.event.eventName,
            style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
          )),
          ...(widget.event.interested
              .map<Widget>((userid) => FutureBuilder(
                  future: usersRef.doc(userid).get(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    User user = User.fromDocument(snapshot.data);
                    return ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 20),
                                height: 80,
                                width: 80,
                                child: GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProfilePage(user: user))),
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage: CachedNetworkImageProvider(
                                        user.photosUrl),
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    user.name,
                                    style: const TextStyle(fontSize: 22),
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            eventsRef
                                                .doc(widget.event.eventId)
                                                .update({
                                              "interested":
                                                  FieldValue.arrayRemove(
                                                      [userid])
                                            });
                                            eventsRef
                                                .doc(widget.event.eventId)
                                                .update({
                                              "involved": FieldValue.arrayUnion(
                                                  [userid])
                                            });
                                            widget.event.interested
                                                .remove(userid);
                                            widget.event.involved.add(userid);
                                            setState(() {});
                                          },
                                          child: Icon(
                                            Icons.check,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 30,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            eventsRef
                                                .doc(widget.event.eventId)
                                                .update({
                                              "interested":
                                                  FieldValue.arrayRemove(
                                                      [userid])
                                            });
                                            widget.event.interested
                                                .remove(userid);
                                            setState(() {});
                                          },
                                          child: Icon(
                                            Icons.clear,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        )
                                      ])
                                ],
                              )
                            ]));
                  }))
              .toList()),
          ...(widget.event.involved
              .map<Widget>((userid) => FutureBuilder(
                  future: usersRef.doc(userid).get(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    User user = User.fromDocument(snapshot.data);
                    return ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 20),
                                height: 80,
                                width: 80,
                                child: GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProfilePage(user: user))),
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage: CachedNetworkImageProvider(
                                        user.photosUrl),
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    user.name,
                                    style: const TextStyle(fontSize: 22),
                                  ),
                                  const Text("felhasználó felvéve")
                                ],
                              )
                            ]));
                  }))
              .toList())
        ],
      ),
    );
  }
}
