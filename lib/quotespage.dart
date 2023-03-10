
import 'package:flutter/material.dart';
import 'package:quotes_app/utils.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart'as dom;
import 'package:html/parser.dart'as parser;
class QuotesPage extends StatefulWidget {
 final String categname;

 QuotesPage(this.categname);

  @override
  State<QuotesPage> createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
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
    String url="https://quotes.toscrape.com/tag/${widget.categname}/";
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body:isData == false?Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
        physics: ScrollPhysics(),
        child:Column(
          children: [
        Container(
        alignment: Alignment.center,
          margin: EdgeInsets.only(top: 50),
          child: Text(
           "${widget.categname} quotes".toUpperCase(),
            style: textStyle(25, Colors.black, FontWeight.w700),
          ),
        ),
            ListView.builder(
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
