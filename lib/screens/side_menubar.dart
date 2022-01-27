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
            TextButtonWidget(icon: Icons.lightbulb, text: "Notes"),
            SizedBox(
              height: 5,
            ),
            TextButtonWidget(icon: Icons.archive_outlined, text: "Archieve"),
            SizedBox(
              height: 5,
            ),
            //TextButtonWidget(icon: Icons.settings_outlined, text: "Settings"),
            settings()
          ]),
        ),
      ),
    );
  }

  Widget settings(){
    return Container(
      margin: EdgeInsets.only(right: 40),
      child: TextButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                    bottomRight: Radius.circular(50)),
              ))),
          onPressed: (){},
          child: Container(
            padding: EdgeInsets.all(5),
            child: Row(
              children: [
                Icon(
                  Icons.settings_outlined,
                  size: 25,
                  color: white.withOpacity(0.7),
                ),
                SizedBox(
                  width: 27,
                ),
                Text(
                  "Settings",
                  style: TextStyle(color: white.withOpacity(0.7), fontSize: 18),
                )
              ],
            )),
    ));
  }
}
