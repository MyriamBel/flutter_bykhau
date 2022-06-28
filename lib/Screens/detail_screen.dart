import 'package:bykhau/Models/articles.dart';
import 'package:bykhau/Models/tourobjects.dart';
import 'package:bykhau/Services/dbhelper.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class DetailScreen extends StatelessWidget{
  DetailScreen({Key key}) : super(key: key);

  //Используя этот класс, вернем весь экран
  @override
  Widget build(BuildContext context) {

    var internalMap = ModalRoute.of(context).settings.arguments as Map;
    var convertedMap = Map<String, dynamic>.from(internalMap);

    return SafeArea(
      top: false,
      bottom: true,
        child: (convertedMap.containsKey("title"))
            ? Scaffold(
          appBar: _buildAppbarWidget(Articles.fromMap(convertedMap)),
          body: _buildBodyWidget(object: Articles.fromMap(convertedMap)),
        )
            : Scaffold(
          appBar: _buildAppbarWidget(SubTourobject.fromMap(convertedMap)),
          body: _buildBodyWidget(object: SubTourobject.fromMap(convertedMap)),
        ),
    );
  }
}

//Этот метод следует использовать для построения панели приложения, если у
// объекта будет только одна картинка
AppBar _buildAppBarOneImageWidget(String img) {
  // return PreferredSize(
      return AppBar(
        leading: Builder(
          builder: (BuildContext context){
            return IconButton(
                onPressed: (){
                  Navigator.pop(context);
                  },
                icon: const Icon(Icons.arrow_back),
                color: Colors.white,
                iconSize: 16.0
            );
          },
        ),
        automaticallyImplyLeading: false,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  img
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
}

//Этот метод следует использовать для построения панели приложения, если у
// объекта будет несколько изображений
AppBar _buildAppBarCarouselImageWidget(List img){
  return AppBar(
    backgroundColor: Colors.white,
        leading: Builder(
          builder: (BuildContext context){
            return IconButton(
                onPressed: (){Navigator.pop(context);},
                icon: const Icon(Icons.arrow_back),
                color: Colors.white,
                iconSize: 16.0
            );
          },
        ),
        automaticallyImplyLeading: false,
        brightness: Brightness.light,
        flexibleSpace: Container(
          child: _imageCardBuilder(img),
          ),
          );
}

class _imageCardBuilder extends StatelessWidget{
  List object;

  _imageCardBuilder(this.object);

  List<Widget> renderImages(){
    var temp = <Widget>[];
    for(var img in object){
      temp.add(
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(img),
                fit: BoxFit.cover,
              ),
            ),
          ),
      );
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return Carousel(
      dotBgColor: Colors.transparent,
      dotSize: 4,
      dotSpacing: 8,
      autoplayDuration: Duration(seconds: 10),
      images: renderImages(),
    );
  }
}

//Этот метод возвращает панель приложения с картинкой по умолчанию для тех
// объектов, у которых не задано изображение
AppBar _biuldNoImageAppBarWidget(){
  return AppBar(
        automaticallyImplyLeading: false,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/imgs/les.png',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        leading: Builder(
          builder: (BuildContext context){
            return IconButton(
                onPressed: (){Navigator.pop(
                    context,
                );},
                icon: const Icon(Icons.arrow_back),
                color: Colors.white,
                iconSize: 16.0
            );
          },
        ),
  );
}

//Выберем картинки из бд, посчитаем, сколько их, и, в зависимости от результата,
//выведем нужный виджет в appbar
PreferredSize _buildAppbarWidget(object) {
  return PreferredSize(
      child: _buildAppbarWidgetX(object: object),
      preferredSize: Size.fromHeight(240),
  );
}

class _buildAppbarWidgetX extends StatefulWidget{
  var object;
  _buildAppbarWidgetX({Key key, this.object}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
      return AppbarScreenState(this.object);
    }
  }

class AppbarScreenState extends State<_buildAppbarWidgetX>{
  var object;
  DBHelper _dbHelper;

  AppbarScreenState(this.object);

  void initState(){
    super.initState();
  }

