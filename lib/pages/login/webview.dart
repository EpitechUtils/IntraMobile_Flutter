import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginWebview extends StatefulWidget {
    final String authUrl;

    /// Constructor
    LoginWebview({Key key, @required this.authUrl}) : super(key: key);

    @override
    _LoginWebview createState() => _LoginWebview();
}

class _LoginWebview extends State<LoginWebview> {

    final _webview = new FlutterWebviewPlugin();

    StreamSubscription<WebViewStateChanged> _onStateChanged;

    String token;

    /// When activity closing
    @override
    void dispose() {
        // Every listener should be canceled, the same should be done with this stream.
        _onStateChanged.cancel();
        _webview.dispose();
        super.dispose();
    }

    /// Init state and webview controller
    @override
    void initState() {
        super.initState();

        _webview.close();
        _onStateChanged = _webview.onStateChanged.listen(this.onStateChanged);
    }

    /// When webview state is changed
    void onStateChanged(WebViewStateChanged state) async {
        if (state.url.startsWith("https://intra.epitech.eu/admin/autolog")) {
            if (state.type == WebViewState.shouldStart)
                this._webview.hide();

            // Check if view is mounted and displayed
            if (mounted && state.type == WebViewState.finishLoad) {
                try {
                    // Get html page from javascript
                    this._webview.evalJavascript("document.documentElement.innerHTML").then((body) {

                        if (Platform.isIOS) {
                            // Remove html tags from response
                            RegExp exp = RegExp(
                                r"<[^>]*>",
                                multiLine: true,
                                caseSensitive: true
                            );
                            return body.replaceAll(exp, '');
                        } else {
                            String autologin = body.substring(body.indexOf("autologin"));
                            String autolog_url = autologin.substring(autologin.indexOf(":") + 1);
                            autolog_url = autolog_url.substring(1, autolog_url.indexOf("\\n}"));
                            autolog_url = autolog_url.replaceAll("\\", "");
                            return autolog_url.substring(1, autolog_url.length - 1);
                        }
                    }).then((autologJson) {
                        Map<String, dynamic> result;

                        if (Platform.isIOS)
                            result = json.decode(autologJson);
                        else
                            result = {"autologin": autologJson};

                        // Check if autolog exists
                        if (result["autologin"] == null) {
                            Navigator.of(context).pushReplacementNamed('/error_login');
                            return;
                        } // (E9&T^\;

                        // Close webview and destroy it
                        this._webview.close();

                        // Save autolog and start synchronization
                        SharedPreferences.getInstance().then((prefs) => prefs.setString("autolog_url", result['autologin']));
                        Navigator.of(context).pushReplacementNamed('/synchronization');
                    });
                } catch (err) {
                    Navigator.of(context).pushReplacementNamed('/error_login');
                }
            }
        }
    }

    /// Build widget and display content
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: WebviewScaffold(
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
                    title: Text("Connexion à l'intranet",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30
                        ),
                    ),
                    centerTitle: false,
                ),
                url: widget.authUrl,
                withJavascript: true,
                withZoom: false,
                clearCache: false,
                clearCookies: true,
            ),
            floatingActionButton: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    margin: const EdgeInsets.only(left: 30, top: 20, bottom: 40),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: 50,
                    child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                        elevation: 5,
                        onPressed: () => Navigator.of(context).maybePop(),
                        color: Color(0xFF0072ff),
                        child: Text("Annuler la connexion",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                            ),
                        )
                    ),
                ),
            ),
        );
    }

}
