import 'dart:io';

import 'models/orderModel.dart';

void main() async {
  print("enter the file name");
  String? fileName = stdin.readLineSync();
  final lines = File('bin/$fileName').readAsLinesSync();
  List<OrderModel> orders = [];
  for (var x in lines) {
    orders.add(OrderModel.fromCsv(x));
  }

  averageQuantity(orders, fileName!);
  mostPopular(orders, fileName);
}

void averageQuantity(List<OrderModel> orders, String fileName) async {
  String resInFile = "";
  // use this map the calculate the total quantity for ever product name; 
  Map<String, int> quantityForEveryItem = {};

  for (OrderModel order in orders) {
    // check if first time or not product name in our map
    if (quantityForEveryItem[order.name] == null) {
      quantityForEveryItem[order.name] = order.quantity;
    } else {
      quantityForEveryItem[order.name] =
          quantityForEveryItem[order.name]! + order.quantity;
    }
  }
  // loop in map to calcuate the average quantity for every product name
  quantityForEveryItem.forEach((k, v) async {
    resInFile += "$k,${v / orders.length}\n";
  });
  await File("0_$fileName.csv").writeAsString(
    resInFile,
  );
}

void mostPopular(List<OrderModel> orders, String fileName) {
  String resInFile = "";
  // sort orders by product name to make easy to find most popular brand
  orders.sort((a, b) => a.name.compareTo(b.name));
  Map<String, int> brandOccurrence = {};
  String lastProductName = "";
  int maxBrandOccurrence = 0;
  String brandName = "";

  for (OrderModel order in orders) {
    if (lastProductName == "") {
      lastProductName = order.name;
    }
    // check if product name first time appear find max in last product name 
    // and reset the data to start in new product name
    if (order.name != lastProductName) {
      maxBrandOccurrence = 0;
      brandName = "";
      brandOccurrence.forEach((key, value) {
        if (value > maxBrandOccurrence) {
          maxBrandOccurrence = value;
          brandName = key;
        }
      });
      resInFile += "$lastProductName,$brandName\n";
      brandOccurrence.clear();
      lastProductName = order.name;
    }
    if (brandOccurrence[order.brand] == null) {
      brandOccurrence[order.brand] = 1;
    } else {
      brandOccurrence[order.brand] = brandOccurrence[order.brand]! + 1;
    }
  }
  maxBrandOccurrence = 0;
  brandName = "";
  brandOccurrence.forEach((key, value) {
    if (value > maxBrandOccurrence) {
      maxBrandOccurrence = value;
      brandName = key;
    }
  });
  resInFile += "$lastProductName,$brandName\n";
  File("1_$fileName.csv").writeAsString(
    resInFile,
  );
}
