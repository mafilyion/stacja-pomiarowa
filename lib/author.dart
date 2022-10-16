import 'package:flutter/material.dart';
import 'package:stacja_pomiarowa/credits.dart';
import 'package:stacja_pomiarowa/home.dart';
import 'package:stacja_pomiarowa/main.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthorPage extends StatelessWidget {
  const AuthorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Uri _facebook = Uri.parse('https://www.facebook.com/marek.bak.3154');
    final Uri _watsapp = Uri.parse('https://flutter.dev');
    final Uri _discord = Uri.parse('https://discord.gg/uQHzTmT3');

    return Scaffold(
        body: Center(
            child: Container(
                padding: const EdgeInsets.all(15),
                child: ListView(
                  children: [
                    FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Card(
                          child: Image.asset('assets/moja_fotka.png'),
                        )),
                    RichText(
                        text: const TextSpan(
                      text: "About me",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )),
                    RichText(
                        text: const TextSpan(
                      text: "",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    )),
                    RichText(
                        text: const TextSpan(
                      text:
                          "Hi my name is Marek and I am 22 years old. I'm a student in the seventh semester of the ICT major at the AEI department at the Silesian University of Technology. I am interested in the broad IT industry. I develop my passion through work. I work as an implementer in projects that provide ICT solutions to foreign clients.",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    )),
                    RichText(
                        text: const TextSpan(
                      text: "",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    )),
                    RichText(
                        text: const TextSpan(
                      text: "Find me on social media",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    )),
                    RichText(
                        text: const TextSpan(
                      text: "",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                            icon: const Icon(Icons.facebook,
                                color: Colors.blue, size: 40),
                            onPressed: (() => _launchUrl(_facebook))),
                        IconButton(
                            icon: const Icon(Icons.whatsapp,
                                color: Colors.blue, size: 40),
                            onPressed: (() => _launchUrl(_watsapp))),
                        IconButton(
                            icon: const Icon(Icons.discord,
                                color: Colors.blue, size: 40),
                            onPressed: (() => _launchUrl(_discord))),
                      ],
                    )
                  ],
                ))));
  }
}

Future<void> _launchUrl(_url) async {
  if (!await launchUrl(_url)) {
    throw 'Could not launch $_url';
  }
}
