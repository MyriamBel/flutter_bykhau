import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bykhau/Models/tourobjects.dart';
import 'package:bykhau/Services/dbhelper.dart';
import 'package:bykhau/Services/constants.dart';
import 'package:bykhau/main.dart';


class TourobjectsScreen extends StatefulWidget {

  final String text = "Получение списка туристических объектов";


  @override
  TourobjectsScreenState createState() => TourobjectsScreenState();
}

class TourobjectsScreenState extends State<TourobjectsScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context,BoxConstraints viewportConstraints){
          return SingleChildScrollView(
            physics: ScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child:
                Column( //кнопки категорий
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[ //Здесь вложены видимые на экране виджеты
                      ButtonsRow(),
                      SearchField(),
                      ListTourobjects()
                    ]
                ),
            ),
          );
        }
    );
  }
}

class ButtonsRow extends StatelessWidget {
  List<Widget> listButtons = [];

  @override
  Widget build(BuildContext context){
    return SizedBox(
      height: 68.0,
      child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Row(
                children: [
                  FutureBuilder(
                    future: InheritedWidgetProvider.of(context).dataRepository.getCategories(),
                    builder: (context, listCategories){
                      if(listCategories.hasData){
                        listButtons.clear();
                        for(var row  = 0; row < listCategories.data.length; row ++){
                          // if(listButtons.length > 0 && row == 0) {
                            listButtons.add(MyCustomButton(
                                name: listCategories.data[row].name,
                                id: listCategories.data[row].id.toString())
                            );
                          // }
                          if (StartInheritedWidgetProvider.of(context).startRepository.firstStartValue == true)
                          InheritedWidgetProvider.of(context).dataRepository.
                          listWidget[listCategories.data[row].id] =  false;
                        } return ButtonBar(
                          children: listButtons,
                        );
                      } return Container();
                    },
                  ),
                ]
            ),
          ]
      ),
    );
  }
}

class ListTourobjects extends StatefulWidget{

  @override
  _ListTourobjectsState createState() => _ListTourobjectsState();
}

class _ListTourobjectsState extends State<ListTourobjects> {
  List<SubTourobject> _list = [];
  DBHelper _dbHelper;
  bool _firstStart;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    final firstStartModel = StartInheritedWidgetProvider.of(context).startRepository;
    firstStartModel.addListener(() {
      _firstStart = firstStartModel.firstStartValue;
    });

    final model = InheritedWidgetProvider.of(context).dataRepository;
    model.addListener(() {
      _list = model.tourobjects;
      setState(() {});
    });
  }

  Future getInitialData() async {
    _dbHelper = DBHelper();
    final _touronbectsfromdb = await _dbHelper.getTourobjectFromDB();
    var _result = [];
    if (_touronbectsfromdb.isNotEmpty) {
      _touronbectsfromdb.forEach((row) {
        InheritedWidgetProvider.of(context).dataRepository.tourobjects.add(row);
        _result.add(row);
      });
    }

    StartInheritedWidgetProvider.of(context).startRepository.firstStartValue = false;
    return _result;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (StartInheritedWidgetProvider.of(context).startRepository.firstStartValue == true) {
      return FutureBuilder(
        future: getInitialData(),
        builder: (context, listTourobjects) {
          if (listTourobjects.hasData) {
            for (var row in listTourobjects.data) {
              _list.add(row);
            }
            return null != _list ?
            listviewbuilder(listobjects: _list)
                : Container();
          } else
            return Text('Загрузка данных...');
        },
      );
    } else {
      return null != _list ?
      listviewbuilder(listobjects: _list)
          :Container();
    }
  }
}

class listviewbuilder extends StatelessWidget{
  DBHelper _dbHelper;
  List listobjects;

  listviewbuilder({Key key, this.listobjects}) : super(key: key);

  Future getTourobjectsImage(int id) async {
    _dbHelper = DBHelper();
    final _photosfromdb = await _dbHelper.getTourobjectImage(id);
    return _photosfromdb;
  }

