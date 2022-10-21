import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:tdapp/Constants/colors.dart';
import 'package:tdapp/Widgets/app_bar.dart';
import 'package:tdapp/Widgets/todo_container.dart';
import 'Constants/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tdapp/Utils/methods.dart';
import 'Models/todo.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int done = 0;

  List<Todo> myTodos = [];
  bool isLoading = true;

  void _showModel() {
    String title = "";
    String desc = "";
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height / 2,
            child: Center(
              child: Column(
                children: [
                  Text("Add your Todo",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Title',
                    ),
                    onSubmitted: (value) {
                      setState(() {
                        title = value;
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Description',
                    ),
                    onSubmitted: (value) {
                      setState(() {
                        desc = value;
                      });
                    },
                  ),
                  ElevatedButton(onPressed: () {}, child: Text('Add'))
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final HelperFunction _hlp = HelperFunction();
    return Scaffold(
        backgroundColor: bg,
        appBar: customAppBar(),
        body: FutureBuilder(
            future: _hlp.fetchData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              Widget widget = Text("");
              if (snapshot.hasData) {
                widget = SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      PieChart(
                        dataMap: {
                          "Done": done.toDouble(),
                          "Incomplete": (myTodos.length - done).toDouble(),
                        },
                      ),
                      Column(
                        children: snapshot.data.map<Widget>((e) {
                          return TodoContainer(
                              id: e.id,
                              onPress: () {},
                              title: e.title.toString(),
                              desc: e.desc.toString(),
                              isDone: e.isDone);
                        }).toList(),
                      )
                    ],
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                widget = Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                widget = Center(
                  child: Text("Something went wrong"),
                );
              }
              return widget;
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showModel();
          },
          child: Icon(Icons.add),
        ));
  }
}
