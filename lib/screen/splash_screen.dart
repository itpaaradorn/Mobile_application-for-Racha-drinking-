import 'package:application_drinking_water_shop/screen/home.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
//        }
//      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(25),
              child: SizedBox(),
            ),
            Container(
              margin: EdgeInsets.all(25),
              child: Image.asset(
                'images/logowater.png',
                width: 400,
              ),
            ),
            Container(
              margin: EdgeInsets.all(25),
              child: FittedBox(
                child: Text(
                  '2023 \u00a9  Rachar WaterShop. All Rights Reserved',
                  style: TextStyle(
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
