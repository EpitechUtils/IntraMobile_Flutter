import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {

    // Class variables
    final Widget child;
    final Function floatingMethod;

    /// CustomBottomNavigationBar constructor
    BottomNavigation({@required this.child, this.floatingMethod});

    double applyBottomPadding(BuildContext context) {
        final bool iphonex = MediaQuery.of(context).size.height >= 812.0;
        return iphonex ? 25.0 : 0.0;
    }

    Widget displayBottomNavigationBar(BuildContext context) {
        // Current route is upload, bye
        if (ModalRoute.of(context).settings.name == '/uploadImage')
            return null;

        return BottomAppBar(
            child: Container(
                color: Color(0xFF131313),
                child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 6),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                            IconButton(
                                icon: Icon(Icons.dashboard),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                color: ModalRoute.of(context).settings.name == '/home' ? Colors.blueAccent : Colors.white,
                                onPressed: () {
                                    if (ModalRoute.of(context).settings.name != '/home')
                                        Navigator.of(context).pushReplacementNamed('/home');
                                },
                            ),

                            IconButton(
                                icon: Icon(Icons.calendar_today),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                color: ModalRoute.of(context).settings.name == '/planning' ? Colors.blueAccent : Colors.white,
                                onPressed: () {
                                    Navigator.of(context).pushReplacementNamed("/planning");
                                }
                            ),

                            IconButton(
                                icon: Icon(Icons.people),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                color: ModalRoute.of(context).settings.name == '/profile' ? Colors.blueAccent : Colors.white,
                                onPressed: () {
                                    if (ModalRoute.of(context).settings.name != '/profile')
                                        Navigator.of(context).pushReplacementNamed('/profile');
                                },
                            ),

                            IconButton(
                                icon: Icon(Icons.notifications_active),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                color: ModalRoute.of(context).settings.name == '/notifs' ? Colors.blueAccent : Colors.white,
                                onPressed: () {
                                    if (ModalRoute.of(context).settings.name != '/notifs')
                                        Navigator.of(context).pushReplacementNamed('/notifs');
                                },
                            ),

                            IconButton(
                                icon: Icon(Icons.settings),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                color: ModalRoute.of(context).settings.name == '/settings' ? Colors.blueAccent : Colors.white,
                                onPressed: () {
                                    Navigator.of(context).pushReplacementNamed("/settings");
                                }
                            ),
                        ],
                    ),
                )
            ),
        );
    }

    /// Build content and display bottom navigation bar
    @override
    Widget build(BuildContext context) {
        return Container(
            color: Color(0xFF000000),
            child: SafeArea(
                bottom: false,
                child: Scaffold(
                    bottomNavigationBar: this.displayBottomNavigationBar(context),
                    body: this.child,
                ),
            ),
        );
    }
}