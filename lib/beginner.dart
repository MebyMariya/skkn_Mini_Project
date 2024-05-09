import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove debug banner
      home: BeginnerPage(),
    );
  }
}

class BeginnerPage extends StatefulWidget {
  @override
  _BeginnerPageState createState() => _BeginnerPageState();
}

class _BeginnerPageState extends State<BeginnerPage> {
  late List<List<dynamic>> csvData;
  late Map<String, List<String>> dataFromTxt;

  @override
  void initState() {
    super.initState();
    loadCSV();
    loadDataFromTxt();
  }

  Future<void> loadCSV() async {
    final String rawCSV = await rootBundle.loadString('assets/product.csv');
    csvData = CsvToListConverter().convert(rawCSV);
    setState(() {}); // Refresh the UI after loading CSV data
  }

  Future<void> loadDataFromTxt() async {
    final String rawTxt = await rootBundle.loadString('assets/data.txt');
    List<String> lines = rawTxt.split('\n');
    dataFromTxt = {};
    for (String line in lines) {
      List<String> parts = line.split(',');
      if (parts.length >= 2) {
        String productType = parts[0];
        String data = parts[1];
        if (!dataFromTxt.containsKey(productType)) {
          dataFromTxt[productType] = [];
        }
        dataFromTxt[productType]?.add(data.trim());
      }
    }
    setState(() {}); // Refresh the UI after loading data from txt
  }

  List<String>? getDataForProductType(String productType) {
    return dataFromTxt[productType];
  }

  List<Product> getProductsWithPriceForType(String productType) {
    List<Product> products = [];
    for (var row in csvData) {
      if (row.length >= 7 && row[6] == productType) { // Assuming product_type is in the 7th column
        products.add(Product(name: row[1], price: row[5])); // Assuming product name is in the 2nd column and price in the 6th column
      }
    }
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beginner Page'),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/beginner.jpg'), // Your background image
              fit: BoxFit.fill,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HeadingWithBox(
                  title: 'Cleanser',
                  products: getProductsWithPriceForType('Cleanser'),
                ),
                HeadingWithBox(
                  title: 'Moisturizer',
                  products: getProductsWithPriceForType('Moisturizer'),
                ),
                HeadingWithBox(
                  title: 'Sunscreen',
                  products: getProductsWithPriceForType('Sunscreen'),
                ),
                HeadingWithBox(
                  title: 'Lip Balm',
                  products: getProductsWithPriceForType('Lip Balm'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HeadingWithBox extends StatelessWidget {
  final String title;
  final List<Product>? products;

  const HeadingWithBox({Key? key, required this.title, this.products})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 87, 59, 41),
          ),
        ),
        SizedBox(height: 10),
        Container(
          width: 300, // Take full available width
          height: 160, // Reduced height
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 223, 190, 147), // Brown color
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal, // Horizontal scrolling
            child: Row(
              children: [
                SizedBox(width: 10), // Left padding for better appearance
                if (products != null && products!.isNotEmpty)
                  for (Product product in products!)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          Text(product.name),
                          Text('\$${product.price}'), // Displaying price
                        ],
                      ),
                    ),
                if (products == null || products!.isEmpty)
                  Center(
                    child: Text('No data available'),
                  ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

class Product {
  final String name;
  final String price;

  Product({required this.name, required this.price});
}
