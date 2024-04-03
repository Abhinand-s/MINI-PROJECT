import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: MyApp3(),
  ));
}

class MyApp3 extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp3> {
  List<dynamic>? products;
  String? error;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('https://script.googleusercontent.com/macros/echo?user_content_key=_-7dxhV1bbVQXtVMCbFkUtVUpULFH44YBaUn6TD6IDXMjUzjr27b_eylycinqmciEhmMCQHVJjozz7iBnhNytHQSp4dinPktm5_BxDlH2jW0nuo2oDemN9CCS2h10ox_1xSncGQajx_ryfhECjZEnI1_lnPFjiSV1zVoo_7LYjPtSc1FZT39MYuTA6f8xyP3BOBg7UI7NjFadGuNEE45OXJCTYbifGe2AWigKL7XlqbnALLbsPxArNz9Jw9Md8uu&lib=MHz23z-TMgFoxTvOK86nMo9J0M_K-0Qm3'));

      if (response.statusCode == 200) {
        setState(() {
          products = jsonDecode(response.body)['data'];
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
        title: Text('Product List'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!))
              : ListView.builder(
                  itemCount: products!.length-1,
                  itemBuilder: (context, index) {
                    index++;
                    return ListTile(
                      leading: Image.network(products?[index]['image link']),
                      title: Text(products?[index]['product name']),
                      subtitle: Text('Actual Price: ${products?[index]['actual price']}\nDiscount Price: ${products?[index]['discount price']}'),
                      trailing: IconButton(
                        icon: Icon(Icons.link),
                        onPressed: () {
                          // Add your logic to open the product link
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
