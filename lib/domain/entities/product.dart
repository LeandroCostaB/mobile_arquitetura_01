class Product {
  final int id;
  final String title;
  final double price;
  final String image;
  final bool isFavorite;
  
  const Product ({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    this.isFavorite = false,
  });

  Product copyWith({
    int? id,
    String? title,
    double? price,
    String? image,
    bool? isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      image: image ?? this.image,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}