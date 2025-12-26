import 'dart:convert';
import 'dart:io';

import 'package:my_dart_app/order.dart';

void main() {
  List<Order> orders = loadInitialOrders();
  runMenuLoop(orders);
}


List<Order> loadInitialOrders() {
  String jsonString = '''
[
  {"Item":"A1000","ItemName":"Iphone 15","Price":1200,"Currency":"USD","Quantity":1},
  {"Item":"A1001","ItemName":"Iphone 16","Price":1500,"Currency":"USD","Quantity":1}
]
''';

  List<dynamic> jsonData = jsonDecode(jsonString);
  return jsonData.map((e) => Order.fromJson(e)).toList();
}


void runMenuLoop(List<Order> orders) {
  while (true) {
    showMenu();
    stdout.write('Chọn chức năng: ');
    String choice = stdin.readLineSync()!;

    switch (choice) {
      case '1':
        displayOrders(orders);
        break;
      case '2':
        addOrder(orders);
        break;
      case '3':
        searchOrders(orders);
        break;
      case '4':
        saveOrdersToFile(orders);
        print('Thoát chương trình.');
        return;
      default:
        print('❌ Lựa chọn không hợp lệ.');
    }
  }
}


void showMenu() {
  print('\n========== MENU ==========');
  print('1. Hiển thị danh sách đơn hàng');
  print('2. Thêm đơn hàng mới');
  print('3. Tìm kiếm theo tên sản phẩm');
  print('4. Lưu file & Thoát');
  print('==========================');
}


void displayOrders(List<Order> orders) {
  if (orders.isEmpty) {
    print('Danh sách trống.');
    return;
  }

  print('\nItem\tItemName\tPrice\tCurrency\tQuantity');
  print('--------------------------------------------------');

  for (var o in orders) {
    print('${o.item}\t${o.itemName}\t${o.price}\t${o.currency}\t\t${o.quantity}');
  }
}


void addOrder(List<Order> orders) {
  print('\n--- Nhập đơn hàng mới ---');

  stdout.write('Item: ');
  String item = stdin.readLineSync()!;

  stdout.write('Item Name: ');
  String itemName = stdin.readLineSync()!;

  stdout.write('Price: ');
  double price = double.parse(stdin.readLineSync()!);

  stdout.write('Currency: ');
  String currency = stdin.readLineSync()!;

  stdout.write('Quantity: ');
  int quantity = int.parse(stdin.readLineSync()!);

  orders.add(Order(item: item, itemName: itemName, price: price, currency: currency, quantity: quantity));

  print('✔ Thêm thành công.');
}


void searchOrders(List<Order> orders) {
  stdout.write('\nNhập tên sản phẩm cần tìm: ');
  String keyword = stdin.readLineSync()!.toLowerCase();

  var results = orders.where((o) => o.itemName.toLowerCase().contains(keyword)).toList();

  if (results.isEmpty) {
    print('Không tìm thấy.');
  } else {
    displayOrders(results);
  }
}


void saveOrdersToFile(List<Order> orders) {
  File file = File('order.json');
  var jsonList = orders.map((o) => o.toJson()).toList();
  file.writeAsStringSync(jsonEncode(jsonList));
  print('✔ Đã lưu file order.json');
}