  Widget buildImage (int id) {
    return FutureBuilder(
        future:(getTourobjectsImage(id)),
        builder: (context, image) {
          if (image.hasData) {
            if (image.data.length > 0) {
              return Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Image.network(
                      image.data,
                      fit: BoxFit.cover,),
                  )
              );
            } else
              return Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Image.asset(
                      'assets/imgs/les.png',
                      fit: BoxFit.cover,),
                  )
              );
          } else
            return Container();
        }
    );
  }

  Widget build(BuildContext context){
    return ListView.builder(
        itemExtent: 140.0,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: null == this.listobjects ? 0 : this.listobjects.length,
        itemBuilder: (thisContext, index) {
          final imageString = buildImage(this.listobjects[index].id);
          return null != this.listobjects ?
          GestureDetector(
            onTap: () async {
              Navigator.pushNamed(
                      context,
                      PagesList.DETAIL_PAGE,
                      arguments:
                        this.listobjects[index].toMap(),
              );
            },
            child: tourobjCard(imgString: imageString, object: this.listobjects[index]),
          )
              : Container();
        }
    );
  }
}

class tourobjCard extends StatelessWidget{
  Widget imgString;
  SubTourobject object;

  tourobjCard({Key key, this.imgString, this.object}) : super(key: key);

  Widget build(BuildContext context){
    return Container(
      height: 120.0,
      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      child: Card(
        color: Colors.white,
        elevation: 0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 15.0,
            ),
            Container(
              height: 120.0,
              width: 120.0,
              child: this.imgString,
            ),
            Container(
              width: 15.0,
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    this.object.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'RobotoMedium',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    height: 10.0,
                  ),
                  Text(
                    this.object.address,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        fontSize: 12
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchField extends StatefulWidget{
  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final _controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Container( //поиск в каталоге
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 22.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onChanged: (String text){
                      InheritedWidgetProvider.of(context).dataRepository.searchText = _controller.text;
                      setState(() {});
                    },
                    onSubmitted: (String text){
                      InheritedWidgetProvider.of(context).dataRepository.searchText = _controller.text;
                      InheritedWidgetProvider.of(context).dataRepository.getData();
                    },
                    decoration: InputDecoration(
                      prefixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: (){
                          InheritedWidgetProvider.of(context).dataRepository.getData();
                        },
                      ),

                      hintText: 'Поиск в каталоге',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () => InheritedWidgetProvider.of(context).dataRepository.sortTourobjects(),
                    icon: Icon(Icons.sort),
                )
              ],
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}

class MyCustomButton extends StatefulWidget {
  String name;
  String id;
  bool pressed = false;

  MyCustomButton({Key key, this.name, this.id}) : super(key: key);

  @override
  _MyButtonState createState() {
    return _MyButtonState(this.name, this.id);
  }
}

class _MyButtonState extends State<MyCustomButton>{
  String name;
  String id;
  bool pressed = false;

  _MyButtonState(this.name, this.id);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: (){
        setState(() {
          this.pressed = !this.pressed; //зададим значение переменной для стиля кнопки
        });
        //переключаем значение для выборки списка объектов выбранного типа
        this.pressed == true
        ?InheritedWidgetProvider.of(context).dataRepository.listWidget[int.parse(this.id)] = true
        :InheritedWidgetProvider.of(context).dataRepository.listWidget[int.parse(this.id)] = false;


        //TODO BUTTON
        //запустим выборку нового списка туробъектов
        InheritedWidgetProvider.of(context).dataRepository.getData();
      },
      child: Text(name),
      style: OutlinedButton.styleFrom(
        primary: pressed ? Colors.white : Color.fromRGBO(27, 32, 40, 0.7),
        backgroundColor: pressed ? Color.fromRGBO(255, 87, 34, 1) : Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        side: pressed ? BorderSide.none : BorderSide(
            width: 1, color: Color.fromRGBO(27, 32, 40, 0.7)),
      ),
    );
  }
}

