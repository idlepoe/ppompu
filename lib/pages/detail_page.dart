import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class DetailPage extends StatefulWidget {
  final String url;
  DetailPage({super.key, required this.url});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<String> _list = [];

  @override
  void initState() {
    getDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("detail")),
      body: ListView.builder(
        itemCount: _list.length,
        itemBuilder: (context, index) {
          return Image.network(_list[index]);
        },
      ),
    );
  }

  void getDetail() async {
    var client = http.Client();
    var url = Uri.parse(widget.url);
    var response = await http.get(url);

    _list = [];

    dom.Document document = parse(response.body);
    dom.Element? body = document.querySelector(".articleView");
    List<dom.Element>? imgBody = body!.querySelectorAll("img");

    for (int i = 0; i < imgBody.length; i++) {
      String imageUrl = imgBody[i].attributes["src"] ?? "";
      _list.add(imageUrl);
    }
    setState(() {});
    client.close();
  }
}
