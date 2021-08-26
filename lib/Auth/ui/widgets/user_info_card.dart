import 'package:flutter/material.dart';




class UserInfoCard extends StatelessWidget {
  String text;
  String lable;
  UserInfoCard(this.text , this.lable);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey,
        ),
        child: Row(
          children: [
            Text(lable),
            Spacer(),
            Text(text),
          ],
        ),

      ),
    );
  }
}
