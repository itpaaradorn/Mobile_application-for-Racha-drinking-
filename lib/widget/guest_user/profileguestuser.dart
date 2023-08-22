import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfileGuestUserPage extends StatefulWidget {
  const ProfileGuestUserPage({super.key});

  @override
  State<ProfileGuestUserPage> createState() => _ProfileGuestUserPageState();
}

class _ProfileGuestUserPageState extends State<ProfileGuestUserPage> {
   @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 30,
      ),
      Text(
        "Profile",
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
      ),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 115,
              width: 115,
              child: buildNoneAvatarImage(),
            ),
          ],
        ),
      ),
    ]);
  }

  Widget buildNoneAvatarImage() {
    return Stack(
      fit: StackFit.expand,
      // overflow: Overflow.visible,
      children: [
        CircleAvatar(
          backgroundImage: AssetImage('assets/images/avatar.png'),
        ),
        Positioned(
          right: -12,
          bottom: 0,
          child: SizedBox(
            height: 40,
            width: 40,
            child: TextButton(
             
              onPressed: () {},
              child: SvgPicture.asset("assets/images/camera.svg"),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        TextButton(
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [],
          ),
        ),
      ],
    );
  }
}