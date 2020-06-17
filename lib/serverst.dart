import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:wall_demo/core/api.dart';
import 'package:wall_demo/core/imageBanner.dart';
import 'package:wall_demo/core/model.dart';
import 'package:wall_demo/imageBlack.dart';

class ApiListData extends ApiClient {
  Future<ApiResponse<ListReponse<ListDataResultBlack>>> getListDataOcean(
      {int limit}) async {
    try {
      var uri = "get-data-footbool-app";
      var reponse = await get(uri);
      return ApiResponse(
        ListReponse(reponse.data, 'list_footbool_image',
            (item) => ListDataResultBlack.fromJson(item)),
        null,
        reponse.statusCode,
      );
    } on DioError catch (e) {
      return ApiResponse(null, ApiError.fromRequestError(e), null);
    }
  }

  Future<ApiResponse<ListReponse<ListDataResultBlack>>> getListDataHome() async {
    try {
      var uri = "get-data-football-home-app";
      var reponse = await get(uri);
      return ApiResponse(
        ListReponse(reponse.data, 'list_footbool_image',
            (item) => ListDataResultBlack.fromJson(item)),
        null,
        reponse.statusCode,
      );
    } on DioError catch (e) {
      return ApiResponse(null, ApiError.fromRequestError(e), null);
    }
  }
    Future<ApiResponse<ListReponse<ListDataResultBlack>>> getListDataDetails({int id}) async {
    try {
      var uri = "get-data-football-home-detail-app?id=$id";
      var reponse = await get(uri);
      return ApiResponse(
        ListReponse(reponse.data, 'list_footbool_image',
            (item) => ListDataResultBlack.fromJson(item)),
        null,
        reponse.statusCode,
      );
    } on DioError catch (e) {
      return ApiResponse(null, ApiError.fromRequestError(e), null);
    }
  }

    Future<ApiResponse<ListReponse<ListDataBanner>>> getListDataBannerApp() async {
    try {
      var uri = "get-data-banner-app";
      var reponse = await get(uri);
      return ApiResponse(
        ListReponse(reponse.data, 'list_banner_image',
            (item) => ListDataBanner.fromJson(item)),
        null,
        reponse.statusCode,
      );
    } on DioError catch (e) {
      return ApiResponse(null, ApiError.fromRequestError(e), null);
    }
  }
}
