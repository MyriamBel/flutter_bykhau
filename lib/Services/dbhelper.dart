import 'dart:async';
import 'dart:io' as io;
import 'package:bykhau/Models/tourarticles.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'constants.dart';
import 'package:bykhau/Models/articles.dart';
import 'package:bykhau/Models/tourobjects.dart';

class DBHelper {
  static Database _db;

  //start block
  Future<Database> get db async{
    if (_db != null) {
      return _db;
    }

    _db = await initDB();
    return _db;
  }
  //реализуем метод для подключения к бд
  initDB() async{
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, Constants.DB_NAME); // dir.path + Constants.DB_NAME;
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }
  //реализуем метод для создания бд, если она не существует
  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE ${Constants.ARTICLE_TABLE}('
            '${ArticlesTable.ARTICLE_COLUMN_ID} INTEGER PRIMARY KEY,'
            '${ArticlesTable.ARTICLE_COLUMN_TYPE}  TEXT,'
            '${ArticlesTable.ARTICLE_COLUMN_TITLE} TEXT,'
            '${ArticlesTable.ARTICLE_COLUMN_PHOTO} TEXT,'
            '${ArticlesTable.ARTICLE_COLUMN_ANNOTATION}  TEXT,'
            '${ArticlesTable.ARTICLE_COLUMN_TEXT} TEXT,'
            '${ArticlesTable.ARTICLE_COLUMN_DATETIMECREATION} TEXT,'
            '${ArticlesTable.ARTICLE_COLUMN_DATETIMEPUBLICATION} TEXT,'
            '${ArticlesTable.ARTICLE_COLUMN_DATETIMEEDIT} TEXT,'
            '${ArticlesTable.ARTICLE_COLUMN_ACTIVE} TEXT,'
            '${ArticlesTable.ARTICLE_COLUMN_PUBLISHED} TEXT'
            ')'
    );
    await db.execute(
        'CREATE TABLE ${Constants.TOURARTICLE_TABLE}('
            '${TourArticlesTable.TOURARTICLE_COLUMN_ID} INTEGER PRIMARY KEY,'
            '${TourArticlesTable.TOURARTICLE_COLUMN_TYPE}  TEXT,'
            '${TourArticlesTable.TOURARTICLE_COLUMN_TITLE} TEXT,'
            '${TourArticlesTable.TOURARTICLE_COLUMN_PHOTO} TEXT,'
            '${TourArticlesTable.TOURARTICLE_COLUMN_ANNOTATION}  TEXT,'
            '${TourArticlesTable.TOURARTICLE_COLUMN_TEXT} TEXT,'
            '${TourArticlesTable.TOURARTICLE_COLUMN_DATETIMECREATION} TEXT,'
            '${TourArticlesTable.TOURARTICLE_COLUMN_DATETIMEPUBLICATION} TEXT,'
            '${TourArticlesTable.TOURARTICLE_COLUMN_DATETIMEEDIT} TEXT,'
            '${TourArticlesTable.TOURARTICLE_COLUMN_ACTIVE} TEXT,'
            '${TourArticlesTable.TOURARTICLE_COLUMN_PUBLISHED} TEXT'
            ')'
    );
    await db.execute(
      'CREATE TABLE ${Constants.TOUROBJECT_TABLE}('
          '${TourObjectTable.TOUROBJECT_COLUMN_ID} INTEGER PRIMARY KEY,'
          '${TourObjectTable.TOUROBJECT_COLUMN_NAME} TEXT,'
          '${TourObjectTable.TOUROBJECT_COLUMN_DESCRIPTION} TEXT,'
          '${TourObjectTable.TOUROBJECT_COLUMN_ACTIVE} TEXT,'
          '${TourObjectTable.TOUROBJECT_COLUMN_PUBLISHED} TEXT,'
          '${TourObjectTable.TOUROBJECT_COLUMN_COORDN} TEXT,'
          '${TourObjectTable.TOUROBJECT_COLUMN_COORDE} TEXT,'
          '${TourObjectTable.TOUROBJECT_COLUMN_ADDRESS} TEXT'
          ')'
    );
    await db.execute(
        'CREATE TABLE ${Constants.PHOTOS_TABLE}('
            '${PhotosTable.PHOTO_COLUMN_ID} INTEGER PRIMARY KEY,'
            '${PhotosTable.PHOTO_COLUMN_NAME} TEXT,'
            '${PhonesTable.PHONE_COLUMN_TOUROBJECT} INTEGER,'
            'FOREIGN KEY (${PhonesTable.PHONE_COLUMN_TOUROBJECT}) REFERENCES ${Constants.TOUROBJECT_TABLE}(${TourObjectTable.TOUROBJECT_COLUMN_ID})'
            ')'
    );
    await db.execute(
        'CREATE TABLE ${Constants.PHONES_TABLE}('
            '${PhonesTable.PHONE_COLUMN_ID} INTEGER PRIMARY KEY,'
            '${PhonesTable.PHONE_COLUMN_PHONE} TEXT,'
            '${PhonesTable.PHONE_COLUMN_TOUROBJECT} INTEGER,'
            'FOREIGN KEY (${PhonesTable.PHONE_COLUMN_TOUROBJECT}) REFERENCES ${Constants.TOUROBJECT_TABLE}(${TourObjectTable.TOUROBJECT_COLUMN_ID})'
            ')'
    );
    await db.execute(
        'CREATE TABLE ${Constants.EMAILS_TABLE}('
            '${EmailsTable.EMAIL_COLUMN_ID} INTEGER PRIMARY KEY,'
            '${EmailsTable.EMAIL_COLUMN_EMAIL} TEXT,'
            '${EmailsTable.EMAIL_COLUMN_TOUROBJECT} INTEGER,'
            'FOREIGN KEY (${EmailsTable.EMAIL_COLUMN_TOUROBJECT}) REFERENCES ${Constants.TOUROBJECT_TABLE}(${TourObjectTable.TOUROBJECT_COLUMN_ID})'
            ')'
    );
    await db.execute(
        'CREATE TABLE ${Constants.LINKS_TABLE}('
            '${LinksTable.LINK_COLUMN_ID} INTEGER PRIMARY KEY,'
            '${LinksTable.LINK_COLUMN_LINK} TEXT,'
            '${LinksTable.LINK_COLUMN_TOUROBJECT} INTEGER,'
            'FOREIGN KEY (${LinksTable.LINK_COLUMN_TOUROBJECT}) REFERENCES ${Constants.TOUROBJECT_TABLE}(${TourObjectTable.TOUROBJECT_COLUMN_ID})'
            ')'
    );
    await db.execute(
        'CREATE TABLE ${Constants.CATEGORY_TABLE}('
            '${CategoryTable.CATEGORY_COLUMN_ID} INTEGER PRIMARY KEY,'
            '${CategoryTable.CATEGORY_COLUMN_NAME} TEXT,'
            '${CategoryTable.CATEGORY_COLUMN_ACTIVE} TEXT,'
            '${CategoryTable.CATEGORY_COLUMN_PUBLISHED} TEXT'
            ')'
    );
    await db.execute(
      'CREATE TABLE ${Constants.TOUROBJECTTOCATEGORY_TABLE}('
          '${TourobjectToCategory.TOUROBJECTTOCATEGORY_COLUMN_TOUROBJECT} INTEGER NOT NULL,'
          '${TourobjectToCategory.TOUROBJECTTOCATEGORY_COLUMN_CATEGORY} INTEGER NOT NULL,'
          'FOREIGN KEY (${TourobjectToCategory.TOUROBJECTTOCATEGORY_COLUMN_TOUROBJECT}) REFERENCES ${Constants.TOUROBJECT_TABLE}(${TourObjectTable.TOUROBJECT_COLUMN_ID}) ON DELETE CASCADE ON UPDATE CASCADE,'
          'FOREIGN KEY (${TourobjectToCategory.TOUROBJECTTOCATEGORY_COLUMN_CATEGORY}) REFERENCES ${Constants.CATEGORY_TABLE}(${CategoryTable.CATEGORY_COLUMN_ID}) ON DELETE CASCADE ON UPDATE CASCADE,'
          'CONSTRAINT pk PRIMARY KEY (${TourobjectToCategory.TOUROBJECTTOCATEGORY_COLUMN_TOUROBJECT}, ${TourobjectToCategory.TOUROBJECTTOCATEGORY_COLUMN_CATEGORY})'
          ')'

    );
  }
  //end start block

  //Block for articles
  //Вставить статью в бд после того, как она будет сконвертирована в Map(json)
  Future<Articles> save(Articles article) async {
    var dbClient = await db;
    article.id = await dbClient.insert(Constants.ARTICLE_TABLE, article.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return article;
  }
  //Получить статьи из бд - переводим тип List<Map<String, Object>> в List<Object>
  Future<List<Articles>> getArticlesFromDB() async{
    var dbClient = await db;
    var res = await dbClient.query(Constants.ARTICLE_TABLE,
        columns: [
      ArticlesTable.ARTICLE_COLUMN_ID,
      ArticlesTable.ARTICLE_COLUMN_TYPE,
      ArticlesTable.ARTICLE_COLUMN_TITLE,
      ArticlesTable.ARTICLE_COLUMN_PHOTO,
      ArticlesTable.ARTICLE_COLUMN_ANNOTATION,
      ArticlesTable.ARTICLE_COLUMN_TEXT,
      ArticlesTable.ARTICLE_COLUMN_DATETIMECREATION,
      ArticlesTable.ARTICLE_COLUMN_DATETIMEPUBLICATION,
      ArticlesTable.ARTICLE_COLUMN_DATETIMEEDIT,
      ArticlesTable.ARTICLE_COLUMN_ACTIVE,
      ArticlesTable.ARTICLE_COLUMN_PUBLISHED,
    ]
    ); //названия колонок, которые хотим получить в результате
    List<Articles> list = res.map((e) => Articles.fromMap(e)).toList();
    return list;
  }
  //truncate the article table
  Future<void> truncateTable() async{
    var dbClient = await db;
    return await dbClient.delete(Constants.ARTICLE_TABLE);
  }
  //end block for articles

  Future<void> articlesCount() async{
    var dbClient = await db;
    int count = Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM ${Constants.ARTICLE_TABLE}'));
  }

  //Block for tourarticles
  //save tourarticle
  Future<Tourarticle> saveTourarticle(Tourarticle tourarticle) async {
    var dbClient = await db;
    tourarticle.id = await dbClient.insert(Constants.TOURARTICLE_TABLE, tourarticle.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return tourarticle;
  }
  //get tourarticles
  Future<List<Tourarticle>> getTourarticlesFromDB() async{
    var dbClient = await db;
    var res = await dbClient.query(Constants.TOURARTICLE_TABLE,
        columns: [
          TourArticlesTable.TOURARTICLE_COLUMN_ID,
          TourArticlesTable.TOURARTICLE_COLUMN_TYPE,
          TourArticlesTable.TOURARTICLE_COLUMN_TITLE,
          TourArticlesTable.TOURARTICLE_COLUMN_PHOTO,
          TourArticlesTable.TOURARTICLE_COLUMN_ANNOTATION,
          TourArticlesTable.TOURARTICLE_COLUMN_TEXT,
          TourArticlesTable.TOURARTICLE_COLUMN_DATETIMECREATION,
          TourArticlesTable.TOURARTICLE_COLUMN_DATETIMEPUBLICATION,
          TourArticlesTable.TOURARTICLE_COLUMN_DATETIMEEDIT,
          TourArticlesTable.TOURARTICLE_COLUMN_ACTIVE,
          TourArticlesTable.TOURARTICLE_COLUMN_PUBLISHED,
        ]
    ); //названия колонок, которые хотим получить в результате
    List<Tourarticle> list = res.map((e) => Tourarticle.fromMap(e)).toList();
    return list;
  }
  //truncate the tourarticle table
  Future<void> truncateTourarticleTable() async{
    var dbClient = await db;
    return await dbClient.delete(Constants.TOURARTICLE_TABLE);
  }
  //end block for tourarticle

  //Block for tourobjects
  //save tourobject
  Future<SubTourobject> saveTourobjectsToDb(SubTourobject subtourobject) async{
    var dbClient = await db;
    subtourobject.id = await dbClient.insert(Constants.TOUROBJECT_TABLE,
        subtourobject.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    var x = await dbClient.query(Constants.TOUROBJECT_TABLE);
    return subtourobject;
  }
  //get tourobjects
  Future<List<SubTourobject>> getTourobjectFromDB() async {
    var dbClient = await db;
    var res = await dbClient.query(Constants.TOUROBJECT_TABLE);
    List<SubTourobject> list = res.map((e) => SubTourobject.fromMap(e)).toList();
    return list;
  }
  //truncate tourobject table
  Future<void> truncateTourobjectTable() async{
    var dbClient = await db;
    return await dbClient.delete(Constants.TOUROBJECT_TABLE);
  }
  //end block for tourobject

  //Block for Category
  //save category
  Future<Category> saveCategoryToDB(Category category) async {
    var dbClient = await db;
    category.id = await dbClient.insert(Constants.CATEGORY_TABLE, category.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return category;
  }
  //get categories
  Future<List<Category>> getCategoryFromDB() async{
    var dbClient = await db;
    var res = await dbClient.query(Constants.CATEGORY_TABLE);
    List<Category> list = res.map((e) => Category.fromMap(e)).toList();
    return list;
  }
  //truncate category table
  Future<void> truncateCategoryTable() async{
    var dbClient = await db;
    return await dbClient.delete(Constants.CATEGORY_TABLE);
  }
  //end block for category

  //block for tourobject-category many-to-many relation
  //save relation
  Future<TourobjectToCategoryModel> saveRelationToDB(TourobjectToCategoryModel relation) async {
    var dbClient = await db;
    await dbClient.insert(Constants.TOUROBJECTTOCATEGORY_TABLE, relation.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }
  //get relations
  Future<List<TourobjectToCategoryModel>> getRelationsFromDB() async{
    var dbClient = await db;
    var res = await dbClient.query(Constants.TOUROBJECTTOCATEGORY_TABLE);
    List<TourobjectToCategoryModel> list = res.map((e) => TourobjectToCategoryModel.fromMap(e)).toList();
    return list;
  }
  //truncate relations table
  Future<void> truncateRelationsTable() async{
    var dbClient = await db;
    return await dbClient.delete(Constants.TOUROBJECTTOCATEGORY_TABLE);
  }
  //end block for tourobject-category many-to-many relation

  //block for tourobjects-photos
  //save photos
  Future<Photo> savePhotoTODB(Photo photo)async{
    var dbClient = await db;
    await dbClient.insert(Constants.PHOTOS_TABLE, photo.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }
  //get photos
  Future<List<Photo>> getPhotosFromDB() async{
    var dbClient = await db;
    var res = await dbClient.query(Constants.PHOTOS_TABLE);
    List<Photo> list = res.map((e) => Photo.fromMap(e)).toList();
    return list;
  }
  //truncate photos table
  Future<void> truncatePhotosTable() async{
    var dbClient = await db;
    return await dbClient.delete(Constants.PHOTOS_TABLE);
  }
  //end block for photos

  //start block for phones
  //save phones
  Future<TourobjectPhone> savePhoneTODB(TourobjectPhone phone)async{
    var dbClient = await db;
    await dbClient.insert(Constants.PHONES_TABLE, phone.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }
  //get phones
  Future<List<TourobjectPhone>> getPhonesFromDB() async{
    var dbClient = await db;
    var res = await dbClient.query(Constants.PHONES_TABLE);
    List<TourobjectPhone> list = res.map((e) => TourobjectPhone.fromMap(e)).toList();
    return list;
  }
  //truncate phones table
  Future<void> truncatePhonesTable() async{
    var dbClient = await db;
    return await dbClient.delete(Constants.PHONES_TABLE);
  }
  //end block for phones

  //start block for emails
  //save emails
  Future<TourobjectEmail> saveEmailTODB(TourobjectEmail email)async{
    var dbClient = await db;
    await dbClient.insert(Constants.EMAILS_TABLE, email.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }
  //get emails
  Future<List<TourobjectEmail>> getEmailsFromDB() async{
    var dbClient = await db;
    var res = await dbClient.query(Constants.EMAILS_TABLE);
    List<TourobjectEmail> list = res.map((e) => TourobjectEmail.fromMap(e)).toList();
    return list;
  }
  //truncate emails table
  Future<void> truncateEmailsTable() async{
    var dbClient = await db;
    return await dbClient.delete(Constants.EMAILS_TABLE);
  }
  //end block for emails

  //start block for links
  //save links
  Future<TourobjectLink> saveLinkTODB(TourobjectLink link)async{
    var dbClient = await db;
    await dbClient.insert(Constants.LINKS_TABLE, link.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }
  //get links
  Future<List<TourobjectLink>> getLinksFromDB() async{
    var dbClient = await db;
    var res = await dbClient.query(Constants.LINKS_TABLE);
    List<TourobjectLink> list = res.map((e) => TourobjectLink.fromMap(e)).toList();
    return list;
  }
  //truncate links table
  Future<void> truncateLinksTable() async{
    var dbClient = await db;
    return await dbClient.delete(Constants.LINKS_TABLE);
  }
  //end block for links

  //Метод для закрытия соединения с бд
  Future close() async{
    var dbClient = await db;
    dbClient.close();
  }

  getTourobjectPhoneElements(int id) async{
    var dbClient = await db;
    return await dbClient.rawQuery('SELECT * FROM ${Constants.PHONES_TABLE} '
        'WHERE ${PhonesTable.PHONE_COLUMN_TOUROBJECT} = ?', [id.toString()]);
  }
  getTourobjectEmailElements(int id) async {
    var dbClient = await db;
    return await dbClient.rawQuery('SELECT * FROM ${Constants.EMAILS_TABLE} '
        'WHERE ${EmailsTable.EMAIL_COLUMN_TOUROBJECT} = ?', [id.toString()]);
  }
  getTourobjectLinkElements(int id) async {
    var dbClient = await db;
    return await dbClient.rawQuery('SELECT * FROM ${Constants.LINKS_TABLE} '
        'WHERE ${LinksTable.LINK_COLUMN_TOUROBJECT} = ?', [id.toString()]);
  }

  getTourobjectImages(int id) async {
    var dbClient = await db;
    return await dbClient.rawQuery('SELECT ${PhotosTable.PHOTO_COLUMN_NAME} FROM ${Constants.PHOTOS_TABLE}'
        ' WHERE ${PhotosTable.PHOTO_COLUMN_TOUROBJECT} = ?', [id.toString()]);
  }

  getArticleImage(int id) async {
    var dbClient = await db;
    return await dbClient.rawQuery('SELECT ${ArticlesTable.ARTICLE_COLUMN_PHOTO}'
        ' FROM ${Constants.ARTICLE_TABLE} WHERE ${ArticlesTable.ARTICLE_COLUMN_ID}'
        ' = ?', [id.toString()]);
  }

  getTourobjectImage(int id) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT ${PhotosTable.PHOTO_COLUMN_NAME} '
            'FROM ${Constants.PHOTOS_TABLE} WHERE ${PhotosTable
            .PHOTO_COLUMN_TOUROBJECT} '
            '= ?', [id.toString()]);
    List<Photo> list = result.map((e) => Photo.fromMap(e)).toList();
    if (list.length > 0) {
      return list[0].name;
    } else return "";
  }

  getTourobjectsByClassIdAndSearchCondition(List listId, String searchCondition) async {
    var dbClient = await db;
    searchCondition.trim();
    if (searchCondition.length > 0 && listId.length > 0) {
      String argPlace = '?, ';
      String sqlRequestFirstPart =
          'SELECT * '
          'FROM ${Constants.TOUROBJECT_TABLE} '
          'WHERE '
          '${TourObjectTable.TOUROBJECT_COLUMN_ID} IN '
          '(SELECT ${TourobjectToCategory.TOUROBJECTTOCATEGORY_COLUMN_TOUROBJECT} '
          'FROM ${Constants.TOUROBJECTTOCATEGORY_TABLE} '
          'WHERE ${TourobjectToCategory.TOUROBJECTTOCATEGORY_COLUMN_CATEGORY} '
          'IN (';
      String sqlRequestSecondPart = ' AND '
          '(instr(${TourObjectTable.TOUROBJECT_COLUMN_NAME}, ?) > 0 '
          'OR instr(${TourObjectTable.TOUROBJECT_COLUMN_NAME}, ?) > 0 )';

      //список аргументов
      var args = [];
      //Соберем все аргументы и ?
      for (int id in listId){
        sqlRequestFirstPart += argPlace;
        args.add(id.toString());
      }
      sqlRequestFirstPart =
          sqlRequestFirstPart.substring(0, sqlRequestFirstPart.length-2)
              + '))'
              + sqlRequestSecondPart;
      args.add(searchCondition); //
      args.add(searchCondition[0].toUpperCase()+searchCondition.substring(1));
      var res = await dbClient.rawQuery(
          sqlRequestFirstPart, args
      );
      List<SubTourobject> list = res.map((e) => SubTourobject.fromMap(e))
          .toList();
      return list;
    } else if (searchCondition.length == 0 && listId.length > 0) {
      String argPlace = '?, ';
      String sqlRequest =
          'SELECT * '
          'FROM ${Constants.TOUROBJECT_TABLE} '
          'WHERE ${TourObjectTable.TOUROBJECT_COLUMN_ID} IN '
          '(SELECT ${TourobjectToCategory.TOUROBJECTTOCATEGORY_COLUMN_TOUROBJECT} '
          'FROM ${Constants.TOUROBJECTTOCATEGORY_TABLE} '
          'WHERE ${TourobjectToCategory.TOUROBJECTTOCATEGORY_COLUMN_CATEGORY} '
          'IN (';
      var args = [];
      for (int id in listId){
        sqlRequest += argPlace;
        args.add(id.toString());
      }
      sqlRequest = sqlRequest.substring(0, sqlRequest.length-2);
      var res = await dbClient.rawQuery(
        sqlRequest+'))', args
      );
      List<SubTourobject> list = res.map((e) => SubTourobject.fromMap(e))
          .toList();
      return list;
    } else if (listId.length == 0 && searchCondition.length > 0) {
      var res = await dbClient.rawQuery(
              'SELECT * '
              'FROM ${Constants.TOUROBJECT_TABLE} WHERE '
              'instr(${TourObjectTable.TOUROBJECT_COLUMN_NAME}, ?) > 0 '
              'OR instr(${TourObjectTable.TOUROBJECT_COLUMN_NAME}, ?) > 0 '
              '',
          [searchCondition, searchCondition[0].toUpperCase()+searchCondition.substring(1)]);
      List<SubTourobject> list = res.map((e) => SubTourobject.fromMap(e))
          .toList();
      return list;
    } else {
      var res = await dbClient.rawQuery(
              'SELECT * '
              'FROM ${Constants.TOUROBJECT_TABLE}');
      List<SubTourobject> list = res.map((e) => SubTourobject.fromMap(e))
          .toList();
      return list;
    }
  }

// //Удалить запись из бд
// Future<int> delete(int id) async {
//   var dbClient = await db;
//   return await dbClient.delete(Constants.ARTICLE_TABLE, where: ''
//       '${ArticlesTable.ARTICLE_COLUMN_ID} = ?', whereArgs: [id]);
// }
// //Обновить запись в бд
// Future<int> update(Articles article) async{
//   var dbClient = await db;
//   return await dbClient.update(Constants.ARTICLE_TABLE, article.toMap(),
//       where: '${ArticlesTable.ARTICLE_COLUMN_ID} = ?',
//       whereArgs: [article.id]);
// }

}

