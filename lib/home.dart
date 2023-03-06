import 'package:flutter/material.dart';
import 'package:quotes_app/quotespage.dart';
import 'package:quotes_app/utils.dart';

import 'package:http/http.dart' as http;
import 'package:html/dom.dart'as dom;
import 'package:html/parser.dart'as parser;
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List quotes=[];
  List authors=[];
  bool isData=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getQuotes();
  }
  getQuotes()async{
    String url="https://quotes.toscrape.com/";
    Uri uri=Uri.parse(url);
    http.Response response=await http.get(uri);
    dom.Document document=parser.parse(response.body);
    final quotesclass=document.getElementsByClassName("quote");
    quotes=quotesclass.map((element) => element.getElementsByClassName('text')[0].innerHtml).toList();
    authors=quotesclass.map((element) => element.getElementsByClassName('author')[0].innerHtml).toList();

    setState(() {
      isData=true;
    });
  }
  List<String> categories = ["love", "inspirational", "life", "humor"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 50),
              child: Text(
                "Quotes App",
                style: textStyle(25, Colors.black, FontWeight.w700),
              ),
            ),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),//because of two scrollview
              mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              children:categories.map((category){
                return InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>QuotesPage(category)));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(child:Text(
                      category.toUpperCase(),
                      style: textStyle(25,Colors.white,FontWeight.w700),
                    )),
                  ),
                );
              }).toList(),
            ),SizedBox(height:20 ,),
            isData == false? Center(child: CircularProgressIndicator(),) :ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount:quotes.length ,
                itemBuilder: (context,index){
                  return Container(
                    padding: EdgeInsets.all(10),
                    child: Card(
                      elevation: 10,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0,left:20,bottom: 20),
                            child: Text(quotes[index],
                              style: textStyle(18,Colors.black,FontWeight.w700,),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(authors[index],
                              style: textStyle(15,Colors.black38,FontWeight.w700,),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
