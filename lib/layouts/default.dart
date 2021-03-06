import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:mobile_intranet/pages/login/select.dart';
import 'package:mobile_intranet/utils/network/networkUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Header component
/// Must be integrated in all routes
class DefaultLayout extends StatelessWidget {

    // Configure default values
    final String title;
    final Widget child;
    final Widget bottomAppBar;
    final List<Widget> actions;
    final bool hasProfileButton;
    final int notifications;
    final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

    // Constructor
    DefaultLayout({@required this.title, @required this.child, this.bottomAppBar, this.actions, this.hasProfileButton = true, this.notifications = 0});

    Widget buildAppBar(BuildContext context) {
        if (this.hasProfileButton) {
            return AppBar(
                actions: this.actions,
                automaticallyImplyLeading: false,
                title: Row(
                    children: <Widget>[
                        (){
                            if (Navigator.canPop(context)) {
                                return Container(
                                    margin: const EdgeInsets.only(right: 15),
                                    child: InkWell(
                                        onTap: () {
                                            Navigator.maybePop(context);
                                        },
                                        child: Icon(Icons.arrow_back_ios,
                                            size: 25,
                                        ),
                                    ),
                                );
                            }

                            // Display menu
                            return Container(
                                margin: const EdgeInsets.only(right: 15),
                                child: InkWell(
                                    onTap: () => this.scaffoldKey.currentState.openDrawer(),
                                    child: Icon(Icons.menu,
                                        size: 30,
                                    ),
                                ),
                            );
                        }(),
                        Text(this.title,
                            style: TextStyle(
                                fontFamily: "Sarabun",
                                fontWeight: FontWeight.bold,
                                fontSize: 25
                            ),
                        )
                    ],
                ),
                flexibleSpace: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: <Color>[
                                Color(0xFF0072ff),
                                Color(0xFF2F80ED),
                            ]
                        )
                    ),
                ),
                centerTitle: false,
                bottom: this.bottomAppBar
            );
        } else {
            return AppBar(
                actions: this.actions,
                title: Text(this.title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25
                    ),
                ),
                flexibleSpace: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: <Color>[
                                Color(0xFF0072ff),
                                Color(0xFF2F80ED),
                            ]
                        )
                    ),
                ),
                centerTitle: false,
                bottom: this.bottomAppBar
            );
        }
    }

    /// Build header
    @override
    Widget build(BuildContext context) {
        return Container(
            child: SafeArea(
                top: false,
                bottom: false,
                child: Scaffold(
                    key: this.scaffoldKey,
                    appBar: buildAppBar(context),
                    body: this.child,
                    drawer: Drawer(
                        child: Column(
                            //padding: EdgeInsets.zero,
                            children: <Widget>[
                                Expanded(
                                    child: ListView(
                                        padding: EdgeInsets.zero,
                                        children: <Widget>[
                                            DrawerHeader(
                                                child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    //crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                        Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: <Widget>[
                                                                Container(
                                                                    margin: const EdgeInsets.only(bottom: 10),
                                                                    child: Text("My Intranet",
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            color: Colors.white,
                                                                            fontSize: 30
                                                                        ),
                                                                    ),
                                                                ),
                                                                Container(
                                                                    child: Text("Le compagnion qui va vous suivre toute votre "
                                                                        "scolarité",
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.w600,
                                                                            color: Colors.white,
                                                                            //fontSize: 15
                                                                        ),
                                                                    ),
                                                                ),
                                                            ],
                                                        ),
                                                        Container(
                                                            alignment: Alignment.centerLeft,
                                                            margin: const EdgeInsets.only(bottom: 10),
                                                            child: Text("v1.1.0 (bêta 2)",
                                                                textAlign: TextAlign.left,
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: 12
                                                                ),
                                                            ),
                                                        )
                                                        /*Container(
                                                            margin: const EdgeInsets.only(bottom: 10),
                                                            child: Text("Cette version est encore en bêta. N'hésitez pas "
                                                                "à nous rapporter tous les bugs et autres via l'onglet \"aide et feedback\" ci-dessous.",
                                                                style: TextStyle(
                                                                    color: Colors.yellow,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: 12
                                                                ),
                                                            ),
                                                        )*/
                                                    ],
                                                ),
                                                decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                        begin: Alignment.centerLeft,
                                                        end: Alignment.centerRight,
                                                        colors: <Color>[
                                                            Color(0xFF0072ff),
                                                            Color(0xFF2F80ED),
                                                        ]
                                                    )
                                                ),
                                            ),
                                            ListTile(
                                                dense: true,
                                                leading: Icon(Icons.home),
                                                title: Text('Tableau de Bord'),
                                                subtitle: Text("J'ai quoi à rendre bientôt ?"),
                                                onTap: () {
                                                    if (ModalRoute.of(context).settings.name != '/home')
                                                        Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
                                                    else this.scaffoldKey.currentState.openEndDrawer();
                                                },
                                            ),
                                            ListTile(
                                                dense: true,
                                                leading: Icon(Icons.calendar_today),
                                                title: Text('Planning'),
                                                subtitle: Text("C'est quoi ma prochaine activité ?"),
                                                onTap: () {
                                                    if (ModalRoute.of(context).settings.name != '/schedule')
                                                        Navigator.of(context).pushNamedAndRemoveUntil("/schedule", (Route<dynamic> route) => false);
                                                    else this.scaffoldKey.currentState.openEndDrawer();
                                                },
                                            ),
                                            ListTile(
                                                dense: true,
                                                leading: Icon(Icons.assignment),
                                                title: Text('Résultats des tests (bêta)'),
                                                subtitle: Text("Oui, my.epitech.eu sur mobile..."),
                                                onTap: () {
                                                    if (ModalRoute.of(context).settings.name != '/tests_results')
                                                        Navigator.of(context).pushNamedAndRemoveUntil("/tests_results", (Route<dynamic> route) => false);
                                                    else this.scaffoldKey.currentState.openEndDrawer();
                                                },
                                            ),
                                            ListTile(
                                                dense: true,
                                                leading: Stack(
                                                    children: <Widget>[
                                                        Icon(Icons.notifications),
                                                        Positioned(
                                                            //left: 11,
                                                            child: Container(
                                                                padding: EdgeInsets.all(2),
                                                                decoration: BoxDecoration(
                                                                    color: Colors.red,
                                                                    borderRadius: BorderRadius.circular(6),
                                                                ),
                                                                constraints: BoxConstraints(
                                                                    minWidth: 14,
                                                                    minHeight: 14,
                                                                ),
                                                                child: Text(this.notifications == null ? "0" : this.notifications.toString(),
                                                                    style: TextStyle(
                                                                        color: Colors.white,
                                                                        fontSize: 9,
                                                                    ),
                                                                    textAlign: TextAlign.center,
                                                                ),
                                                            ),
                                                        )
                                                    ],
                                                ),
                                                title: Text('Notifications'),
                                                subtitle: Text("Les grades ? Troooop bien !"),
                                                onTap: () {
                                                    if (ModalRoute.of(context).settings.name != '/notifications')
                                                        Navigator.of(context).pushNamedAndRemoveUntil("/notifications", (Route<dynamic> route) => false);
                                                    else this.scaffoldKey.currentState.openEndDrawer();
                                                },
                                            ),
                                            ListTile(
                                                dense: true,
                                                leading: Icon(Icons.person),
                                                title: Text('Mon Profil'),
                                                subtitle: Text("J'ai reçu une alerte temps de log..."),
                                                onTap: () {
                                                    if (ModalRoute.of(context).settings.name != '/profile')
                                                        Navigator.of(context).pushNamedAndRemoveUntil("/profile", (Route<dynamic> route) => false);
                                                    else this.scaffoldKey.currentState.openEndDrawer();
                                                },
                                            ),
                                        ],
                                    ),
                                ),
                                Container(
                                    margin: const EdgeInsets.only(bottom: 40),
                                    child: Align(
                                        alignment: FractionalOffset.bottomCenter,
                                        child: Container(
                                            child: Column(
                                                children: <Widget>[
                                                    Divider(),
                                                    ListTile(
                                                        leading: Icon(Icons.settings),
                                                        title: Text('Paramètres'),
                                                        onTap: () {
                                                            if (ModalRoute.of(context).settings.name != '/settings')
                                                                Navigator.of(context).pushNamedAndRemoveUntil("/settings", (Route<dynamic> route) => false);
                                                            else this.scaffoldKey.currentState.openEndDrawer();
                                                        },
                                                    ),
                                                    ListTile(
                                                        leading: Icon(Icons.power_settings_new, color: Colors.red),
                                                        title: Text('Se déconnecter', style: TextStyle(color: Colors.red)),
                                                        onTap: () {
                                                            SharedPreferences.getInstance().then((prefs) {
                                                                DefaultCacheManager().emptyCache();
                                                                NetworkUtils.internal().cacheManager.clearAll();

                                                                // Clear shared preferences
                                                                prefs.clear().then((res) {
                                                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                                                        builder: (BuildContext context) => SelectLogin(loginEmail: null)
                                                                    ), (Route<dynamic> route) => false);
                                                                });
                                                            });
                                                        },
                                                    ),
                                                    /*ListTile(
                                                        leading: Icon(Icons.help),
                                                        title: Text('Aide et Feedback')
                                                    )*/
                                                ],
                                            )
                                        )
                                    )
                                )
                            ],
                        ),
                    ),
                    //bottomNavigationBar: BottomNavigation(notifications: this.notifications)
                ),
            ),
        );
    }
}