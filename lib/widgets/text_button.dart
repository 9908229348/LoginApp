import 'package:dummy_pro/utils/colors.dart';
import 'package:flutter/material.dart';

class TextButtonWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  Function callBack;

  TextButtonWidget(
      {Key? key,
      required this.icon,
      required this.text,
      required this.callBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(right: 40),
        child: TextButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(50),
                bottomRight: Radius.circular(50)),
          ))),
          onPressed: () {
            callBack();
          },
          child: Container(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 25,
                    color: white.withOpacity(0.7),
                  ),
                  const SizedBox(
                    width: 27,
                  ),
                  Text(
                    text,
                    style:
                        TextStyle(color: white.withOpacity(0.7), fontSize: 18),
                  )
                ],
              )),
        ));
  }
}
