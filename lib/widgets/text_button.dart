import 'package:dummy_pro/utils/colors.dart';
import 'package:flutter/material.dart';

class TextButtonWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  
  const TextButtonWidget({ Key? key, required this.icon, required this.text }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 40),
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
                  icon,
                  size: 25,
                  color: white.withOpacity(0.7),
                ),
                SizedBox(
                  width: 27,
                ),
                Text(
                  text,
                  style: TextStyle(color: white.withOpacity(0.7), fontSize: 18),
                )
              ],
            )),
    ));
  }
}