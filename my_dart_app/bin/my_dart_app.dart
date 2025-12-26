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
    String choice = stdin.readLineSync() ?? '';

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
        if (confirmExit()) {
          saveOrdersToFile(orders);
          print('Thoát chương trình.');
          return;
        }
        break;
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

  String item;
  while (true) {
    item = readNonEmptyString('Item: ');
    bool exists = orders.any((o) => o.item.toLowerCase() == item.toLowerCase());

    if (!exists) break;
    print('❌ Item đã tồn tại. Vui lòng nhập Item khác.');
  }

  String itemName = readNonEmptyString('Item Name: ');
  double price = readDouble('Price: ');
  String currency = readNonEmptyString('Currency: ');
  int quantity = readInt('Quantity: ');

  orders.add(Order(item: item, itemName: itemName, price: price, currency: currency, quantity: quantity));

  print('✔ Thêm đơn hàng thành công.');
}

void searchOrders(List<Order> orders) {
  String keyword = readNonEmptyString('\nNhập tên sản phẩm cần tìm: ').toLowerCase();

  var results = orders.where((o) => o.itemName.toLowerCase().contains(keyword)).toList();

  if (results.isEmpty) {
    print('Không tìm thấy.');
  } else {
    displayOrders(results);
  }
}

bool confirmExit() {
  while (true) {
    stdout.write('Bạn có chắc chắn muốn thoát? (y/n): ');
    String answer = stdin.readLineSync()?.toLowerCase() ?? '';

    if (answer == 'y') return true;
    if (answer == 'n') return false;

    print('❌ Vui lòng nhập y hoặc n.');
  }
}

void saveOrdersToFile(List<Order> orders) {
  File file = File('order.json');
  var jsonList = orders.map((o) => o.toJson()).toList();
  file.writeAsStringSync(jsonEncode(jsonList));
  print('✔ Đã lưu file order.json');
}

String readNonEmptyString(String label) {
  while (true) {
    stdout.write(label);
    String? input = stdin.readLineSync();

    if (input != null && input.trim().isNotEmpty) {
      return input.trim();
    }
    print('❌ Không được để trống. Vui lòng nhập lại.');
  }
}

double readDouble(String label) {
  while (true) {
    stdout.write(label);
    double? value = double.tryParse(stdin.readLineSync() ?? '');

    if (value != null && value > 0) {
      return value;
    }
    print('❌ Vui lòng nhập số > 0.');
  }
}

int readInt(String label) {
  while (true) {
    stdout.write(label);
    int? value = int.tryParse(stdin.readLineSync() ?? '');

    if (value != null && value > 0) {
      return value;
    }
    print('❌ Vui lòng nhập số nguyên > 0.');
  }
}
