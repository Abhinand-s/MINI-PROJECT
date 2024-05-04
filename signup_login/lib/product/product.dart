import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: CategoryList1(),
  ));
}

class CategoryList1 extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList1> {
  Map<String, List<dynamic>>? categoryProducts;
  String? error;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('https://script.google.com/macros/s/AKfycbxdJjr_oafwhp7WONPr4n9SQfMnC1UdBRFcrSkqihrVdKuWyoVQKCe5Tp6z5txvp-jddw/exec'));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];
        setState(() {
          categoryProducts = {};
          for (var item in data) {
            String category = item['category'].toString();
            if (!categoryProducts!.containsKey(category)) {
              categoryProducts![category] = [];
            }
            categoryProducts![category]!.add(item);
          }
          error = null;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print(e);
      setState(() {
        error = 'Failed to load data';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Categories'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!))
              : ListView.builder(
                  itemCount: categoryProducts!.keys.length,
                  itemBuilder: (context, index) {
                    String category = categoryProducts!.keys.elementAt(index);
                    return Card(
                      elevation: 5,
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        tileColor: Colors.blue[50],
                        title: Text(category, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ProductList(products: categoryProducts![category]!)),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}

class ProductList extends StatelessWidget {
  final List<dynamic> products;

  ProductList({required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            margin: EdgeInsets.all(8),
            child: ListTile(
              leading: Image.network(products[index]['image link']),
              title: Text(products[index]['product name'], style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductDetails(product: products[index])),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ProductDetails extends StatelessWidget {
  final dynamic product;

  ProductDetails({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['product name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.network(product['image link']),
            SizedBox(height: 10),
            Text('Product Name: ${product['product name']}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Actual Price: ${product['actual price']}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Discount Price: ${product['discount price']}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Description: ${product['Description']}', style: TextStyle(fontSize: 16)), // Assuming 'description' is a key in your product data
            SizedBox(height: 20),
       ElevatedButton(
  child: Text('Buy Now'),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LinkPage(url: product['product link'])),  // Assuming 'product link' is a key in your product data
    );
  },
),


          ],
        ),
      ),
    );
  }
}


class LinkPage extends StatelessWidget {
  final String url;

  LinkPage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Link'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              url,
              style: TextStyle(fontSize: 20),
            ),
            ElevatedButton(
              child: Text('Copy Link'),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: url));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Copied to clipboard')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


