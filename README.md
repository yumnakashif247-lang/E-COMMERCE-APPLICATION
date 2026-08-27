# 🛒 E-Commerce Application

A **console-based E-Commerce Application built with Dart**. It provides an interactive system for customers to browse products, manage their cart and wishlist, place orders, track order status, and cancel eligible orders. The application also includes an **Admin Panel** for managing products, stock, prices, and orders.

## ✨ Features

* 📝 Customer Registration & Login
* 🛍️ View All Products
* 📂 Browse Products by Category
* 🛒 Shopping Cart Management
* ➕ Add Products to Cart
* 🔄 Update Cart Quantity
* 🗑️ Remove Products from Cart
* ❤️ Wishlist Management
* 📦 Order Placement
* 🔢 Random 6-Digit Order ID
* 📍 Order Tracking
* ❌ Order Cancellation
* 🔄 Order Status Updates
* 📉 Automatic Stock Management
* 💾 JSON File Storage

## 👤 Customer Features

* Register a new account
* Login and logout
* View all available products
* View products by category
* Add products to the cart
* Update or remove cart items
* Add products to the wishlist
* View and remove wishlist products
* Place an order
* View personal orders
* Track orders using the Order ID
* Cancel orders with `Pending` or `Confirmed` status

## 👨‍💼 Admin Features

* 🔐 Admin Login
* ➕ Add New Products
* 👀 View All Products
* 💰 Update Product Prices
* 📦 Increase Product Stock
* 📋 View All Customer Orders
* 🔄 Update Order Status

## 📦 Order Status Flow

```text id="ocv3xp"
Pending → Confirmed → Shipped → Delivered
```

Orders can only move **forward** through the status flow.

❌ Backward status changes are not allowed.

Customers can cancel orders only when the status is:

```text id="3j7gvg"
Pending or Confirmed
```

Once an order is **Shipped** or **Delivered**, it cannot be cancelled.

## 📍 Order Tracking

Customers can track their orders using their **Order ID** and view:

* 🆔 Order ID
* 📅 Order Date & Time
* 📦 Current Order Status
* 👤 Customer Name
* 💰 Total Amount
* 📊 Order Progress

Example:

```text id="9j0wpd"
✓ Order Placed
✓ Confirmed
→ Shipped
○ Delivered
```

## 🛠️ Technologies Used

* Dart
* Object-Oriented Programming (OOP)
* Dart IO
* JSON
* File Handling
* Async/Await
* Null Safety

## 🧩 Main Classes

* **Product** — Manages product information, price, and stock.
* **Customer** — Handles registration, login, and logout.
* **OrderItem** — Represents products and quantities inside an order.
* **Cart** — Manages cart items and total price.
* **Wishlist** — Manages saved products.
* **Order** — Handles order details, status, cancellation, and total calculation.
* **JsonDatabase** — Handles loading and saving data using JSON files.
* **ECommerce** — Controls the main application functionality and menus.

## 💾 Data Storage

The application uses JSON files for persistent data storage:

```text id="g5q0dp"
JSON FILES/
│
├── customers.json
├── products.json
├── orders.json
├── carts.json
└── wishlists.json
```

## 📂 Project Structure

```text id="h5nfzm"
E-Commerce-Application/
│
├── bin/
│   └── main.dart
│
├── JSON FILES/
│   ├── customers.json
│   ├── products.json
│   ├── orders.json
│   ├── carts.json
│   └── wishlists.json
│
└── README.md
```

## 🚀 How to Run

1. Clone the repository:

```bash id="ejd44v"
git clone <your-repository-url>
```

2. Open the project folder:

```bash id="u0qwb4"
cd E-Commerce-Application
```

3. Run the application:

```bash id="bcl9s6"
dart run
```

## 🎯 Concepts Practiced

* Classes & Objects
* Constructors
* Encapsulation
* Lists
* Loops
* Conditional Statements
* Switch Statements
* Null Safety
* Static Methods
* Getters
* Async/Await
* Random Number Generation
* DateTime
* File Handling
* JSON Encoding & Decoding
* Input Validation

## 👩‍💻 Author

**Yumna Kashif**

GitHub: https://github.com/yumnakashif247-lang

Repository

🔗 https://github.com/yumnakashif247-lang/E-COMMERCE-APPLICATION

⭐ If you like this project, don't forget to **star the repository**!
