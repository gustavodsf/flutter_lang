import 'package:flutter/material.dart';
import 'package:buscador_gif/pages/home_page.dart';
import 'package:buscador_gif/pages/detail_page.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case 'detail/':
      return MaterialPageRoute(builder: (context) => DetailPage(settings.arguments));
  }
}

void main(){
  runApp(MaterialApp(
      title: "flutter example",
      home: HomePage(),
      theme: ThemeData(hintColor: Colors.white),
      onGenerateRoute: generateRoute,
  ));
}
