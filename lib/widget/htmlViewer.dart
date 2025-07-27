import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';


class htmlViewer extends StatelessWidget {
  final String html;

  htmlViewer({required this.html});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Html(data: html));
  }
}