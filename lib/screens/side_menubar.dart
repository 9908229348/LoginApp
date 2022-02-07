import 'package:dummy_pro/screens/archievenotes.dart';
import 'package:dummy_pro/screens/home.dart';
import 'package:dummy_pro/screens/remaindernotes.dart';
import 'package:dummy_pro/utils/colors.dart';
import 'package:dummy_pro/widgets/text_button.dart';
import 'package:flutter/material.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(color: bgColor),
        child: SafeArea(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                margin: EdgeInsets.symmetric(horizontal: 25, vertical: 16),
                child: Text(
                  "Google Keep",
                  style: TextStyle(
                      color: white, fontSize: 20, fontWeight: FontWeight.bold),
                )),
            Divider(
              color: white.withOpacity(0.3),
            ),
            TextButtonWidget(
              icon: Icons.lightbulb,
              text: "Notes",
              callBack: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
            ),
            SizedBox(
              height: 5,
            ),
            TextButtonWidget(
                icon: Icons.archive_outlined,
                text: "Archieve",
                callBack: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ArchieveNotes()));
                }),
            SizedBox(
              height: 5,
            ),
            TextButtonWidget(
                icon: Icons.alarm,
                text: "Remainders",
                callBack: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RemainderNotes()));
                })
          ]),
        ),
      ),
    );
  }
}
