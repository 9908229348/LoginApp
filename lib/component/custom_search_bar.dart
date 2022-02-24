import 'package:dummy_pro/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  Function searchInputCallBack;

  CustomSearchBar({Key? key, required this.searchInputCallBack})
      : super(key: key);

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      onChanged: (value) {
        widget.searchInputCallBack(value);
      },
      style: const TextStyle(color: white),
      cursorColor: white,
      decoration: InputDecoration(
          hintStyle: TextStyle(color: white.withOpacity(0.3)),
          prefixIcon: Icon(
            Icons.search,
            color: white.withOpacity(0.3),
          ),
          hintText: "Search Notes",
          border: InputBorder.none),
      keyboardType: TextInputType.text,
    );
  }
}
