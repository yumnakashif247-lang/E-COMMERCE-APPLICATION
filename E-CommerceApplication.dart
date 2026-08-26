import 'dart:io';
import 'dart:convert';
import 'dart:math';

Future<void> main() async {
  ECommerce app = ECommerce();

  stdout.writeln("\t+ ------------------------- +");
  stdout.writeln("\t|   E-COMMERCE APPLICATION  |");
  stdout.writeln("\t+ ------------------------- +\n");

  app.init();

  await app.mainMenu();
}

class Product {
  String id;
  String name;
  String company;
  String category;
  double price;
  int stock;

  Product({
    required this.id,
    required this.name,
    required this.company,
    required this.category,
    required this.price,
    required this.stock,
  });

  void increaseStock({required int quantity}) {
    stock += quantity;
  }

  void decreaseStock({required int quantity}) {
    if (stock >= quantity) {
      stock -= quantity;
    } else {
      stdout.writeln("Less Stock is Available.");
    }
  }

  void updatePrice({required double updatedPrice}) {
    price = updatedPrice;
  }

  bool isAvailable() {
    return stock > 0;
  }

  void displayProduct() {
    stdout.writeln("Product ID      : $id");
    stdout.writeln("Product Name    : $name");
    stdout.writeln("Company Name    : $company");
    stdout.writeln("Product Category: $category");
    stdout.writeln("Product Price   : $price");
    stdout.writeln("Product Stock   : $stock");
  }
}

class Customer {
  String username;
  String name;
  String email;
  String password;
  bool isLogIn;

  Customer({
    required this.name,
    required this.username,
    required this.email,
    required this.password,
    this.isLogIn = false,
  });

  JsonDatabase customerDatabase = JsonDatabase(
    filePath: "JSON FILES/customers.json",
  );

  bool registerCustomer() {
    stdout.writeln("\t========== REGISTER CUSTOMER ==========\n");

    stdout.write("Enter the Name of the Customer:");
    String Name = stdin.readLineSync().toString();

    stdout.write("Enter the Username of the Customer:");
    String Username = stdin.readLineSync().toString();

    stdout.write("Enter the Email of the Customer:");
    String Email = stdin.readLineSync().toString();

    stdout.write("Enter the Password of the Customer:");
    String Password = stdin.readLineSync().toString();

    List<dynamic> customerData = customerDatabase.loadData();

    for (var c in customerData) {
      if (c["email"].toString() == Email) {
        stdout.writeln("This Email is Already Registered!");
        return false;
      }

      if (c["username"].toString() == Username) {
        stdout.writeln("This Username is Already Taken!");
        return false;
      }
    }

    customerData.add({
      "name": Name,
      "email": Email,
      "password": Password,
      "username": Username,
    });

    customerDatabase.saveData(customerData);

    stdout.writeln("Registertion Done Successfully!");
    stdout.writeln("Welcome, $Name");

    return true;
  }

  Future<bool> loginCustomer() async {
    stdout.write("Enter Your Username:");
    String Name = stdin.readLineSync().toString();

    stdout.write("Enter Your Password:");
    String Password = stdin.readLineSync().toString();

    await Future.delayed(Duration(seconds: 3));

    List<dynamic> customerData = customerDatabase.loadData();

    for (var c in customerData) {
      if (c["username"].toLowerCase() == Name.toLowerCase() &&
          c["password"] == Password) {
        isLogIn = true;

        name = c["name"];
        username = c["username"];
        email = c["email"];
        password = c["password"];

        return true;
      }
    }

    return false;
  }

  void logoutCustomer() {
    isLogIn = false;
    stdout.writeln("Customer Logged Out Successfully!");
  }
}

class OrderItem {
  Product product;
  int quantity;

  OrderItem({required this.product, required this.quantity});

  double get totalPrice {
    return product.price * quantity;
  }

  void displayOrderItem() {
    stdout.writeln("Product Name    :${product.name}");
    stdout.writeln("Product Price   :${product.price}");
    stdout.writeln("Product Quantity:$quantity");
    stdout.writeln("Total           :$totalPrice");
  }
}

class Cart {
  List<OrderItem> items;

  Cart({required this.items});

