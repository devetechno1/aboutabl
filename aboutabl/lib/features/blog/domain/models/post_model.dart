import '../../../../data/model/image_full_url.dart';

class PostModel {
  int id;
  String addedBy;
  int userId;
  String name;
  String slug;
  int categoryId;
  int? subCategoryId;
  int? subSubCategoryId;
  String thumbnail;
  String thumbnailStorageType;
  String? previewFile;
  String previewFileStorageType;
  int published;
  String details;
  String? metaTitle;
  String? metaDescription;
  String? metaImage;
  DateTime createdAt;
  DateTime updatedAt;
  int status;
  ThumbnailFullUrl thumbnailFullUrl;
  List<ImageFullUrl> imagesFullUrl;
  List<Tag> tags;

  PostModel({
    required this.id,
    required this.addedBy,
    required this.userId,
    required this.name,
    required this.slug,
    required this.categoryId,
    this.subCategoryId,
    this.subSubCategoryId,
    required this.thumbnail,
    required this.thumbnailStorageType,
    this.previewFile,
    required this.previewFileStorageType,
    required this.published,
    required this.details,
    this.metaTitle,
    this.metaDescription,
    this.metaImage,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.thumbnailFullUrl,
    required this.imagesFullUrl,
    required this.tags,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      addedBy: json['added_by'],
      userId: json['user_id'],
      name: json['name'],
      slug: json['slug'],
      categoryId: json['category_id'],
      subCategoryId: json['sub_category_id'],
      subSubCategoryId: json['sub_sub_category_id'],
      thumbnail: json['thumbnail'],
      thumbnailStorageType: json['thumbnail_storage_type'],
      previewFile: json['preview_file'],
      previewFileStorageType: json['preview_file_storage_type'],
      published: json['published'],
      details: json['details'],
      metaTitle: json['meta_title'],
      metaDescription: json['meta_description'],
      metaImage: json['meta_image'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      status: json['status'],
      thumbnailFullUrl: ThumbnailFullUrl.fromJson(json['thumbnail_full_url']),
      imagesFullUrl: (json['images_full_url'] as List)
          .map((i) => ImageFullUrl.fromJson(i))
          .toList(),
      tags: (json['tags'] as List).map((i) => Tag.fromJson(i)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'added_by': addedBy,
      'user_id': userId,
      'name': name,
      'slug': slug,
      'category_id': categoryId,
      'sub_category_id': subCategoryId,
      'sub_sub_category_id': subSubCategoryId,
      'thumbnail': thumbnail,
      'thumbnail_storage_type': thumbnailStorageType,
      'preview_file': previewFile,
      'preview_file_storage_type': previewFileStorageType,
      'published': published,
      'details': details,
      'meta_title': metaTitle,
      'meta_description': metaDescription,
      'meta_image': metaImage,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'status': status,
      'thumbnail_full_url': thumbnailFullUrl.toJson(),
      'images_full_url': imagesFullUrl.map((i) => i.toJson()).toList(),
      'tags': tags.map((i) => i.toJson()).toList(),
    };
  }
}

class ThumbnailFullUrl {
  String key;
  String path;
  int status;

  ThumbnailFullUrl(
      {required this.key, required this.path, required this.status});

  factory ThumbnailFullUrl.fromJson(Map<String, dynamic> json) {
    return ThumbnailFullUrl(
      key: json['key'],
      path: json['path'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'path': path,
      'status': status,
    };
  }
}

class Tag {
  int id;
  String tag;
  int visitCount;
  DateTime createdAt;
  DateTime updatedAt;
  Pivot pivot;

  Tag({
    required this.id,
    required this.tag,
    required this.visitCount,
    required this.createdAt,
    required this.updatedAt,
    required this.pivot,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'],
      tag: json['tag'],
      visitCount: json['visit_count'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      pivot: Pivot.fromJson(json['pivot']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tag': tag,
      'visit_count': visitCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'pivot': pivot.toJson(),
    };
  }
}

class Pivot {
  int postId;
  int tagId;

  Pivot({required this.postId, required this.tagId});

  factory Pivot.fromJson(Map<String, dynamic> json) {
    return Pivot(
      postId: json['post_id'],
      tagId: json['tag_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'post_id': postId,
      'tag_id': tagId,
    };
  }
}
