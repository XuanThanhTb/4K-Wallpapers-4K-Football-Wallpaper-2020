import 'package:dio/dio.dart';

class SingleReponse<T> {
  T item;
  SingleReponse(Map<String, dynamic> json, String itemRoot,
      T Function(dynamic itemJson) itemConverter) {
    if (itemRoot == null) {
      item = itemConverter(json);
    } else {
      var itemFomart = json[itemRoot];
      item = itemConverter(itemFomart);
    }
  }
}

class ListReponse<T> {
  List<T> listItem = [];
  ListReponse(Map<String, dynamic> json, String itemRoot,
      T Function(dynamic itemJson) itemConverter) {
    var itemJson = json[itemRoot];
    if (itemJson is List) {
      listItem = itemJson.map((itemConverter)).toList();
    }if(itemJson is Map){
      // listItem = itemJson
    }
  }
  @override
  String toString() {
    return listItem.map((f) => f.toString()).toString();
  }
}

class ApiResponse<T> {
  T data;
  ApiError error;
  int statusCode;
  ApiResponse(this.data, this.error, this.statusCode);
}

class ApiError {
  int statusCode;
  String message;
  DioErrorType type;

  ApiError(this.statusCode, this.message);

  ApiError.fromRequestError(DioError error) {
    this.statusCode = error.response == null ? -1 : error.response.statusCode;
    this.message = error.message;
    this.type = error.type;
  }
}
