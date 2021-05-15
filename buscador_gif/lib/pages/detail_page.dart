import 'package:flutter/material.dart';
import 'package:share/share.dart';


class DetailPage extends StatelessWidget {

  final Map _detailData;

  DetailPage(this._detailData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_detailData['title']),
        backgroundColor: Colors.black,
        actions: [
          IconButton(icon: Icon(Icons.share), onPressed: (){
            Share.share(_detailData['images']['fixed_height']['url']);
          })
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(_detailData['images']['fixed_height']['url'])
      )
    );
  }
}