  void addItem(OrderItem order) {
    if (order.quantity <= 0) {
      stdout.writeln("Invalid Quantity!");
      return;
    }

    if (order.quantity > order.product.stock) {
      stdout.writeln("Only ${order.product.stock} items are Available!");
      return;
    }

    for (var p in items) {
      if (p.product.id.toLowerCase() == order.product.id.toLowerCase()) {
        int newQuantity = p.quantity + order.quantity;

        if (newQuantity <= order.product.stock) {
          p.quantity = newQuantity;
          stdout.writeln("Product Quantity Updated in Cart!");
        } else {
          stdout.writeln("Not Enough Stock Available!");
        }

        return;
      }
    }

    items.add(order);
    stdout.writeln("Product Added to Cart Successfully!");
  }

  bool removeItem({required String productId}) {
    for (var item in items) {
      if (item.product.id.toLowerCase() == productId.toLowerCase()) {
        items.remove(item);
        stdout.writeln("Product Removed from Cart Successfully!\n");
        return true;
      }
    }
    stdout.writeln("Product Not Found in Cart!\n");
    return false;
  }

  bool updateQuantity({required String productId, required int newQuantity}) {
    for (var item in items) {
      if (item.product.id.toLowerCase() == productId.toLowerCase()) {
        if (newQuantity > 0) {
          if (newQuantity <= item.product.stock) {
            item.quantity = newQuantity;
            return true;
          }
          return false;
        }
        return false;
      }
    }

    return false;
  }

  double getTotalPrice() {
    double total = 0;

    for (var item in items) {
      total += item.totalPrice;
    }

    return total;
  }

  void displayCart() {
    if (items.isEmpty) {
      stdout.writeln("No Product Added in Cart Yet.");
      return;
    }

    for (var item in items) {
      stdout.writeln("Product ID         :${item.product.id}");
      stdout.writeln("Product Name       :${item.product.name}");
      stdout.writeln("Product Company    :${item.product.company}");
      stdout.writeln("Product Quantity   :${item.quantity}");
      stdout.writeln("Product Total Price:${item.totalPrice}");
      stdout.writeln("---------------------------------\n");
    }
    stdout.writeln("Cart Total: ${getTotalPrice()}");
  }
}

class Wishlist {
  List<Product> products;

  Wishlist({required this.products});

  void addProduct(Product product) {
    for (var p in products) {
      if (p.id.toLowerCase() == product.id.toLowerCase()) {
        stdout.writeln("Product is Already in Wishlist!");
        return;
      }
    }

    products.add(product);
    stdout.writeln("${product.name} Added to Wishlist!");
  }

  void removeProduct({required String productId}) {
    int oldLength = products.length;

    products.removeWhere(
      (product) => product.id.toLowerCase() == productId.toLowerCase(),
    );

    if (products.length < oldLength) {
      stdout.writeln("Product Removed from Wishlist!");
    } else {
      stdout.writeln("Product Not Found in Wishlist!");
    }
  }

  void displayWishlist() {
    if (products.isEmpty) {
      stdout.writeln("Wishlist is Empty!");
      return;
    }

    stdout.writeln("\t========== MY WISHLIST ==========\n");

    for (var product in products) {
      product.displayProduct();
      stdout.writeln("--------------------------------");
    }
  }
}

class Order {
  int orderId;
  Customer customer;
  List<OrderItem> items;
  DateTime orderDateTime;
  String status;

  Order({
    required this.customer,
    required this.items,
    required this.status,
    DateTime? orderDateTime,
  }) : orderId = generateOrderId(),
       orderDateTime = orderDateTime ?? DateTime.now();

  double calculateTotal() {
    double total = 0.0;

    if (items.isEmpty) {
      return total;
    }

    for (var item in items) {
      total += item.totalPrice;
    }

    return total;
  }

  static int generateOrderId() {
    Random random = Random();
    int id = 100000 + random.nextInt(900000);
    return id;
  }

  void displayOrder() {
    stdout.writeln("Order ID:$orderId");
    stdout.writeln("Customer Name:${customer.name}");
    stdout.writeln("Order of Date & Time:$orderDateTime");
    stdout.writeln("Order Status:$status");
    for (var item in items) {
      stdout.writeln("Product Name    :${item.product.name}");
      stdout.writeln("Product Price   :${item.product.price}");
      stdout.writeln("Product Quantity:${item.quantity}");
      stdout.writeln("Total Product   :${item.totalPrice}");
      stdout.writeln("---------------------------\n");
    }
    stdout.writeln("Grand Total       :${calculateTotal()}");
    stdout.writeln("=================================\n");
  }

  bool cancelOrder() {
    if (status.toLowerCase() == "pending" ||
        status.toLowerCase() == "confirmed") {
      status = "Cancelled";
      stdout.writeln("Order Cancelled Successfully!");
      return true;
    }

    stdout.writeln("Order cannot Cancel!");
    return false;
  }

