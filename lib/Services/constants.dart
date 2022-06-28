class Constants {
  static const String URL_BASE_SHEME = 'http://';
  static const String URL_DOMAIN = 'travelby.by'; //'94.228.112.91'

  static const String URL_DOMAIN_RESERVE = 'http://boiling-springs-36908.herokuapp.com';

  static const String APP_TOUROBJECT_PATH = '/api/tourobject/';
  static const String APP_ARTICLES_PATH = '/api/article/';
  static const String APP_TOURARTICLES_PATH = '/api/tourarticle/';

  static const String DB_NAME = 'Bykhau.db';
  static const String ARTICLE_TABLE = 'articles';
  static const String TOURARTICLE_TABLE = 'tourarticles';
  static const String TOUROBJECT_TABLE = 'tourobjects';
  static const String CATEGORY_TABLE = 'category';
  static const String PHOTOS_TABLE = 'photos';
  static const String PHONES_TABLE = 'phones';
  static const String EMAILS_TABLE = 'emails';
  static const String LINKS_TABLE = 'links';
  static const String TOUROBJECTTOCATEGORY_TABLE = 'TourobjectToCategory';

}

class ArticlesTable {
  static const String ARTICLE_COLUMN_ID = 'id';
  static const String ARTICLE_COLUMN_TYPE = 'type';
  static const String ARTICLE_COLUMN_TITLE = 'title';
  static const String ARTICLE_COLUMN_PHOTO = 'photo';
  static const String ARTICLE_COLUMN_ANNOTATION = 'annotation';
  static const String ARTICLE_COLUMN_TEXT = 'text';
  static const String ARTICLE_COLUMN_DATETIMECREATION = 'datetime_creation';
  static const String ARTICLE_COLUMN_DATETIMEPUBLICATION = 'datetime_publication';
  static const String ARTICLE_COLUMN_DATETIMEEDIT = 'datetime_edit';
  static const String ARTICLE_COLUMN_ACTIVE = 'active';
  static const String ARTICLE_COLUMN_PUBLISHED = 'published';
}

class TourArticlesTable {
  static const String TOURARTICLE_COLUMN_ID = 'id';
  static const String TOURARTICLE_COLUMN_TYPE = 'type';
  static const String TOURARTICLE_COLUMN_TITLE = 'title';
  static const String TOURARTICLE_COLUMN_PHOTO = 'photo';
  static const String TOURARTICLE_COLUMN_ANNOTATION = 'annotation';
  static const String TOURARTICLE_COLUMN_TEXT = 'text';
  static const String TOURARTICLE_COLUMN_DATETIMECREATION = 'datetime_creation';
  static const String TOURARTICLE_COLUMN_DATETIMEPUBLICATION = 'datetime_publication';
  static const String TOURARTICLE_COLUMN_DATETIMEEDIT = 'datetime_edit';
  static const String TOURARTICLE_COLUMN_ACTIVE = 'active';
  static const String TOURARTICLE_COLUMN_PUBLISHED = 'published';
}

class TourObjectTable {
  static const String TOUROBJECT_COLUMN_ID = 'id';
  static const String TOUROBJECT_COLUMN_NAME = 'name';
  static const String TOUROBJECT_COLUMN_ACTIVE = 'active';
  static const String TOUROBJECT_COLUMN_PUBLISHED = 'published';
  static const String TOUROBJECT_COLUMN_DESCRIPTION = 'description';
  static const String TOUROBJECT_COLUMN_COORDN = 'coordn';
  static const String TOUROBJECT_COLUMN_COORDE = 'coorde';
  static const String TOUROBJECT_COLUMN_ADDRESS = 'address';
}

class CategoryTable{
  static const String CATEGORY_COLUMN_ID = 'id';
  static const String CATEGORY_COLUMN_NAME = 'name';
  static const String CATEGORY_COLUMN_ACTIVE = 'active';
  static const String CATEGORY_COLUMN_PUBLISHED = 'published';
}

class PhotosTable{
  static const String PHOTO_COLUMN_ID = 'id';
  static const String PHOTO_COLUMN_NAME = 'name';
  static const String PHOTO_COLUMN_TOUROBJECT = 'tourobject';
}

class PhonesTable{
  static const String PHONE_COLUMN_ID = 'id';
  static const String PHONE_COLUMN_PHONE = 'phone';
  static const String PHONE_COLUMN_TOUROBJECT = 'tourobject';
}

class EmailsTable{
  static const String EMAIL_COLUMN_ID = 'id';
  static const String EMAIL_COLUMN_EMAIL = 'email';
  static const String EMAIL_COLUMN_TOUROBJECT = 'tourobject';
}

class LinksTable{
  static const String LINK_COLUMN_ID = 'id';
  static const String LINK_COLUMN_LINK = 'link';
  static const String LINK_COLUMN_TOUROBJECT = 'tourobject';
}

//Туробъекты связаны с категориями связью многие ко многим
class TourobjectToCategory{
  static const String TOUROBJECTTOCATEGORY_COLUMN_CATEGORY = 'category';
  static const String TOUROBJECTTOCATEGORY_COLUMN_TOUROBJECT = 'tourobject';
}

class PagesList{
  static const String MAIN_PAGE = '/';
  static const String DETAIL_PAGE = '/detail';
}