import 'package:flutter/material.dart';
import 'package:mobile_intranet/pages/DashboardPage.dart';
import 'package:mobile_intranet/pages/ProfilePage.dart';
import 'package:mobile_intranet/pages/SplashScreen.dart';

void main() => runApp(EpitechMobile());

class EpitechMobile extends StatelessWidget {

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Epitech Mobile',
            theme: ThemeData(
                primarySwatch: Colors.indigo,
                fontFamily: "NunitoSans"
            ),
            home: SplashScreen(),
            routes: {
                '/home': (context) => DashboardPage(),
                '/profile': (context) => ProfilePage()
            },
            //debugShowMaterialGrid: true,
            //debugShowCheckedModeBanner: false
        );
    }

}