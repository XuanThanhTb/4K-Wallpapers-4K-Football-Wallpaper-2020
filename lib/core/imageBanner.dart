import 'package:json_annotation/json_annotation.dart';
part 'imageBanner.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ListDataBanner {
  int id;
  String name;
  String image;
  String status;
  String dayup;
  ListDataBanner(this.id, this.name, this.image, this.status, this.dayup);

  factory ListDataBanner.fromJson(Map<String, dynamic> json) =>  _$ListDataBannerFromJson(json);
  toJson() =>  _$ListDataBannerToJson(this.toJson());
}