  bool updateStatus() {
    if (status.toLowerCase() == "cancelled") {
      stdout.writeln("Cancelled Order Cannot Be Updated!");
      return false;
    }

    stdout.write("Enter the Updated Status of the Order: ");

    String updatedStatus = stdin.readLineSync().toString().toLowerCase();

    while (updatedStatus != "pending" &&
        updatedStatus != "confirmed" &&
        updatedStatus != "shipped" &&
        updatedStatus != "delivered") {
      stdout.write("Invalid Input! Enter the Updated Status Again: ");

      updatedStatus = stdin.readLineSync().toString().toLowerCase();
    }

    String currentStatus = status.toLowerCase();

    if (currentStatus == "pending" && updatedStatus == "confirmed") {
      status = "confirmed";
      stdout.writeln("Status Updated Successfully!");
      return true;
    }

    if (currentStatus == "confirmed" && updatedStatus == "shipped") {
      status = "shipped";
      stdout.writeln("Status Updated Successfully!");
      return true;
    }

    if (currentStatus == "shipped" && updatedStatus == "delivered") {
      status = "delivered";
      stdout.writeln("Status Updated Successfully!");
      return true;
    }

    stdout.writeln("Invalid Status Transition! Status cannot move backward.");

    return false;
  }
}

class JsonDatabase {
  String filePath;

  JsonDatabase({required this.filePath});

  List<dynamic> loadData() {
    File file = File(filePath);

    if (!file.existsSync()) {
      file.createSync(recursive: true);
      file.writeAsStringSync("[]");
      return [];
    }

    String jsonData = file.readAsStringSync().trim();

    if (jsonData.isEmpty) {
      file.writeAsStringSync("[]");
      return [];
    }

    return jsonDecode(jsonData);
  }

  void saveData(List<dynamic> data) {
    File file = File(filePath);
    String jsonData = jsonEncode(data);
    file.writeAsStringSync(jsonData);
  }
}

class ECommerce {
  List<Product> products = [];
  List<Order> orders = [];

  Customer? currentCustomer;

  Cart cart = Cart(items: []);
  Wishlist wishlist = Wishlist(products: []);

  JsonDatabase productDB;
  JsonDatabase orderDB;
  JsonDatabase wishlistDB;
  JsonDatabase cartDB;

  ECommerce()
    : productDB = JsonDatabase(filePath: "JSON FILES/products.json"),
      orderDB = JsonDatabase(filePath: "JSON FILES/orders.json"),
      wishlistDB = JsonDatabase(filePath: "JSON FILES/wishlists.json"),
      cartDB = JsonDatabase(filePath: "JSON FILES/carts.json");
  void init() {
    loadProducts();
    loadOrders();
  }

  void loadCart() {
    List<dynamic> data = cartDB.loadData();

    cart.items.clear();

    if (currentCustomer == null) {
      return;
    }

    for (var c in data) {
      if (c["username"].toString().toLowerCase() ==
          currentCustomer!.username.toLowerCase()) {
        Product? product = findProduct(c["productId"].toString());

        if (product != null) {
          cart.items.add(
            OrderItem(
              product: product,
              quantity: (c["quantity"] as num).toInt(),
            ),
          );
        }
      }
    }
  }

  void saveCart() {
    if (currentCustomer == null) {
      return;
    }

    List<dynamic> data = cartDB.loadData();

    data.removeWhere(
      (item) =>
          item["username"].toString().toLowerCase() ==
          currentCustomer!.username.toLowerCase(),
    );

    for (var item in cart.items) {
      data.add({
        "username": currentCustomer!.username,
        "productId": item.product.id,
        "quantity": item.quantity,
      });
    }

    cartDB.saveData(data);
  }

  void loadProducts() {
    List<dynamic> data = productDB.loadData();

    products.clear();

    for (var p in data) {
      products.add(
        Product(
          id: p["id"].toString(),
          name: p["name"].toString(),
          company: p["company"].toString(),
          category: p["category"].toString(),
          price: (p["price"] as num).toDouble(),
          stock: (p["stock"] as num).toInt(),
        ),
      );
    }
  }

  void saveProducts() {
    List<dynamic> data = [];

    for (var product in products) {
      data.add({
        "id": product.id,
        "name": product.name,
        "company": product.company,
        "category": product.category,
        "price": product.price,
        "stock": product.stock,
      });
    }

    productDB.saveData(data);
  }

  Product? findProduct(String productId) {
    for (var product in products) {
      if (product.id.toLowerCase() == productId.toLowerCase()) {
        return product;
      }
    }

    return null;
  }

