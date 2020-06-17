import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

menuItem({String textItems, Function events, IconData itemIcons, Color itemColor}) {
  return Padding(
    padding: const EdgeInsets.only(top: 8),
    child: GestureDetector(
      onTap: () {
        events();
      },
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        leading: Icon(
          itemIcons ?? Icons.ac_unit,
          color: itemColor,
          size: 28,
        ),
        title: Text(
          textItems ?? '',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    ),
  );
}
