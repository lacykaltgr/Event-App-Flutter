import 'package:campfire/pages/events.dart';
import 'package:campfire/pages/navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:campfire/pages/pages.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final usersRef = FirebaseFirestore.instance.collection('users');
final eventsRef = FirebaseFirestore.instance.collection('events');
final timelineRef = FirebaseFirestore.instance.collection('timeline');
final DateTime timestamp = DateTime.now();
User? currentUser;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  bool isAuth = false;
  late TabController tabController;
  late int pageIndex;

  @override
  void initState() {
    super.initState();

    //bejelentkezés
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    }, onError: (err) {
      throw ('Hiba a bejelentkezéskor: $err');
    });

    //az app megnyitásakor újra belépteti a felhasználót
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    }).catchError((err) {
      throw ('Hiba a bejelentkezéskor: $err');
    });

    pageIndex = 0;
    tabController = TabController(length: 3, vsync: this);

    tabController.animation!.addListener(() {
      final value = tabController.animation!.value.round();
      if (value != pageIndex && mounted) {
        onPageChanged(value);
      }
    });
  }

  //érzékeli ,hogy a felhasználó bejelentkezett-e
  handleSignIn(GoogleSignInAccount? account) async {
    if (account != null) {
      currentUser = await createUser();
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  createUser() async {
    final GoogleSignInAccount? user = googleSignIn.currentUser;
    DocumentSnapshot doc = await usersRef.doc(user!.id).get();

    if (!doc.exists) {
      await Navigator.push(context,
          MaterialPageRoute(builder: (context) => const CreateAccount()));
      usersRef.doc(user.id).set({
        "id": currentUser!.id,
        "name": currentUser!.name,
        "email": currentUser!.email,
        "photosUrl": currentUser!.photosUrl,
        "ownEvents": currentUser!.ownEvents,
        "bio": currentUser!.bio,
        "interests": currentUser!.interests,
        "interestedIn": [],
        "involvedIn": [],
        "timestamp": timestamp,
      });

      timelineRef.doc(user.id).set({"timelineEvents": []});

      doc = await usersRef.doc(user.id).get();
    }
    return User.fromDocument(doc);
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  buildAuthScreen() {
    return BottomBar(
        child: TabBarView(
          controller: tabController,
          dragStartBehavior: DragStartBehavior.down,
          physics: const BouncingScrollPhysics(),
          children: [
            const Feed(),
            const Events(),
            ProfilePage(user: currentUser!)
          ],
        ),
        currentPage: pageIndex,
        tabController: tabController,
        unselectedColor: Colors.white,
        barColor: Theme.of(context).primaryColor,
        end: 0,
        start: 8);
  }

  Scaffold buildUnAuthScreen() {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).colorScheme.secondary
          ])),
      alignment: Alignment.center,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.fireplace_outlined,
              size: 80,
              color: Colors.white,
            ),
            const Text(
              "campFire",
              style: TextStyle(
                fontSize: 50.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SignInButton(Buttons.GoogleDark,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                text: "Google bejelentkezés",
                onPressed: () => googleSignIn.signIn())
          ]),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}
