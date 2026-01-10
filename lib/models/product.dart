class ProductImage {
  final int id;
  final String url;
  final int productId;

  ProductImage({
    required this.id,
    required this.url,
    required this.productId,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'] as int,
      url: json['url'] as String,
      productId: json['productId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'productId': productId,
    };
  }
}

class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final double? finalPrice;
  final String size;
  final String color;
  final int stockQuantity;
  final int categoryId;
  final String categoryName;
  final int? discount;
  final bool? discountActive;
  final List<ProductImage> images;
  final double? rating;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.finalPrice,
    required this.size,
    required this.color,
    required this.stockQuantity,
    required this.categoryId,
    required this.categoryName,
    this.discount,
    this.discountActive,
    required this.images,
    this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      finalPrice: json['finalPrice'] != null
          ? (json['finalPrice'] as num).toDouble()
          : null,
      size: json['size'] as String,
      color: json['color'] as String,
      stockQuantity: json['stockQuantity'] as int,
      categoryId: json['categoryId'] as int,
      categoryName: json['categoryName'] as String,
      discount: json['discount'] as int?,
      discountActive: json['discountActive'] as bool?,
      images: (json['images'] as List<dynamic>?)
              ?.map((img) => ProductImage.fromJson(img as Map<String, dynamic>))
              .toList() ??
          [],
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'finalPrice': finalPrice,
      'size': size,
      'color': color,
      'stockQuantity': stockQuantity,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'discount': discount,
      'discountActive': discountActive,
      'images': images.map((img) => img.toJson()).toList(),
      'rating': rating,
    };
  }

  double get displayPrice => finalPrice ?? price;
  bool get hasDiscount => discount != null && discount! > 0 && (discountActive ?? false);
}

