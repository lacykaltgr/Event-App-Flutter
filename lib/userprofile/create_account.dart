import 'package:campfire/pages/pages.dart';
import 'package:campfire/widgets/interest.dart';
import 'package:flutter/material.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  User newUser = User(
      id: googleSignIn.currentUser!.id,
      bio: "",
      name: googleSignIn.currentUser!.displayName ?? "Felhasználó Józsi",
      email: googleSignIn.currentUser!.email,
      photosUrl: googleSignIn.currentUser!.photoUrl ?? "nincs",
      interests: []);

  @override
  void initState() {
    super.initState();
  }

  submit() {
    currentUser = newUser;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar("profil beállítása", false),
        body: Container(
            padding: const EdgeInsets.all(20),
            child: ListView(children: <Widget>[
              Row(
                children: [
                  const Text("Név: ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(newUser.name, style: const TextStyle(fontSize: 14))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Text("E-Mail: ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(newUser.email, style: const TextStyle(fontSize: 14))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              TextFieldWidget(
                  label: "Rólam",
                  text: newUser.bio,
                  onChanged: (about) {
                    setState(() {
                      newUser.bio = about;
                    });
                  }),
              const SizedBox(
                height: 20,
              ),
              Interests.user(newUser, displayType.edit),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 50,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: ElevatedButton(
                      onPressed: () => submit(),
                      child: const Text("Profil létrehozása",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).primaryColor),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                    )),
              ),
            ])));
  }
}