  void displayAllProducts() {
    if (products.isEmpty) {
      stdout.writeln("No Products Available!");
      return;
    }

    stdout.writeln("\t========== ALL PRODUCTS ==========\n");

    for (var product in products) {
      product.displayProduct();
      stdout.writeln("--------------------------------");
    }
  }

  void addProduct() {
    stdout.writeln("\t========== ADD PRODUCT ==========\n");

    stdout.write("Enter Product ID: ");
    String id = stdin.readLineSync().toString();

    if (findProduct(id) != null) {
      stdout.writeln("Product ID Already Exists!");
      return;
    }

    stdout.write("Enter Product Name: ");
    String name = stdin.readLineSync().toString();

    stdout.write("Enter Company Name: ");
    String company = stdin.readLineSync().toString();

    stdout.write("Enter Product Category: ");
    String category = stdin.readLineSync().toString();

    stdout.write("Enter Product Price: ");
    double? price = double.tryParse(stdin.readLineSync().toString());

    stdout.write("Enter Product Stock: ");
    int? stock = int.tryParse(stdin.readLineSync().toString());

    if (price == null || price < 0) {
      stdout.writeln("Invalid Price!");
      return;
    }

    if (stock == null || stock < 0) {
      stdout.writeln("Invalid Stock!");
      return;
    }

    Product product = Product(
      id: id,
      name: name,
      company: company,
      category: category,
      price: price,
      stock: stock,
    );

    products.add(product);

    saveProducts();

    stdout.writeln("Product Added Successfully!");
  }

  void updateProductPrice() {
    stdout.writeln("\t========== UPDATE PRICE ==========\n");
    stdout.write("Enter the Category You Want to Update Price: ");
    String category = stdin.readLineSync().toString().trim();

    List<Product> categoryProducts = [];

    for (var product in products) {
      if (product.category.toLowerCase() == category.toLowerCase()) {
        categoryProducts.add(product);
      }
    }

    if (categoryProducts.isEmpty) {
      stdout.writeln("No Products Found in This Category!");
      return;
    }

    displayCategoryProducts(categoryProducts);
    stdout.write("Enter Product ID: ");
    String id = stdin.readLineSync().toString();

    Product? product = findProduct(id);

    if (product == null) {
      stdout.writeln("Product Not Found!");
      return;
    }

    stdout.write("Enter New Price: ");
    double? price = double.tryParse(stdin.readLineSync().toString());

    if (price == null || price < 0) {
      stdout.writeln("Invalid Price!");
      return;
    }

    product.updatePrice(updatedPrice: price);

    saveProducts();

    stdout.writeln("Product Price Updated Successfully!");
  }

  void increaseProductStock() {
    stdout.writeln("\t========== INCREASE STOCK ==========\n");
    stdout.write("Enter the Category You Want to Update Stock: ");
    String category = stdin.readLineSync().toString().trim();

    List<Product> categoryProducts = [];

    for (var product in products) {
      if (product.category.toLowerCase() == category.toLowerCase()) {
        categoryProducts.add(product);
      }
    }

    if (categoryProducts.isEmpty) {
      stdout.writeln("No Products Found in This Category!");
      return;
    }

    displayCategoryProducts(categoryProducts);
    stdout.write("Enter Product ID: ");
    String id = stdin.readLineSync().toString();

    Product? product = findProduct(id);

    if (product == null) {
      stdout.writeln("Product Not Found!");
      return;
    }

    stdout.write("Enter Quantity to Add: ");
    int? quantity = int.tryParse(stdin.readLineSync().toString());

    if (quantity == null || quantity <= 0) {
      stdout.writeln("Invalid Quantity!");
      return;
    }

    product.increaseStock(quantity: quantity);

    saveProducts();

    stdout.writeln("Stock Updated Successfully!");
  }

  void loadOrders() {
    List<dynamic> data = orderDB.loadData();

    orders.clear();

    for (var o in data) {
      Customer customer = Customer(
        name: o["customerName"].toString(),
        username: o["customerUsername"].toString(),
        email: o["customerEmail"].toString(),
        password: "",
      );

      List<OrderItem> orderItems = [];

      for (var item in o["items"]) {
        Product? product = findProduct(item["productId"].toString());

        if (product != null) {
          orderItems.add(
            OrderItem(
              product: product,
              quantity: (item["quantity"] as num).toInt(),
            ),
          );
        }
      }

      Order order = Order(
        customer: customer,
        items: orderItems,
        status: o["status"].toString(),
        orderDateTime: DateTime.parse(o["orderDateTime"].toString()),
      );

      order.orderId = (o["orderId"] as num).toInt();

      orders.add(order);
    }
  }

