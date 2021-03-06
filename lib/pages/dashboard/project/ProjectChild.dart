import 'package:flutter/material.dart';
import 'package:mobile_intranet/layouts/default.dart';
import 'package:mobile_intranet/parser/components/subcomponents/Project.dart';
import 'package:mobile_intranet/parser/components/subcomponents/moduleProject/ModuleProject.dart';
import 'package:mobile_intranet/parser/components/subcomponents/moduleProject/ModuleProjectGroup.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:mobile_intranet/parser/Parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_intranet/pages/dashboard/project/ProjectRegister.dart';
import 'package:mobile_intranet/utils/network/intranetAPIUtils.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class ProjectChildPage extends StatefulWidget {
    final Project project;

    ProjectChildPage({Key key, @required this.project}) : super(key: key);

    @override
    _ProjectChildPage createState() => new _ProjectChildPage();
}

class _ProjectChildPage extends State<ProjectChildPage> {
    ModuleProject _moduleProject;
    SharedPreferences _prefs;

    // Project registration variables
    int members;
    List<String> membersMail = new List<String>();

    @override
    void initState() {
        super.initState();

        // Call the refresh method to retrieve all information from API
        this.refresh();
    }

    @override
    void dispose() {
        // Clean up the controller when the Widget is disposed
        super.dispose();
    }

    void refresh() {
        // Reset _moduleProject so the view is Loading...
        this._moduleProject = null;
        SharedPreferences.getInstance().then((SharedPreferences prefs) => this.setState(() {
            this._prefs = prefs;
            Parser parser = Parser(prefs.getString("autolog_url"));

            this.membersMail.add(this._prefs.get("email"));
            parser.parseModuleProject(this.widget.project.urlLink)
                .then((ModuleProject moduleProject) => this.setState(() {
                this._moduleProject = moduleProject;
            }));
        }));
    }

    @override
    Widget build(BuildContext context) {
        if (this._moduleProject == null) {
            return DefaultLayout(
                title: "Chargement...",
                child: Container(),
            );
        } else {
            return DefaultLayout(
                title: "Détails du projet",
                child: Column(
                    children: <Widget>[
                        buildProjectBar(),
                        buildProjectGroupsList()
                    ],
                ),
            );
        }
    }

