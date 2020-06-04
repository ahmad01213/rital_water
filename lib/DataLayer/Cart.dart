class Cart {
  int quantity;
  int productId;

  Cart({this.quantity, this.productId});

  toJson() {
    return "\{\"quantity\"\: ${this.quantity},\"productId\"\: ${this.productId}\}";
  }

  static List encondeToJson(List<Cart> list) {
    List jsonList = List();
    list.map((item) => jsonList.add(item.toJson())).toList();
    return jsonList;
  }
}