  void saveOrder(Order order) {
    List<dynamic> data = orderDB.loadData();

    List<dynamic> orderItems = [];

    for (var item in order.items) {
      orderItems.add({
        "productId": item.product.id,
        "productName": item.product.name,
        "price": item.product.price,
        "quantity": item.quantity,
      });
    }

    data.add({
      "orderId": order.orderId,
      "customerUsername": order.customer.username,
      "customerName": order.customer.name,
      "customerEmail": order.customer.email,
      "orderDateTime": order.orderDateTime.toIso8601String(),
      "status": order.status,
      "totalAmount": order.calculateTotal(),
      "items": orderItems,
    });

    orderDB.saveData(data);
  }

  void saveAllOrders() {
    List<dynamic> data = [];

    for (var order in orders) {
      List<dynamic> orderItems = [];

      for (var item in order.items) {
        orderItems.add({
          "productId": item.product.id,
          "productName": item.product.name,
          "price": item.product.price,
          "quantity": item.quantity,
        });
      }

      data.add({
        "orderId": order.orderId,
        "customerUsername": order.customer.username,
        "customerName": order.customer.name,
        "customerEmail": order.customer.email,
        "orderDateTime": order.orderDateTime.toIso8601String(),
        "status": order.status,
        "totalAmount": order.calculateTotal(),
        "items": orderItems,
      });
    }

    orderDB.saveData(data);
  }

  void placeOrder() {
    if (currentCustomer == null) {
      stdout.writeln("Please Login First!");
      return;
    }

    stdout.writeln("\n========== PLACE ORDER ==========\n");

    stdout.write("Enter the Category You Want: ");
    String category = stdin.readLineSync().toString().trim();

    List<Product> categoryProducts = [];

    for (var product in products) {
      if (product.category.toLowerCase() == category.toLowerCase()) {
        categoryProducts.add(product);
      }
    }

    if (categoryProducts.isEmpty) {
      stdout.writeln("No Products Found in This Category!");
      return;
    }

    displayCategoryProducts(categoryProducts);

    addProductToCart(categoryProducts);

    while (true) {
      stdout.write("\nDo you want to add another product? (yes/no): ");

      String another = stdin.readLineSync().toString().toLowerCase();

      if (another != "yes") {
        break;
      }

      stdout.write("\nEnter Category: ");

      category = stdin.readLineSync().toString().trim();

      categoryProducts = [];

      for (var product in products) {
        if (product.category.toLowerCase() == category.toLowerCase()) {
          categoryProducts.add(product);
        }
      }

      if (categoryProducts.isEmpty) {
        stdout.writeln("No Products Found in This Category!");
        continue;
      }

      displayCategoryProducts(categoryProducts);

      addProductToCart(categoryProducts);
    }

    if (cart.items.isEmpty) {
      stdout.writeln("No Product Added to Cart!");
      return;
    }

    stdout.writeln("\t========== YOUR CART ==========");

    cart.displayCart();

    stdout.write("\nDo you want to confirm the order? (yes/no): ");

    String confirm = stdin.readLineSync().toString().toLowerCase();

    if (confirm != "yes") {
      stdout.writeln("Order Not Placed.");
      return;
    }

    for (var item in cart.items) {
      item.product.decreaseStock(quantity: item.quantity);
    }

    saveProducts();

    Order order = Order(
      customer: currentCustomer!,
      items: List.from(cart.items),
      status: "pending",
    );

    orders.add(order);

    saveOrder(order);

    stdout.writeln("\nOrder Placed Successfully!");

    stdout.writeln("Your Order ID: ${order.orderId}");

    stdout.writeln("Total Amount: ${order.calculateTotal()}");

    cart.items.clear();
    saveCart();
  }

  void displayCategoryProducts(List<Product> categoryProducts) {
    stdout.writeln("\t========== AVAILABLE PRODUCTS ==========\n");

    for (var product in categoryProducts) {
      product.displayProduct();

      stdout.writeln(
        "Availability: "
        "${product.isAvailable() ? "Available" : "Out of Stock"}",
      );

      stdout.writeln("--------------------------------");
    }
  }

