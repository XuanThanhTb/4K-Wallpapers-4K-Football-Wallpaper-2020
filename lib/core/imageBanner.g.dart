// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'imageBanner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListDataBanner _$ListDataBannerFromJson(Map<String, dynamic> json) {
  return ListDataBanner(
    json['id'] as int,
    json['name'] as String,
    json['image'] as String,
    json['status'] as String,
    json['dayup'] as String,
  );
}

Map<String, dynamic> _$ListDataBannerToJson(ListDataBanner instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'status': instance.status,
      'dayup': instance.dayup,
    };
