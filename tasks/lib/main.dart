import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:io';

void main(){
  runApp(MaterialApp(
    home: Tasks(),
  ));
}

class Tasks extends StatefulWidget {
  _TaskState createState() => _TaskState();
}

class _TaskState extends State<Tasks> {

  final _newTaskController = TextEditingController();
  List _toDoList = [];

  Map<String, dynamic> _lastRemoved;
  int _lastRemovedPos;

  @override
  void initState(){
    super.initState();

    _readData().then((data) {
      _toDoList = json.decode(data);
    });
  }

  void _addNewTask(){
    setState(() {
      Map<String,  dynamic> newTaskToDo = Map();
      newTaskToDo["title"] = _newTaskController.text;
      newTaskToDo["finished"] = false;
      _newTaskController.text = "";
      _toDoList.add(newTaskToDo);

      _saveData();
    });
  }

  Future<Null> _refresh() async{
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _toDoList.sort((a, b){
        if(a["finished"] && !b["finished"]) return 1;
        else if (!a["finished"] && b["finished"]) return -1;
        else return 0;
      });

      _saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.5, 17.0, 1.0),
            margin: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(child: TextField(
                  controller: _newTaskController,
                  decoration: InputDecoration(
                    labelText: "Nova Tarefa",
                    labelStyle: TextStyle(color: Colors.deepPurple),
                  ),
                )),
                ElevatedButton(
                  child: Text("Add"),
                  onPressed: _addNewTask,
                  style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurple,
                  ),
                )
              ],
            ),
          ),
          Expanded(child:
            RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                  itemCount: _toDoList.length,
                  itemBuilder: buildItem
              ),

            )
          )
        ],
      )
    );
  }

  Widget buildItem(BuildContext context, int index){
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(Icons.delete, color: Colors.white),
        )
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(_toDoList[index]["title"]),
        value: _toDoList[index]["finished"],
        secondary: CircleAvatar(
          child:(Icon(_toDoList[index]["finished"] ? Icons.check : Icons.error)),
          backgroundColor: Colors.deepPurple,
        ),
        onChanged: (checked){
          setState(() {
            _toDoList[index]["finished"] = checked;
            _saveData();
          });
        },
      ),
      onDismissed: (direction){
        setState(() {
          _lastRemoved = Map.from(_toDoList[index]);
          _lastRemovedPos = index;
          _toDoList.removeAt(index);
          _saveData();
        });

        final snack = SnackBar(
            content: Text("Tarefa \"${_lastRemoved["title"]}\" removida!"),
            action: SnackBarAction(label: "Desfazer",
              onPressed: (){
                setState(() {
                  _toDoList.insert(_lastRemovedPos, _lastRemoved);
                  _saveData();
                });
              },
            ),
            duration: Duration(seconds: 3)
        );

        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(snack);
      },

    );
  }

  Future<File> _getFile() async{
    final dir = await getApplicationDocumentsDirectory();
    return File("${dir.path}/task.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_toDoList);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}