  void viewProductsByCategory() {
    if (products.isEmpty) {
      stdout.writeln("No Products Available!");
      return;
    }

    stdout.write("Enter the Category You Want to View: ");
    String category = stdin.readLineSync().toString().trim();

    List<Product> categoryProducts = [];

    for (var product in products) {
      if (product.category.toLowerCase() == category.toLowerCase()) {
        categoryProducts.add(product);
      }
    }

    if (categoryProducts.isEmpty) {
      stdout.writeln("No Products Found in This Category!");
      return;
    }

    displayCategoryProducts(categoryProducts);
  }

  void addProductToCart(List<Product> categoryProducts) {
    stdout.write("\nEnter Product ID You Want: ");

    String productId = stdin.readLineSync().toString();

    Product? selectedProduct;

    for (var product in categoryProducts) {
      if (product.id.toLowerCase() == productId.toLowerCase()) {
        selectedProduct = product;
        break;
      }
    }

    if (selectedProduct == null) {
      stdout.writeln("Invalid Product ID!");
      return;
    }

    stdout.write("Enter Quantity: ");

    int? quantity = int.tryParse(stdin.readLineSync().toString());

    if (quantity == null || quantity <= 0) {
      stdout.writeln("Invalid Quantity!");

      wishlist.addProduct(selectedProduct);

      saveWishlist();

      return;
    }

    if (selectedProduct.stock <= 0) {
      stdout.writeln("Product is Out of Stock!");

      wishlist.addProduct(selectedProduct);

      saveWishlist();

      return;
    }

    if (quantity > selectedProduct.stock) {
      stdout.writeln(
        "Only ${selectedProduct.stock} "
        "Items are Available!",
      );

      return;
    }

    OrderItem orderItem = OrderItem(
      product: selectedProduct,
      quantity: quantity,
    );

    cart.addItem(orderItem);

    saveCart();
  }

  void updateCartQuantity() {
    if (currentCustomer == null) {
      stdout.writeln("Please Login First!");
      return;
    }

    if (cart.items.isEmpty) {
      stdout.writeln("Cart is Empty!");
      return;
    }

    stdout.write("Enter Product ID: ");
    String productId = stdin.readLineSync().toString();

    stdout.write("Enter New Quantity: ");
    int? quantity = int.tryParse(stdin.readLineSync().toString());

    if (quantity == null || quantity <= 0) {
      stdout.writeln("Invalid Quantity!");
      return;
    }

    bool updated = cart.updateQuantity(
      productId: productId,
      newQuantity: quantity,
    );

    if (updated) {
      saveCart();
      stdout.writeln("Cart Quantity Updated Successfully!");
    } else {
      stdout.writeln("Unable to Update Quantity! Check Product ID or Stock.");
    }
  }

  void removeFromCart() {
    if (currentCustomer == null) {
      stdout.writeln("Please Login First!");
      return;
    }

    if (cart.items.isEmpty) {
      stdout.writeln("Cart is Empty!");
      return;
    }

    stdout.write("Enter Product ID to Remove: ");
    String productId = stdin.readLineSync().toString();

    bool removed = cart.removeItem(productId: productId);

    if (removed) {
      saveCart();
    }
  }

  void displayCustomerOrders() {
    if (currentCustomer == null) {
      stdout.writeln("Please Login First!");
      return;
    }

    bool found = false;

    stdout.writeln("\t========== MY ORDERS ==========\n");

    for (var order in orders) {
      if (order.customer.username.toLowerCase() ==
          currentCustomer!.username.toLowerCase()) {
        order.displayOrder();
        found = true;
      }
    }

    if (!found) {
      stdout.writeln("You Have No Orders!");
    }
  }

  void cancelCustomerOrder() {
    if (currentCustomer == null) {
      stdout.writeln("Please Login First!");
      return;
    }
    stdout.writeln("\t------- CANCEL ORDER -------\n");
    displayCustomerOrders();
    stdout.write("Enter Order ID to Cancel: ");

    int? id = int.tryParse(stdin.readLineSync().toString());

    if (id == null) {
      stdout.writeln("Invalid Order ID!");
      return;
    }

    for (var order in orders) {
      if (order.orderId == id &&
          order.customer.username.toLowerCase() ==
              currentCustomer!.username.toLowerCase()) {
        if (order.cancelOrder()) {
          for (var item in order.items) {
            item.product.increaseStock(quantity: item.quantity);
          }

          saveProducts();
          saveAllOrders();
        }

        return;
      }
    }

    stdout.writeln("Order Not Found!");
  }

