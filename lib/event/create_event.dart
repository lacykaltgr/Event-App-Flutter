import 'package:campfire/widgets/interest.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../pages/pages.dart';
import 'package:uuid/uuid.dart';
import 'package:numberpicker/numberpicker.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({Key? key}) : super(key: key);

  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  Event newEvent = Event(
      eventName: "",
      eventId: const Uuid().v4(),
      location: "",
      description: "",
      organizerId: currentUser!.id,
      interests: [],
      date: DateTime.now(),
      maxNumber: 5,
      photoUrl: "https://picsum.photos/id/158/900/600");

  int month = DateTime.now().month;
  int day = DateTime.now().day;
  int hour = DateTime.now().hour;

  createEvent() {
    currentUser!.ownEvents.add(newEvent.eventId);

    eventsRef.doc(newEvent.eventId).set({
      "eventName": newEvent.eventName,
      "eventId": newEvent.eventId,
      "location": newEvent.location,
      "description": newEvent.description,
      "organizerId": newEvent.organizerId,
      "interests": newEvent.interests,
      "date": Timestamp.fromDate(DateTime(2022, month, day, hour)),
      "interested": const [],
      "involved": const [],
      "maxNumber": newEvent.maxNumber,
      "photoUrl": newEvent.photoUrl,
    });

    usersRef.doc(currentUser!.id).update({
      "ownEvents": FieldValue.arrayUnion([newEvent.eventId])
    });
  }

  submit() {
    createEvent();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar("esemény létrehozása", false),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              TextFieldWidget(
                  label: "esemény neve",
                  text: newEvent.eventName,
                  onChanged: (name) => newEvent.eventName = name),
              const SizedBox(height: 30),
              TextFieldWidget(
                  maxLines: 6,
                  label: "esemény bővebb leírása",
                  text: newEvent.description,
                  onChanged: (des) => newEvent.description = des),
              const SizedBox(height: 30),
              TextFieldWidget(
                  label: "helyszín",
                  text: newEvent.location,
                  onChanged: (loc) => newEvent.location = loc),
              const SizedBox(height: 30),
              TextFieldWidget(
                  label: "kép url",
                  text: newEvent.photoUrl,
                  onChanged: (loc) => newEvent.photoUrl = loc),
              const SizedBox(height: 30),
              Container(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.black12),
                        top: BorderSide(color: Colors.black12))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text("hónap: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    NumberPicker(
                        itemWidth: 50,
                        minValue: 1,
                        maxValue: 12,
                        value: month,
                        onChanged: (val) => setState(() {
                              month = val;
                            })),
                    const Text("nap: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    NumberPicker(
                        itemWidth: 50,
                        minValue: 1,
                        maxValue: 30,
                        value: day,
                        onChanged: (val) => setState(() {
                              day = val;
                            })),
                    const Text("óra: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    NumberPicker(
                        itemWidth: 50,
                        minValue: 0,
                        maxValue: 23,
                        value: hour,
                        onChanged: (val) => setState(() {
                              hour = val;
                            }))
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "tagek",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Center(child: Interests.event(newEvent, displayType.edit)),
              const SizedBox(height: 30),
              const Text(
                "maximum létszám",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.black12),
                        top: BorderSide(color: Colors.black12))),
                child: NumberPicker(
                    axis: Axis.horizontal,
                    value: newEvent.maxNumber,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(30)),
                    minValue: 2,
                    maxValue: 25,
                    itemHeight: 50,
                    itemWidth: 130,
                    step: 1,
                    haptics: true,
                    onChanged: (value) => setState(() {
                          newEvent.maxNumber = value;
                        })),
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 40,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).primaryColor),
                        ),
                        child: const Text("Létrehozás..."),
                        onPressed: () => submit())),
              )
            ],
          ),
        ));
  }
}
