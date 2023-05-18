class OrderModel {
  String id;
  String area;
  String name;
  int quantity;
  String brand;

  OrderModel({
    this.id = '',
    this.area = '',
    this.name = '',
    this.quantity = 0,
    this.brand = '',
  });

  factory OrderModel.fromCsv(var order) {
    var values = order.split(",");

    return OrderModel(
      id: values[0],
      area: values[1],
      name: values[2],
      quantity: int.parse(values[3]),
      brand: values[4],
    );
  }
}