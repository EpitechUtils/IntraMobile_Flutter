import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_intranet/components/BottomNavigationComponent.dart';
import 'package:mobile_intranet/pages/settings/ScheduleSettings.dart';

class SettingsPage extends StatefulWidget {
    final String title;

    /// Constructor
    SettingsPage({Key key, this.title}) : super(key: key);

    /// Build and display state
    @override
    _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

    @override
    void initState() {
	super.initState();
    }

    @override
    void dispose() {
	super.dispose();
    }

    Widget createSettingsList(BuildContext context)
    {
        List<String> settings = ["Planning"];

        return ListView.builder(
	    itemCount: settings.length,
	    itemBuilder: (BuildContext context, int index) {
	        return ListTile(
		    title: Text(settings[index]),
		    leading: Icon(Icons.schedule),
		    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduleSettings())),
		);
	    }
	);
    }

    /// Display content
    @override
    Widget build(BuildContext context) {
	return Container(
	    color: Color.fromARGB(255, 255, 255, 255),
	    child: SafeArea(
		top: false,
		bottom: false,
		child: Scaffold(
		    appBar: AppBar(
			backgroundColor: Color.fromARGB(255, 41, 155, 203),
			title: Text("Settings",
			    style: TextStyle(
				fontWeight: FontWeight.bold,
				fontFamily: "NunitoSans"
			    ),
			),
			brightness: Brightness.dark,
		    ),
		    body: createSettingsList(context),
		    bottomNavigationBar: BottomNavigationComponent()
		),
	    ),
	);
    }

}
