import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String email;
  String photosUrl;
  String bio;
  List<dynamic> interests;
  List<dynamic> interestedIn;
  List<dynamic> involvedIn;
  List<dynamic> ownEvents;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.photosUrl,
      this.ownEvents = const [],
      this.bio = "",
      this.interests = const [],
      this.interestedIn = const [],
      this.involvedIn = const []});

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
        id: doc.get('id'),
        name: doc.get('name'),
        email: doc.get('email'),
        photosUrl: doc.get('photosUrl'),
        ownEvents: doc.get("ownEvents"),
        bio: doc.get('bio'),
        interests: doc.get('interests'),
        interestedIn: doc.get('interestedIn'),
        involvedIn: doc.get("involvedIn"));
  }
}