    Widget buildProjectFiles() {
        if (this._moduleProject.filesUrls == null) {
            return Container(
                child: Text("Fichiers non disponibles"),
            );
        }
        return Container(
            margin: EdgeInsets.only(top: 10),
            alignment: Alignment.centerLeft,
            height: 75,
            child: ListView.builder(
                itemCount: this._moduleProject.filesUrls.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                    return Column(
                        children: <Widget>[
                            IconButton(
                                icon: Icon(
                                    Icons.picture_as_pdf,
                                    size: 35,
                                ),
                                onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(
                                            builder: (context) => WebviewScaffold(
                                                url: "https://docs.google.com/viewer?url=https://intra.epitech.eu" + this._moduleProject.filesUrls[index],
                                                //initialChild: CircularProgressIndicator(),
                                                appBar: AppBar(
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
                                                    automaticallyImplyLeading: false,
                                                    title: Row(
                                                        children: <Widget>[
                                                            Container(
                                                                margin: const EdgeInsets.only(right: 15),
                                                                child: InkWell(
                                                                    onTap: () => Navigator.of(context).maybePop(),
                                                                    child: Icon(Icons.arrow_back_ios,
                                                                        size: 25,
                                                                    ),
                                                                ),
                                                            ),
                                                            Text("Fichier PDF",
                                                                style: TextStyle(
                                                                    fontFamily: "Sarabun",
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 25
                                                                )
                                                            )
                                                        ],
                                                    ),
                                                    centerTitle: false,
                                                ),
                                            )
                                        )
                                    );
                                },
                                highlightColor: Colors.lightBlueAccent,
                                color: Colors.lightBlueAccent,
                            ),
                            Text(
                                this._moduleProject.filesUrls[index].substring(this._moduleProject.filesUrls[index].lastIndexOf('/') + 1),
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 10),
                            )
                        ],
                    );
                    //return Text(this._moduleProject.filesUrls[index]);
                },
            ),
        );
    }

    Widget buildProjectBar() {
        return Container(
            decoration: BoxDecoration(
                color: Colors.black,
                boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(50, 31, 40, 51),
                        offset: Offset(-5, 0),
                        blurRadius: 20,
                    )
                ],
                image: new DecorationImage(
                    fit: BoxFit.cover,
                    repeat: ImageRepeat.repeat,
                    image: AssetImage("assets/images/background.png")
                )
            ),
            child: Column(
                children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                            Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                    children: <Widget>[
                                        Icon(Icons.people, color: Color.fromARGB(255, 41, 155, 203)),
                                        Text(
                                            (this._moduleProject.groupMax == 1) ? "Projet solo" : this._moduleProject.groupMin.toString() + " à " + this._moduleProject.groupMax.toString(),
                                            style: TextStyle(fontFamily: "NunitoSans", fontWeight: FontWeight.w600),
                                        )
                                    ],
                                )
                            ),
                            Container(
                                padding: EdgeInsets.all(10),
                                child: CircularPercentIndicator(
                                    radius: 60,
                                    lineWidth: 2,
                                    percent: double.parse(this.widget.project.timeline) / 100,
                                    progressColor: (this.widget.project.timeline == "100.0000") ? Colors.red : Colors.green,
                                    center: Text(double.parse(this.widget.project.timeline).toStringAsFixed(1) + "%", style: TextStyle(fontWeight: FontWeight.w600),),
                                )
                            ),
                            Container(
                                padding: EdgeInsets.all(10),
                                child: Text.rich(
                                    TextSpan(
                                        text: (DateTime.parse(this._moduleProject.end.split(',')[0]).isBefore(DateTime.now())) ? "Projet terminé" : "J ",
                                        style: TextStyle(fontFamily: "NunitoSans"),
                                        children: <TextSpan>[
                                            TextSpan(
                                                text: (DateTime.parse(this._moduleProject.end.split(',')[0]).isBefore(DateTime.now())) ? "" :
                                                (DateTime.now().difference(DateTime.parse(this._moduleProject.end.split(',')[0]))).inDays.toString(),
                                                style: TextStyle(fontFamily: "NunitoSans", fontWeight: FontWeight.w600)
                                            )
                                        ]
                                    )
                                ),
                            ),
                            Container(
                                padding: EdgeInsets.all(10),
                                child: buildRegisterStatus()
                            )
                        ],
                    ),
                    buildProjectFiles()
                ],
            )
        );
    }

    Widget buildProjectGroupsList() {
        return Flexible(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: this._moduleProject.groups.length,
                itemBuilder: (BuildContext context, int index) {
                    return Container(
                        child: Column(
                            children: <Widget>[
                                Card(
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                            Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                    Padding(
                                                        padding: EdgeInsets.all(8.0),
                                                        child: Text(
                                                            (this._moduleProject.groups[index].groupName.length < 40) ? this._moduleProject.groups[index].groupName : this._moduleProject.groups[index].groupName.substring(0, 40) + "...",
                                                            style: TextStyle(fontFamily: "NunitoSans", fontWeight: FontWeight.w600),
                                                        )
                                                    ),
                                                    Row(
                                                        children: <Widget>[
                                                            Container(
                                                                margin: EdgeInsets.all(5),
                                                                width: 50.0,
                                                                height: 50.0,
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape.circle,
                                                                    image: DecorationImage(
                                                                        fit: BoxFit.cover,
                                                                        image: NetworkImage(this._prefs.getString("autolog_url")
                                                                            + this._moduleProject.groups[index].master.picture
                                                                        )
                                                                    )
                                                                )
                                                            ),
                                                            //TODO make this scrollable (overflow if group members amount is to big)
                                                            Container(
                                                                margin: EdgeInsets.symmetric(vertical: 10.0),
                                                                height: 40.0,
                                                                child: ListView.builder(
                                                                    shrinkWrap: true,
                                                                    scrollDirection: Axis.horizontal,
                                                                    itemBuilder: (context, memberIndex) {
                                                                        return Container(
                                                                            margin: EdgeInsets.all(5),
                                                                            width: 30.0,
                                                                            decoration: BoxDecoration(
                                                                                shape: BoxShape.circle,
                                                                                image: DecorationImage(
                                                                                    fit: BoxFit.cover,
                                                                                    image: NetworkImage(this._prefs.getString("autolog_url")
                                                                                        + this._moduleProject.groups[index].members[memberIndex].picture
                                                                                    )
                                                                                )
                                                                            )
                                                                        );
                                                                    },
                                                                    itemCount: this._moduleProject.groups[index].members.length,
                                                                ),
                                                            )
                                                        ],
                                                    )
                                                ],
                                            ),
                                            buildGroupMasterButton(this._moduleProject.groups[index])
                                        ],
                                    ),
                                ),
                            ],
                        ),
                    );
                }
            ),
        );
    }

    Widget buildGroupMasterButton(ModuleProjectGroup group) {
        if (this._prefs.get("email") != group.master.login)
            return Container();
        return IconButton(
            icon: Icon(
                Icons.remove_circle,
                color: Colors.red,
            ),
            onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                        title: Text("Supprimer le groupe ?", style: TextStyle(fontWeight: FontWeight.w600)),
                        content: SingleChildScrollView(
                            child: ListBody(
                                children: <Widget>[
                                    Text("Cela pourait être dangereux..."),
                                ],
                            ),
                        ),
                        actions: <Widget>[
                            FlatButton(
                                child: Text('Supprimer'),
                                onPressed: () {
                                    IntranetAPIUtils.internal().unregisterToProject(
                                        this._prefs.get("autolog_url") + this.widget.project.urlLink + "project/destroygroup?format=json",
                                        this._moduleProject.projectTitle,
                                        this._moduleProject.codeInstance,
                                        this._prefs.get("email")
                                    ).then((data) {
                                        Navigator.of(context).pop();
                                        this.refresh();
                                    });
                                },
                            ),
                            FlatButton(
                                child: Text('Annuler'),
                                onPressed: () {
                                    Navigator.of(context).pop();
                                },
                            ),
                        ],
                    )
                );
            }
        );
    }

    Widget buildRegisterStatus() {
        if (this._moduleProject.userProjectStatus == "project_confirmed") {
            return Column(
                children: <Widget>[
                    Icon(
                        Icons.check_circle,
                        color: Color.fromARGB(255, 41, 155, 203)
                    ),
                    Text(
                        "Inscrit",
                        style: TextStyle(fontFamily: "NunitoSans")
                    )
                ],
            );
        }
        return Column(
            children: <Widget>[
                IconButton(
                    icon: Icon(
                        Icons.add,
                        color: Color.fromARGB(255, 41, 155, 203)
                    ),
                    tooltip: "Inscription",
                    onPressed: () {
                        showDialog(
                            context: context,
                            builder: (_) => RegisterContent(prefs: this._prefs, moduleProject: this._moduleProject,
                                project: this.widget.project, notifyParent: this.refresh)
                        );
                    },
                )
            ],
        );
    }
}