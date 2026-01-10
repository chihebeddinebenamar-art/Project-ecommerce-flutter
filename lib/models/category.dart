class Category {
  final int id;
  final String name;
  final String? description;
  final String? image;
  final int? productCount;

  Category({
    required this.id,
    required this.name,
    this.description,
    this.image,
    this.productCount,
  });


  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      image: json['image'] as String?,
      productCount: json['productCount'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'productCount': productCount,
    };
  }
}

