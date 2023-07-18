import 'package:campfire/widgets/interest.dart';
import 'package:flutter/material.dart';
import 'pages.dart';

enum profileStyle { myprofile, userprofile, editprofile }

class ProfilePage extends StatefulWidget {
  final User user;

  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isCurrentUser = false;

  @override
  void initState() {
    super.initState();
    isCurrentUser = currentUser!.id == widget.user.id;
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Scaffold(
        extendBodyBehindAppBar: false,
        appBar: const CustomAppBar("profil", false),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            ProfileImage(
              style: isCurrentUser
                  ? profileStyle.myprofile
                  : profileStyle.userprofile,
              imagePath: widget.user.photosUrl,
              onClicked: isCurrentUser
                  ? () {
                      Navigator.of(context)
                          .push(
                            MaterialPageRoute(
                                builder: (context) => const EditProfile()),
                          )
                          .then((value) => setState(() {}));
                    }
                  : () => {},
            ),
            const SizedBox(height: 24),
            buildName(widget.user),
            const SizedBox(height: 24),
            if (isCurrentUser)
              Container(
                padding: const EdgeInsets.only(left: 50, right: 50),
                height: 40,
                width: 10,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: ElevatedButton(
                      onPressed: () => googleSignIn.signOut(),
                      child: const Text("Kijelentkezés"),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                    )),
              ),
            const SizedBox(height: 24),
            const NumbersWidget(),
            Container(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              margin: const EdgeInsets.all(30),
              child: Interests.user(widget.user, displayType.list),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.black12),
                      top: BorderSide(color: Colors.black12))),
            ),
            buildAbout(widget.user),
            const SizedBox(height: 200),
          ],
        ),
      ),
    );
  }

  Widget buildName(User user) => Column(
        children: [
          Text(
            user.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: const TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildAbout(User user) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bio',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              user.bio,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );
}
