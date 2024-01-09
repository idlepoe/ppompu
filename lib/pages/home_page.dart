import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:ppompu/pages/detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Item> _list = [];

  @override
  void initState() {
    // 사이트에서 데이터를 가져옴
    getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ppompu")),
      body: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: List.generate(
            _list.length,
            (index) {
              return InkWell(
                onTap: () {
                  // 상세 페이지로 이동
                  Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) {
                     return DetailPage(url: _list[index].detailUrl,);
                    },
                  ));
                },
                child: Column(
                  children: [
                    Image.network(_list[index].imageUrl, fit: BoxFit.fitWidth),
                    Text(_list[index].desc.trim()),
                  ],
                ),
              );
            },
          )),
      floatingActionButton: FloatingActionButton(onPressed: () {
        getList();
      }),
    );
  }

  void getList() async {
    var client = http.Client();
    var url = Uri.parse("https://www.inven.co.kr/board/webzine/2898?p=1");
    var response = await http.get(url);

    _list = [];

    dom.Document document = parse(response.body);
    List<dom.Element> body = document.querySelectorAll(".lgtm");

    for (int i = 0; i < body.length; i++) {
      dom.Element row = body[i];

      dom.Element? imgElement = row.querySelector("img");
      String imageUrl = imgElement!.attributes["src"] ?? "";

      List<dom.Element>? descElement = row.querySelectorAll("a");
      String desc = descElement![1].text;

      dom.Element? detailUrlElement = row.querySelector("a");
      String detailUrl = detailUrlElement!.attributes["href"] ?? "";

      _list.add(Item(imageUrl, desc, detailUrl));
    }
    setState(() {});
    client.close();
  }
}

class Item {
  String imageUrl;
  String desc;
  String detailUrl;

  Item(this.imageUrl, this.desc, this.detailUrl);
}