  void loadWishlist() {
    List<dynamic> data = wishlistDB.loadData();

    wishlist.products.clear();

    if (currentCustomer == null) {
      return;
    }

    for (var w in data) {
      if (w["username"].toString().toLowerCase() ==
          currentCustomer!.username.toLowerCase()) {
        Product? product = findProduct(w["productId"].toString());

        if (product != null) {
          wishlist.products.add(product);
        }
      }
    }
  }

  void saveWishlist() {
    if (currentCustomer == null) {
      return;
    }

    List<dynamic> data = wishlistDB.loadData();

    data.removeWhere(
      (item) =>
          item["username"].toString().toLowerCase() ==
          currentCustomer!.username.toLowerCase(),
    );

    for (var product in wishlist.products) {
      data.add({
        "username": currentCustomer!.username,
        "productId": product.id,
        "productName": product.name,
      });
    }

    wishlistDB.saveData(data);
  }

  void displayWishlist() {
    if (currentCustomer == null) {
      stdout.writeln("Please Login First!");
      return;
    }

    loadWishlist();

    wishlist.displayWishlist();
  }

  void removeFromWishlist() {
    if (currentCustomer == null) {
      stdout.writeln("Please Login First!");
      return;
    }

    loadWishlist();

    if (wishlist.products.isEmpty) {
      stdout.writeln("Wishlist is Empty!");
      return;
    }
    displayWishlist();
    stdout.write("Enter Product ID to Remove: ");

    String id = stdin.readLineSync().toString();

    wishlist.removeProduct(productId: id);

    saveWishlist();
  }

  void trackOrder() {
    if (currentCustomer == null) {
      stdout.writeln("Please Login First!");
      return;
    }
    displayCustomerOrders();
    stdout.write("Enter Order ID to Track: ");

    int? id = int.tryParse(stdin.readLineSync().toString());

    if (id == null) {
      stdout.writeln("Invalid Order ID!");
      return;
    }

    for (var order in orders) {
      if (order.orderId == id &&
          order.customer.username.toLowerCase() ==
              currentCustomer!.username.toLowerCase()) {
        stdout.writeln("\t========== ORDER TRACKING ==========\n");

        stdout.writeln("Order ID       : ${order.orderId}");
        stdout.writeln("Order Date     : ${order.orderDateTime}");
        stdout.writeln("Order Status   : ${order.status}");
        stdout.writeln("Customer Name  : ${order.customer.name}");
        stdout.writeln("Total Amount   : ${order.calculateTotal()}");

        stdout.writeln("\t---------- ORDER PROGRESS ----------");

        if (order.status.toLowerCase() == "pending") {
          stdout.writeln("✓ Order Placed");
          stdout.writeln("→ Pending");
          stdout.writeln("○ Confirmed");
          stdout.writeln("○ Shipped");
          stdout.writeln("○ Delivered");
        } else if (order.status.toLowerCase() == "confirmed") {
          stdout.writeln("✓ Order Placed");
          stdout.writeln("✓ Confirmed");
          stdout.writeln("→ Shipped");
          stdout.writeln("○ Delivered");
        } else if (order.status.toLowerCase() == "shipped") {
          stdout.writeln("✓ Order Placed");
          stdout.writeln("✓ Confirmed");
          stdout.writeln("✓ Shipped");
          stdout.writeln("→ Delivered");
        } else if (order.status.toLowerCase() == "delivered") {
          stdout.writeln("✓ Order Placed");
          stdout.writeln("✓ Confirmed");
          stdout.writeln("✓ Shipped");
          stdout.writeln("✓ Delivered");
        } else if (order.status.toLowerCase() == "cancelled") {
          stdout.writeln("✓ Order Placed");
          stdout.writeln("✗ Order Cancelled");
        }

        stdout.writeln("\n====================================\n");

        return;
      }
    }

    stdout.writeln("Order Not Found!");
  }

  void adminLogin() {
    stdout.writeln("\t========== ADMIN LOGIN ==========\n");

    stdout.write("Enter Admin Username: ");

    String username = stdin.readLineSync().toString();

    stdout.write("Enter Admin Password: ");

    String password = stdin.readLineSync().toString();

    if (username == "yumna" && password == "yumna123") {
      stdout.writeln("Admin Login Successful!");

      adminMenu();
    } else {
      stdout.writeln("Invalid Admin Credentials!");
    }
  }

