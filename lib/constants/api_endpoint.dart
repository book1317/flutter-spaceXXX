class BaseURL {
  BaseURL._();
  static const dev = 'https://api-dev.xxx.com';
}

class PublicAssetsURL {
  PublicAssetsURL._();
  static const dev = 'https://assets-dev.xxx.com';
}

class RecordServicePath {
  RecordServicePath._();

  static const folderInfo = '/api/record-service/v1/public/folder/info';
  static const createByQR = '/api/record-service/v1/record/qr';
  static const record = '/api/record-service/v1/record';
  static const pending = '/api/record-service/v1/record/pending';
}

class ApiServicePath {
  ApiServicePath._();
  static const categories = '/api/user-profile-service/v1/categories';
}
