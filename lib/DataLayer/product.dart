class Product {
  int id;
  String name;
  String desc;
  String price;
  String image;
  String productType;
  String published;
  String discount;
  String createdAt;
  bool isFavorite;
  Product(
      {this.id,
      this.name,
      this.desc,
      this.price,
      this.image,
      this.published,
      this.discount,
      this.createdAt,
        this.productType,
      this.isFavorite});
}
