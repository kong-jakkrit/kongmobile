import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assignment Week 5',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ProductPage(),
    );
  }
}

class Product {
  dynamic id;
  String name;
  int price;

  Product({this.id, required this.name, required this.price});

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        name: json['name'],
        price: json['price'] is int
            ? json['price']
            : int.tryParse(json['price'].toString()) ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
      };
}

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<Product> products = [];
  bool isLoading = true;
  String errorMessage = '';
  final apiUrl = 'http://localhost:3000/products';

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void fetchProducts() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    try {
      var response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        if (!mounted) return;
        setState(() {
          products = jsonList.map((item) => Product.fromJson(item)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Server error: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = "เกิดข้อผิดพลาด: $e";
        isLoading = false;
      });
    }
  }

  void deleteProduct(dynamic id) async {
    try {
      var response = await http.delete(Uri.parse('$apiUrl/$id'));
      if (response.statusCode == 200 || response.statusCode == 204) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('ลบสินค้าเรียบร้อย!')));
        fetchProducts();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error ลบสินค้า: ${response.statusCode}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error ลบสินค้า: $e')));
    }
  }

  void showProductForm({Product? product}) {
    final nameController = TextEditingController(text: product?.name ?? '');
    final priceController =
        TextEditingController(text: product?.price.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product == null ? 'เพิ่มสินค้า' : 'แก้ไขสินค้า'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'ชื่อสินค้า'),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'ราคา'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('ยกเลิก')),
          ElevatedButton(
            onPressed: () async {
              String name = nameController.text.trim();
              int? price = int.tryParse(priceController.text.trim());

              if (name.isEmpty || price == null) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('กรอกข้อมูลไม่ครบ')));
                return;
              }

              Navigator.pop(context);

              if (product == null) {
                try {
                  var response = await http.post(Uri.parse(apiUrl),
                      headers: {'Content-Type': 'application/json'},
                      body: jsonEncode({'name': name, 'price': price}));
                  if (response.statusCode == 201) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('เพิ่มสินค้าเรียบร้อย!')));
                    fetchProducts();
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Error เพิ่มสินค้า: $e')));
                }
              } else {
                try {
                  var response = await http.put(Uri.parse('$apiUrl/${product.id}'),
                      headers: {'Content-Type': 'application/json'},
                      body: jsonEncode({'name': name, 'price': price}));
                  if (response.statusCode == 200) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('แก้ไขสินค้าเรียบร้อย!')));
                    fetchProducts();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error แก้ไขสินค้า: ${response.statusCode}')));
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Error แก้ไขสินค้า: $e')));
                }
              }
            },
            child: const Text('บันทึก'),
          ),
        ],
      ),
    );
  }

  void confirmDelete(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ยืนยันการลบสินค้า?'),
        content: Text('คุณต้องการลบ "${product.name}" หรือไม่?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('ยกเลิก')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteProduct(product.id);
            },
            child: const Text('ลบ', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D47A1), Color(0xFF42A5F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Products',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        FloatingActionButton(
                          heroTag: "add",
                          backgroundColor: Colors.green,
                          onPressed: () => showProductForm(),
                          child: const Icon(Icons.add),
                        ),
                        const SizedBox(width: 12),
                        FloatingActionButton(
                          heroTag: "refresh",
                          backgroundColor: Colors.orange,
                          onPressed: fetchProducts,
                          child: const Icon(Icons.refresh),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : errorMessage.isNotEmpty
                        ? Center(
                            child: Text(
                              errorMessage,
                              style: const TextStyle(color: Colors.white),
                            ),
                          )
                        : ListView.separated(
                            itemCount: products.length,
                            separatorBuilder: (_, __) => const Divider(
                              color: Colors.white30,
                              thickness: 1,
                            ),
                            itemBuilder: (context, index) {
                              final product = products[index];
                              return Card(
                                color: Colors.white.withOpacity(0.9),
                                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                child: ListTile(
                                  title: Text(
                                    product.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    'ราคา: ${product.price}',
                                    style: const TextStyle(color: Colors.green),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.blueAccent),
                                        onPressed: () => showProductForm(product: product),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        color: Colors.red,
                                        onPressed: () => confirmDelete(product),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