  getImages(object) async { //получаем картинки
    _dbHelper = DBHelper();
    if (object is SubTourobject) {
      var _image = await _dbHelper.getTourobjectImages(object.id) as List; //list of images object
      List imagesList = [];
      if(_image.length > 0) {
        for (var x in _image) {
          imagesList.add(x['name']);
        }
      }
      if (imagesList != []){
        return imagesList;
      }
      } else {
      var _imageString;
      List _image = await _dbHelper.getArticleImage(object.id) as List;
      if (_image.length > 0) _imageString = _image[0]['photo'] as String;
      if(_imageString != null){
        return _imageString;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getImages(object),
      builder: (context, images) {
        var img;
        if(images.hasData) {
          img = images.data;
          if (img is List && img.length == 1) {
            img = img[0];
          }
          if (img is String) {
            return _buildAppBarOneImageWidget(img);
          } else if(img.length > 0) return _buildAppBarCarouselImageWidget(img);
          else return _biuldNoImageAppBarWidget();
        }else return _biuldNoImageAppBarWidget();
      }
    );
  }
}

// Класс для построения тела страницы
class _buildBodyWidget extends StatefulWidget {
  var object;
  var savedListTourobjects;

  _buildBodyWidget({ Key key, this.object}) : super(key: key);

  @override
  BodyScreenState createState() {
    return BodyScreenState(this.object);
  }
}

class BodyScreenState extends State<_buildBodyWidget>{
  var object;
  DBHelper _dbHelper;

  BodyScreenState(this.object);

  void initState() {
    super.initState();
  }

  getTourobjectInfo() async {
    String _contact = 'Контакты: ';
    _dbHelper = DBHelper();
    var infoPhone = await _dbHelper.getTourobjectPhoneElements(object.id);
    var infoEmail = await _dbHelper.getTourobjectEmailElements(object.id);
    var infoLink = await _dbHelper.getTourobjectLinkElements(object.id);
    for (var row in infoPhone) {
      _contact += row['phone'] + ', ';
    }
    for (var row in infoEmail) {
      _contact += row['email'] + ', ';
    }
    for (var row in infoLink) {
      _contact += row['link'] + ', ';
    }
    return _contact;
  }

  @override
  Widget build(BuildContext context) {

    if (object.runtimeType == Articles) {
      var day = object.datetimePublication.day.toString().padLeft(2,'0');
      var month = object.datetimePublication.month.toString().padLeft(2,'0');
      var year = object.datetimePublication.year.toString();
      String datetimePublication = day+'.'+month+'.'+year[2]+year[3];
      return SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 31.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        object.title,
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(27, 32, 40, 1),
                      ),
                    ),
                    Container(
                      height: 12.0,
                    ),
                    Text(
                        object.text,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(0, 0, 0, 0.87),
                      ),
                    ),
                    Container(
                      height: 15.0,
                    ),
                    Text(
                        datetimePublication,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(192, 195, 199, 1),
                          letterSpacing: 0.4
                      ),
                    ),
                  ]
              ),
            ),
          ),
        ),
      );
    } else {
      return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 31.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                      object.name,
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(27, 32, 40, 1),
                        letterSpacing: 0.1
                    ),
                  ),
                  if ((object.address != null) & (object.address != ''))
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: RichText(
                        text: TextSpan(
                          text: 'Адрес: ',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(27, 32, 40, 1),
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: '${object.address}',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(27, 32, 40, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  (object.coordN != null) & (object.coordE != null)
                      ?Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Text(
                        "(N ${object.coordN}, E ${object.coordE})",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(27, 32, 40, 1),
                      ),
                        ),
                      )
                      :(object.coordN == null) & (object.coordE != null)
                        ? Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                            "(N none, E ${object.coordE})",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(27, 32, 40, 1),
                              ),
                          ),
                        )
                        :(object.coordN != null) & (object.coordE == null)
                          ? Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text("(N ${object.coordN}, E none)"),
                          )
                        : Container(),
                  FutureBuilder(
                        future: getTourobjectInfo(),
                        builder: (context, phones){
                          if(phones.hasData) {
                            return phones.data.toString().length > 10
                          ?Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: RichText(
                                  text: TextSpan(
                                    text: phones.data.toString().substring(0, 10),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(27, 32, 40, 1),
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: phones.data.toString().substring(10, phones.data.toString().length-2),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromRGBO(27, 32, 40, 1),
                                        ),
                                      ),
                                    ],
                                  ),
                              ),
                          )
                                :Container();
                          } else return Container();
                        }
                      ),
                  (object.description == null || object.description == '')
                      ?Container()
                      :Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Text(
                            object.description,
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(0, 0, 0, 0.87),
                          ),
                        ),
                      )
                ]
            ),
          ),
      );
    }
  }
}