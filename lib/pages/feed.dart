import 'package:campfire/pages/pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  FeedState createState() => FeedState();
}

class FeedState extends State<Feed> with TickerProviderStateMixin {
  List<Event> feedEvents = [];
  List timelineEventIds = [];
  List answeredEventIds = [];

  @override
  void initState() {
    getTimeline();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    timelineRef
        .doc(currentUser!.id)
        .update({"timelineEvents": FieldValue.arrayRemove(answeredEventIds)});
  }

  dismissEvent(List timelineEventIds, Event event) {
    setState(() {
      timelineEventIds.remove(event.eventId);
    });
  }

  addEvent(List timelineEvents, Event event) {
    setState(() {
      timelineEventIds.remove(event.eventId);
    });
    eventsRef.doc(event.eventId).update({
      "interested": FieldValue.arrayUnion([currentUser!.id])
    });
    event.interested.add(currentUser!.id);
  }

  getTimeline() async {
    DocumentSnapshot snapshot = await timelineRef.doc(currentUser!.id).get();
    var allEvents = snapshot.get("timelineEvents");
    setState(() {
      for (var event in allEvents) {
        if (!currentUser!.ownEvents.contains(event)) {
          timelineEventIds.add(event);
        }
      }
    });
  }

  buildTimeline() {
    return Container(
        color: const Color.fromARGB(255, 253, 253, 253),
        alignment: Alignment.center,
        child: Stack(
            alignment: AlignmentDirectional.center,
            children: timelineEventIds
                .map<Widget>((id) => FutureBuilder(
                    future: eventsRef.doc(id).get(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return circularProgress();
                      }
                      Event thisEvent = Event.fromDocument(snapshot.data);
                      bool isInterested = false;
                      for (var interest in thisEvent.interests) {
                        if (currentUser!.interests.contains(interest)) {
                          isInterested = true;
                          break;
                        }
                      }
                      if (!isInterested) {
                        answeredEventIds.add(thisEvent.eventId);
                      }
                      return activeCard(thisEvent, timelineEventIds,
                          answeredEventIds, context, dismissEvent, addEvent);
                    }))
                .toList()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: const CustomAppBar("campFire", true),
        body: timelineEventIds.isNotEmpty
            ? buildTimeline()
            : Center(
                child: Text("Ennyi volt egyelőre",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 30.0))));
  }
}
