import 'package:json_annotation/json_annotation.dart';
part 'imageBlack.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ListDataResultBlack {
  int id;
  String name;
  String image;
  ListDataResultBlack(this.id, this.name, this.image);

  factory ListDataResultBlack.fromJson(Map<String, dynamic> json) =>  _$ListDataResultBlackFromJson(json);
  toJson() =>  _$ListDataResultBlackToJson(this.toJson());
}
