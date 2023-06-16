import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final Map<String, dynamic> user;
  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    List email = [];
    widget.user.keys.forEach((element) {
      if (element == "email") {
        email.add(widget.user[element]);
      }
    });
    return Scaffold(
      appBar: AppBar(title: Text("User Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700))),
      body: Center(
        child: Container(
            height: 300,
            width: 300,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 30),
                  child: Text(
                    "Welcome " + widget.user["name"],
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                  ),
                ),
                Column(
                  children: widget.user.keys
                      .map((e) => Row(
                            children: [
                              Row(
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(bottom: 15),
                                      width: 100,
                                      child: Text(e, style: TextStyle(fontSize: 15))),
                                  Container(margin: EdgeInsets.only(bottom: 15), width: 30, child: Text("-")),
                                  Container(margin: EdgeInsets.only(bottom: 15), child: Text(widget.user[e]))
                                ],
                              ),
                            ],
                          ))
                      .toList(),
                ),
              ],
            )),
      ),
    );
  }
}
