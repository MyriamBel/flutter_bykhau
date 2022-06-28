import 'package:flutter/material.dart';
import 'package:bykhau/Models/tourarticles.dart';
import 'package:bykhau/Services/dbhelper.dart';

class TourarticlesScreen extends StatefulWidget {
  TourarticlesScreen() : super();

  final String text = "Получение статей";

  @override
  TourarticlesScreenState createState() => TourarticlesScreenState();
}

class TourarticlesScreenState extends State<TourarticlesScreen>{
  List<Tourarticle> tourarticles = [];
  DBHelper dbHelper;
  bool loaded;
  String title;

  @override
  void initState() {
    super.initState();
    title = widget.text;
    loaded = false; //загрузка в процессе
    dbHelper = DBHelper();
    getTourarticles();
  }

  //получим из бд статьи
  void getTourarticles() async{
    setState(() {
      loaded = false;
    });
    final tourarticlesfromdb = await dbHelper.getTourarticlesFromDB();
    if (tourarticlesfromdb.isNotEmpty){
      tourarticlesfromdb.forEach((row)
      {
        tourarticles.add(row);
      });
      setState(() {
        loaded = true; //загрузка и запись в бд завершены
      });
    } else {
      setState(() {
        loaded = true;
      });
    }
  }

  //выведем список статей
  @override
  Widget build(BuildContext context) {
    if(loaded){
      return Container(
        child: ListView.builder(
            itemCount: null == tourarticles ? 0 : tourarticles.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      height: 22,
                    ),
                    Text(
                        tourarticles[index].title,
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(27, 32, 40, 1),
                      ),
                    ),
                    Container(
                      height: 12,
                    ),
                    Text(
                        tourarticles[index].text,
                      style: TextStyle(
                fontSize: 14,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(0, 0, 0, 0.87),
                      ),
                    ),
                    tourarticles[index].photo != null
                    ?Container(
                      height: 30,
                    )
                    :Container(),
                    tourarticles[index].photo != null
                    ?Container(
                        child: Image.network(
                          tourarticles[index].photo,
                          fit: BoxFit.cover,),
                    )
                        :Container(),
                  ],
                ),
              );
            }),
      );
    } else if(tourarticles.isEmpty){
      setState(() {
        title = 'Ошибка загрузки. Повторите попытку позже.';
      });
      return Text(title);
    } else {return Text(title);}
  }
}