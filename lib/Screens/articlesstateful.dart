import 'package:bykhau/Services/constants.dart';
import 'package:flutter/material.dart';
import 'package:bykhau/Models/articles.dart';
import 'package:bykhau/Services/dbhelper.dart';

class ArticlesScreen extends StatefulWidget {
  ArticlesScreen() : super();

  final String text = "Получение статей";

  @override
  ArticlesScreenState createState() => ArticlesScreenState();
}

class ArticlesScreenState extends State<ArticlesScreen> {
  List<Articles> articles = [];
  DBHelper dbHelper;
  bool loaded;
  String title;

  @override
  void initState() {
    super.initState();
    title = widget.text;
    loaded = false; //загрузка в процессе
    dbHelper = DBHelper();
    getArticles();
  }

  //получим из бд статьи
  void getArticles() async{
    setState(() {
      loaded = false;
    });
      final articlesfromdb = await dbHelper.getArticlesFromDB();
      if (articlesfromdb != null){
        articlesfromdb.forEach((row)
        {
            articles.add(row);
      });
        setState(() {
          loaded = true; //загрузка и запись в бд завершены
        });
      }
    }

  //выведем список статей
  @override
  Widget build(BuildContext context) {
    if(loaded){
      return Container(
        child: ListView.builder(
            itemCount: null == articles ? 0 : articles.length,
            itemBuilder: (context, index) {
          var day = articles[index].datetimePublication.day.toString().padLeft(2,'0');
          var month = articles[index].datetimePublication.month.toString().padLeft(2,'0');
          var year = articles[index].datetimePublication.year.toString();
          String datetimePublication = day+'.'+month+'.'+year[2]+year[3];
              return Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 30, 16.0, 0),
                child: GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(
                        context,
                        PagesList.DETAIL_PAGE,
                        arguments: articles[index].toMap()
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      articles[index].photo != null
                          ?Container(
                        child: Image.network(
                          articles[index].photo,
                          fit: BoxFit.cover,
                        height: 160,
                          width: MediaQuery.of(context).size.width - 32,
                        ),
                      )
                          :Container(),
                      articles[index].photo != null
                          ?Container(
                        height: 15,
                      )
                          :Container(),
                      Text(
                        articles[index].title,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(33, 33, 33, 1),
                          letterSpacing: 0.1
                        ),
                      ),
                      Container(
                        height: 6,
                      ),
                      Text(
                        articles[index].annotation,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(0, 0, 0, 0.87),
                          letterSpacing: 0.4,
                        ),
                      ),
                      Container(
                        height: 6,
                      ),
                      Text(
                        datetimePublication,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(192, 195, 199, 1),
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      );
    } else if(articles == null){
      setState(() {
        title = 'Сервер не доступен. Повторите попытку позже.';
      });
      return Text(title);
    } else {return Text(title);}
  }
}