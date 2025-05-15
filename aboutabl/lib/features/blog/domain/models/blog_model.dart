import '../../../../data/model/image_full_url.dart';

class BlogModel {
  int? _id;
  String? _name;
  String? _slug;
  String? _icon;
  int? _parentId;
  int? _position;
  String? _createdAt;
  String? _updatedAt;
  List<BlogModel>? _childes;
  bool? isSelected;
  bool? _showSubInHome;
  ImageFullUrl? _imageFullUrl;

  BlogModel(
      {int? id,
      String? name,
      String? slug,
      String? icon,
      int? parentId,
      int? position,
      String? createdAt,
      String? updatedAt,
      List<BlogModel>? childes,
      this.isSelected,
      bool? showSubInHome,
      ImageFullUrl? imageFullUrl}) {
    _id = id;
    _name = name;
    _slug = slug;
    _icon = icon;
    _parentId = parentId;
    _position = position;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _childes = childes;
    _showSubInHome = showSubInHome;
    _imageFullUrl = imageFullUrl;
  }

  int? get id => _id;
  String? get name => _name;
  String? get slug => _slug;
  String? get icon => _icon;
  int? get parentId => _parentId;
  int? get position => _position;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  List<BlogModel>? get childes => _childes;
  bool? get showSubInHome => _showSubInHome;
  ImageFullUrl? get imageFullUrl => _imageFullUrl;

  BlogModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _slug = json['slug'];
    _icon = json['icon'];
    _showSubInHome = json['sub_home_status'] == 1;
    _parentId = json['parent_id'];
    _position = json['position'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    if (json['childes'] != null) {
      _childes = [];
      json['childes'].forEach((v) {
        _childes!.add(BlogModel.fromJson(v));
      });
    }
    _imageFullUrl = json['icon_full_url'] != null
        ? ImageFullUrl.fromJson(json['icon_full_url'])
        : null;
    isSelected = false;
  }
}
