import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mobile_intranet/components/customCircleAvatar.dart';
import 'package:mobile_intranet/components/loadingComponent.dart';
import 'package:mobile_intranet/pages/schedule.dart';
import 'package:mobile_intranet/parser/components/schedule/ScheduleProfessor.dart';
import 'package:mobile_intranet/parser/components/schedule/ScheduleSession.dart';
import 'package:mobile_intranet/utils/network/intranetAPIUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Display normal session with groups and description
class ScheduleSessionNormal extends StatefulWidget {
    final ScheduleSession scheduleSession;

    ScheduleSessionNormal({@required this.scheduleSession});

    @override
    State<StatefulWidget> createState() => _ScheduleSessionNormalState(this.scheduleSession);
}

class _ScheduleSessionNormalState extends State<ScheduleSessionNormal> {

    ScheduleSession _scheduleSession;
    String _autolog;

    /// Constructor
    _ScheduleSessionNormalState(this._scheduleSession);

    @override
    void initState() {
        super.initState();
        SharedPreferences.getInstance()
            .then((prefs) => this.setState(() => this._autolog = prefs.getString("autolog_url")));
    }

    @override
    Widget build(BuildContext context) {
        if (_autolog == null)
            return LoadingComponent.getBody(context);

        return Column(
            children: <Widget>[
                Container(
                    margin: const EdgeInsets.only(bottom: 15, top: 25),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                        decoration: BoxDecoration(
                            boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Color(0xFF464646).withOpacity(0.2),
                                    blurRadius: 15.0,
                                )
                            ]
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                color: SchedulePage.getSessionColor(this._scheduleSession),
                                child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                            Row(
                                                children: <Widget>[
                                                    // Icon status of the activity
                                                    () {
                                                        ScheduleSession event = this._scheduleSession;
                                                        if (event.eventRegistered is bool)
                                                            return Container();

                                                        try {
                                                            String status = event.eventRegistered;
                                                            return Container(
                                                                margin: const EdgeInsets.only(right: 10),
                                                                child: Tooltip(
                                                                    message: () {
                                                                        if (status == "present")
                                                                            return "Présent";
                                                                        return "Token à valider";
                                                                    }(),
                                                                    child: Icon(() {
                                                                            if (status == "present")
                                                                                return FontAwesomeIcons.check;
                                                                            return FontAwesomeIcons.question;
                                                                        }(),
                                                                        color: () {
                                                                            if (status == "present")
                                                                                return Colors.green;
                                                                            return Colors.orange;
                                                                        }()
                                                                    ),
                                                                ),
                                                            );
                                                        } catch (ignored) {}

                                                        return Container();
                                                    }(),

                                                    Text(this._scheduleSession.moduleTitle + "\n"
                                                        + this._scheduleSession.activityTitle,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                    ),
                                                ],
                                            ),

                                            Align(
                                                alignment: Alignment.center,
                                                child: Container(
                                                    width: MediaQuery.of(context).size.width / 2,
                                                    margin: const EdgeInsets.symmetric(vertical: 10),
                                                    child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: <Widget>[
                                                            Text(() {
                                                                DateTime startDate = DateFormat("yyyy-MM-dd HH:mm:ss")
                                                                    .parse(this._scheduleSession.start);
                                                                String minutes = (startDate.minute > 9) ? startDate.minute.toString() : "0" + startDate.minute.toString();

                                                                return startDate.hour.toString() + ":" + minutes;
                                                            }(),
                                                                overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 30,
                                                                    fontWeight: FontWeight.w800
                                                                ),
                                                            ),

                                                            Icon(Icons.arrow_forward,
                                                                color: Colors.white,
                                                                size: 25,
                                                            ),

                                                            Text(() {
                                                                DateTime endDate = DateFormat("yyyy-MM-dd HH:mm:ss")
                                                                    .parse(this._scheduleSession.end);
                                                                String minutes = (endDate.minute > 9) ? endDate.minute.toString() : "0" + endDate.minute.toString();

                                                                return endDate.hour.toString() + ":" + minutes;
                                                            }(),
                                                                overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 30,
                                                                    fontWeight: FontWeight.w800
                                                                ),
                                                            ),
                                                        ],
                                                    ),
                                                ),
                                            ),
                                            Container(
                                                alignment: Alignment.centerRight,
                                                child: Text(() {
                                                    String room = "Non définie";
                                                    try {
                                                        room = this._scheduleSession.room.code.substring(
                                                            this._scheduleSession.room.code.lastIndexOf('/') + 1,
                                                            this._scheduleSession.room.code.length) + " - "  +
                                                            this._scheduleSession.numberStudentsRegistered.toString()
                                                                + "/" + this._scheduleSession.room.seats.toString();
                                                    } catch(ignored) {}

                                                    return room;
                                                    }(),
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                    ),
                                                ),
                                            )
                                        ],
                                    )
                                ),
                            ),
                        )
                    ),
                ),

                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    margin: const EdgeInsets.only(bottom: 5),
                    child: Divider(),
                 ),

                () {
                    if (this._scheduleSession.eventRegistered is bool)
                        return Container();

                    return Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Row(
                            children: <Widget>[
                                Icon(Icons.check_circle_outline, color: Colors.green),
                                SizedBox(width: 5),
                                Text("Vous êtes inscrit(e) à cette activité.",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500
                                    ),
                                )
                            ],
                        ),
                    );
                }(),

                Container(
                    margin: const EdgeInsets.only(left: 15, top: 25),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Container(
                                    child: Text("Professeurs",
                                        style: TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                )
                            ),

                            Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: Row(
                                    children: () {
                                        List<Widget> professors = List<Widget>();

                                        this._scheduleSession.professors.forEach((ScheduleProfessor prof) {
                                            professors.add(Container(
                                                padding: EdgeInsets.only(right: 15),
                                                child: Tooltip(
                                                    message: prof.title == null ? "Inconnu !" : prof.title,
                                                    child: CustomCircleAvatar(
                                                        noPicture: Image.asset("assets/images/icons/nopicture-icon.png", width: 60),
                                                        imagePath: this._autolog + "/file/userprofil/" + prof.login.split('@')[0] + ".bmp",
                                                        radius: 60,
                                                    )
                                                )
                                            ));
                                        });

                                        return professors;
                                    }(),
                                ),
                            ),
                        ],
                    ),
                ),

                // Details of registered users
                Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.all(10),
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        onPressed: () {
                            SharedPreferences.getInstance().then((SharedPreferences prefs) {
                                IntranetAPIUtils().registerToActivity(this._autolog,
                                    this._scheduleSession)
                                    .then((dynamic res) {
                                        this.setState(() {
                                            this._scheduleSession.eventRegistered = (this._scheduleSession.eventRegistered is bool)
                                                ? "registered" : false;
                                        });
                                    });
                            });
                        },
                        color: (this._scheduleSession.eventRegistered is bool)
                            ? Color(0xFF4CAF50) : Color(0xFFf44336),
                        child: Container(
                            margin: const EdgeInsets.only(top: 3),
                            child: Text((this._scheduleSession.eventRegistered is bool)
                                    ? "S'inscrire" : "Se désinscrire",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Sabrun",
                                    fontWeight: FontWeight.bold
                                    //letterSpacing: 1.0,
                                )
                            ),
                        )
                    )
                )
            ],
        );
    }
}
