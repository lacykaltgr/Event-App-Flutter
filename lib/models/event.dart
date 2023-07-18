import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String eventName;
  String eventId;
  String photoUrl;
  String location;
  String description;
  String organizerId;
  List<dynamic> interests;
  List<dynamic> involved;
  List<dynamic> interested;
  DateTime date;
  int maxNumber;

  Event(
      {required this.eventName,
      required this.eventId,
      required this.location,
      required this.description,
      required this.organizerId,
      required this.interests,
      this.involved = const <dynamic>[],
      this.interested = const <dynamic>[],
      required this.date,
      required this.maxNumber,
      required this.photoUrl});

  factory Event.fromDocument(DocumentSnapshot doc) {
    return Event(
        eventName: doc.get('eventName'),
        location: doc.get('location'),
        description: doc.get('description'),
        eventId: doc.get('eventId'),
        organizerId: doc.get('organizerId'),
        interests: doc.get('interests'),
        interested: doc.get('interested'),
        involved: doc.get('involved'),
        date: doc.get('date').toDate(),
        maxNumber: doc.get("maxNumber"),
        photoUrl: doc.get("photoUrl"));
  }
}
