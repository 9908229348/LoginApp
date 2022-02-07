import 'package:dummy_pro/api/firebasemanager.dart';
import 'package:dummy_pro/model/note.dart';
import 'package:dummy_pro/utils/colors.dart';
import 'package:dummy_pro/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

import '../main.dart';

class RemainderPage extends StatefulWidget {
  Note note;

  RemainderPage({Key? key, required this.note}) : super(key: key);

  @override
  _RemainderPageState createState() => _RemainderPageState();
}

class _RemainderPageState extends State<RemainderPage> {
  DateTime? dateTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Set Remainder")),
        backgroundColor: bgColor,
      ),
      backgroundColor: bgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "DateTime",
              style: TextStyle(color: white, fontSize: 17),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => pickDateTime(context),
              child: Text(
                getText(),
                style: TextStyle(color: white, fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                  // background
                  onPrimary: Colors.black,
                  fixedSize: Size(200, 50) // foreground
                  ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel", style: TextStyle(color: white)),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.red, fixedSize: Size(100, 30)),
                ),
                SizedBox(
                  width: 110,
                ),
                ElevatedButton(
                  onPressed: () {
                    print("=============alarm=========");
                    if (dateTime != null) {
                      print(widget.note.title);
                      widget.note.isRemainded = !widget.note.isRemainded;
                      setState(() {});
                      String result = FireBaseManager.remaindNote(
                          widget.note.id, widget.note.isRemainded);
                      if (result == 'Success') {
                        showSnackBar(
                            context,
                            widget.note.isRemainded
                                ? "Note is Remainded successfully"
                                : "Note is UnRemainded Successfully");
                      } else {
                        showSnackBar(context, "Something went wrong");
                      }
                      scheduleAlarm(dateTime!);
                    }

                    Navigator.pop(context);
                  },
                  child: Text("Add", style: TextStyle(color: white)),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green, fixedSize: Size(100, 30)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String getText() {
    if (dateTime == null) {
      return 'Select DateTime';
    } else {
      return DateFormat('MM/dd/yyyy HH:mm').format(dateTime!);
    }
  }

  Future pickDateTime(BuildContext context) async {
    final date = await pickDate(context);
    if (date == null) return;

    final time = await pickTime(context);
    if (time == null) return;

    setState(() {
      dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<DateTime?> pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: dateTime ?? initialDate,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 10),
    );

    if (newDate == null) return null;

    return newDate;
  }

  Future<TimeOfDay?> pickTime(BuildContext context) async {
    var now = TimeOfDay.now();
    final initialTime = TimeOfDay(hour: now.hour, minute: now.minute);
    final newTime = await showTimePicker(
      context: context,
      initialTime: dateTime != null
          ? TimeOfDay(hour: dateTime!.hour, minute: dateTime!.minute)
          : initialTime,
    );

    if (newTime == null) return null;

    return newTime;
  }

  void scheduleAlarm(DateTime dateTime) {
    var present = DateTime.now();
    print(
        "================present time $present==================================");
    print(dateTime);
    var scheduledNotificationDateTime = dateTime;
    print(
        "--------------------inside schedule alarm----------------------------");
    print(dateTime);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      "alarm_notif",
      "alarm_notif",
      channelDescription: "Channel for Alarm notification",
      icon: 'codex_logo',
      sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
      largeIcon: DrawableResourceAndroidBitmap('codex_logo'),
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        sound: 'a_long_cold_sting.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);

    var platformSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    flutterLocalNotificationsPlugin.schedule(
        0,
        widget.note.title,
        widget.note.description,
        scheduledNotificationDateTime,
        platformSpecifics);
  }
}
