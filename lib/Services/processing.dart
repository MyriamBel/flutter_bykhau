import 'package:bykhau/Models/tourobjects.dart';
import 'package:bykhau/Services/dbhelper.dart';


class Processor{
  int processor_subtourobject_id;
  List processor_category_id;
  SubTourobject processor_subtourobj;
  DBHelper dbHelper;


  proccess_subtourobject(Tourobject tourobj) async {
    processor_subtourobj = SubTourobject.fromMap(tourobj.toMap());
    processor_subtourobject_id = processor_subtourobj.id;
    processor_category_id = [];
    dbHelper = DBHelper();

    await insertTourobj(processor_subtourobj);
    if(tourobj.category.isNotEmpty) {
      //сохраним связанные категории в бд, вложенная функция описана ниже
      //сохраним связь многие-ко многим между данным туробъектом и категориями, вложенная функция описана ниже
      tourobj.category.forEach((element) {
        processor_category_id.add(element.id);
        dbHelper.truncateCategoryTable().then((value) {
          insertCategory(element);
        });
        TourobjectToCategoryModel relation; //relation's model, have id obj and id cat
        relation = TourobjectToCategoryModel();
        relation.category = element.id;
        relation.tourobject = tourobj.id;
        dbHelper.truncateRelationsTable().then((value) {
          insertRelation(relation);

        });
      });
    }
    if(tourobj.photos.toList().isNotEmpty) {
      //сохраним связанные фотографии
      tourobj.photos.forEach((element) {
        dbHelper.truncatePhotosTable().then((value) {
          insertPhoto(element);
        });
      });
    }
    if(tourobj.phones.toList().isNotEmpty) {
      //сохраним связанные телефоны, вложенная функция описана ниже
      tourobj.phones.forEach((element) {
        dbHelper.truncatePhonesTable().then((value) {
          insertPhone(element);
        });
      });
    }
    if(tourobj.emails.toList().isNotEmpty) {
      //сохраним связанные емейлы, вложенная функция описана ниже
      tourobj.emails.forEach((element) {
        dbHelper.truncateEmailsTable().then((value) {
          insertEmail(element);
        });
      });
    }
    if(tourobj.links.toList().isNotEmpty) {
      //сохраним связанные ссылки, вложенная функция описана ниже
      tourobj.links.forEach((element) {
        dbHelper.truncateLinksTable().then((value) {
          insertLink(element);
        });
      });
    }
    }

  insertTourobj(SubTourobject subtourobj) async {
    await dbHelper.saveTourobjectsToDb(subtourobj).then((value) {
      return;
    });
  }

  insertCategory(Category category) async {
    await dbHelper.saveCategoryToDB(category).then((value) {
      return;
    });
  }

  insertRelation(TourobjectToCategoryModel relation) async {
    await dbHelper.saveRelationToDB(relation).then((value) {
      return;
    });
  }

  insertPhoto(Photo photo) async {
    await dbHelper.savePhotoTODB(photo).then((value) {
      return;
    });
  }

  insertPhone(TourobjectPhone phone) async {
    await dbHelper.savePhoneTODB(phone).then((value) {
      return;
    });
  }

  insertEmail(TourobjectEmail email) async {
    await dbHelper.saveEmailTODB(email).then((value) {
      return;
    });
  }

  insertLink(TourobjectLink link) async {
    await dbHelper.saveLinkTODB(link).then((value) {
      return;
    });
  }
}