import 'package:campfire/event/tile.dart';
import 'package:campfire/pages/pages.dart';
import 'package:flutter/material.dart';

enum eventListType { interested, own }

class Events extends StatefulWidget {
  const Events({Key? key}) : super(key: key);

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> with TickerProviderStateMixin {
  FutureBuilder buildEvents(eventListType e) {
    Future? future;
    if (e == eventListType.own) {
      future = eventsRef.where("organizerId", isEqualTo: currentUser!.id).get();
    } else if (e == eventListType.interested) {
      future =
          eventsRef.where("interested", arrayContains: currentUser!.id).get();
    }
    return FutureBuilder(
        future: future,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          List<Widget> events = snapshot.data.docs
              .map<Widget>((e) => EventTile(event: Event.fromDocument(e)))
              .toList();
          return ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: events,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 2, vsync: this);

    var appBar = const CustomAppBar("események", false);

    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        extendBodyBehindAppBar: true,
        appBar: appBar,
        body: ClipRRect(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40)),
          child: Container(
              padding: EdgeInsets.only(top: appBar.preferredSize.height + 50),
              height: MediaQuery.of(context).size.height * 0.9,
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                    width: 200,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const CreateEvent()))
                                .then((value) => setState(() {}));
                          },
                          child: Row(children: const [
                            Text("Esemény létrehozása"),
                            Icon(Icons.add)
                          ]),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).primaryColor),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        buildEvents(eventListType.interested),
                        buildEvents(eventListType.own),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TabBar(
                      labelColor: Colors.black,
                      unselectedLabelColor:
                          const Color.fromARGB(149, 156, 151, 151),
                      isScrollable: false,
                      controller: _tabController,
                      indicatorColor: Colors.transparent,
                      tabs: const [
                        Tab(
                            child: Text("összes",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ))),
                        Tab(
                            child: Text("saját",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )))
                      ],
                    ),
                  ),
                ],
              )),
        ));
  }
}