  void adminMenu() {
    while (true) {
      stdout.writeln("\t========== ADMIN MENU ==========\n");

      stdout.writeln("1. Add Product");
      stdout.writeln("2. View Products");
      stdout.writeln("3. Update Product Price");
      stdout.writeln("4. Increase Product Stock");
      stdout.writeln("5. View All Orders");
      stdout.writeln("6. Update Order Status");
      stdout.writeln("7. Logout");

      stdout.write("\nEnter Your Choice: ");

      String choice = stdin.readLineSync().toString();

      switch (choice) {
        case "1":
          addProduct();
          break;

        case "2":
          displayAllProducts();
          break;

        case "3":
          updateProductPrice();
          break;

        case "4":
          increaseProductStock();
          break;

        case "5":
          displayAllOrders();
          break;

        case "6":
          updateOrderStatus();
          break;

        case "7":
          stdout.writeln("Admin Logged Out!");
          return;

        default:
          stdout.writeln("Invalid Choice!");
      }
    }
  }

  void displayAllOrders() {
    if (orders.isEmpty) {
      stdout.writeln("No Orders Available!");
      return;
    }

    stdout.writeln("\t========== ALL ORDERS ==========\n");

    for (var order in orders) {
      order.displayOrder();
    }
  }

  void updateOrderStatus() {
    stdout.write("Enter Order ID: ");

    int? id = int.tryParse(stdin.readLineSync().toString());

    if (id == null) {
      stdout.writeln("Invalid Order ID!");
      return;
    }

    for (var order in orders) {
      if (order.orderId == id) {
        if (order.updateStatus()) {
          saveAllOrders();
        }

        return;
      }
    }

    stdout.writeln("Order Not Found!");
  }

  Future<void> customerMenu() async {
    while (true) {
      stdout.writeln("\t========== CUSTOMER MENU ==========\n");

      stdout.writeln("1. Register");
      stdout.writeln("2. Login");
      stdout.writeln("3. View All Products");
      stdout.writeln("4. View Products by Category");
      stdout.writeln("5. Place Order");
      stdout.writeln("6. View Cart");
      stdout.writeln("7. Update Cart Quantity");
      stdout.writeln("8. Remove from Cart");
      stdout.writeln("9. View Wishlist");
      stdout.writeln("10. Remove from Wishlist");
      stdout.writeln("11. View My Orders");
      stdout.writeln("12. Cancel Order");
      stdout.writeln("13. Track Order");
      stdout.writeln("14. Logout.");

      stdout.write("\nEnter Your Choice: ");

      String choice = stdin.readLineSync().toString();

      switch (choice) {
        case "1":
          Customer customer = Customer(
            name: "",
            username: "",
            email: "",
            password: "",
          );

          customer.registerCustomer();
          break;

        case "2":
          Customer customer = Customer(
            name: "",
            username: "",
            email: "",
            password: "",
          );

          bool login = await customer.loginCustomer();

          if (login) {
            currentCustomer = customer;

            loadWishlist();
            loadCart();

            stdout.writeln("\nWelcome ${currentCustomer!.name}!");
          } else {
            stdout.writeln("Invalid Username or Password!");
          }

          break;

        case "3":
          displayAllProducts();
          break;

        case "4":
          viewProductsByCategory();
          break;

        case "5":
          if (currentCustomer == null) {
            stdout.writeln("Please Login First!");
          } else {
            placeOrder();
          }
          break;

        case "6":
          if (currentCustomer == null) {
            stdout.writeln("Please Login First!");
          } else {
            cart.displayCart();
          }
          break;

        case "7":
          updateCartQuantity();
          break;

        case "8":
          removeFromCart();
          break;

        case "9":
          displayWishlist();
          break;

        case "10":
          removeFromWishlist();
          break;

        case "11":
          displayCustomerOrders();
          break;

        case "12":
          cancelCustomerOrder();
          break;

        case "13":
          trackOrder();
          break;
        case "14":
          if (currentCustomer != null) {
            saveCart();

            currentCustomer!.logoutCustomer();
            currentCustomer = null;
          }

          cart.items.clear();
          wishlist.products.clear();

          return;
        default:
          stdout.writeln("Invalid Choice!");
      }
    }
  }

  Future<void> mainMenu() async {
    while (true) {
      stdout.writeln("\t========== E-COMMERCE ==========\n");

      stdout.writeln("1. Admin");
      stdout.writeln("2. Customer");
      stdout.writeln("3. Exit");

      stdout.write("\nEnter Your Choice: ");

      String choice = stdin.readLineSync().toString();

      switch (choice) {
        case "1":
          adminLogin();
          break;

        case "2":
          await customerMenu();
          break;

        case "3":
          stdout.writeln("\nThank You for Using E-Commerce!");
          return;

        default:
          stdout.writeln("Invalid Choice!");
      }
    }
  }
}
