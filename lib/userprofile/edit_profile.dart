import 'package:campfire/widgets/interest.dart';
import 'package:flutter/material.dart';
import '../pages/pages.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) => Builder(
        builder: (context) => Scaffold(
          appBar: const CustomAppBar("profil szerkesztése", false),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            physics: const BouncingScrollPhysics(),
            children: [
              ProfileImage(
                style: profileStyle.editprofile,
                imagePath: currentUser!.photosUrl,
                onClicked: () async {},
              ),
              const SizedBox(height: 24),
              TextFieldWidget(
                label: 'Bio',
                text: currentUser!.bio,
                maxLines: 5,
                onChanged: (about) {
                  currentUser!.bio = about;
                },
              ),
              const SizedBox(height: 24),
              const Text("Érdeklődések",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Interests.user(currentUser!, displayType.edit),
              const SizedBox(height: 24),
              ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).primaryColor),
                      ),
                      child: const Text("Mentés"),
                      onPressed: () {
                        usersRef.doc(currentUser!.id).update({
                          "interests": currentUser!.interests,
                          "bio": currentUser!.bio
                        });
                        Navigator.pop(context);
                      })),
              const SizedBox(height: 24),
            ],
          ),
        ),
      );
}
