import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../main.dart';

class Help extends StatefulWidget {
  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Help $myTitle"),
      ),
      body: Container(
        //height: double.infinity,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                      gradient:
                          LinearGradient(colors: [Colors.red, Colors.blue])),
                  height: double.infinity,
                  width: double.infinity,
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.all(15),
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.white, Colors.blue])),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.white,
                      elevation: 10,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(Icons.help_outline_rounded, size: 50),
                            title: Text("Help and Support",
                                style: TextStyle(fontSize: 25.0)),
                            subtitle: Text(
                                'Help and support section of monthly budget analytic',
                                style: TextStyle(fontSize: 15.0)),
                          ),
                          Container(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'Hello and welcome to help and support section of $myTitle. '
                              'Here you can contact us, or take a tour to how you can use the $myTitle analytic app.'
                              '\n\n(Help and Customer Support Services will available here.)',
                              textAlign: TextAlign.justify,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 30,
                              style: TextStyle(fontSize: 15.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
