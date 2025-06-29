import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const SerumApp());
}

class SerumApp extends StatelessWidget {
  const SerumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SerumPage(),
    );
  }
}

class SerumPage extends StatelessWidget {
  const SerumPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.pink[50],
        elevation: 0,
        title: const Text('BEAUTY.', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          TextButton(onPressed: () {}, child: const Text('Home', style: TextStyle(color: Colors.black))),
          TextButton(onPressed: () {}, child: const Text('Shop', style: TextStyle(color: Colors.black))),
          TextButton(onPressed: () {}, child: const Text('Contact', style: TextStyle(color: Colors.black))),
          const SizedBox(width: 10),
        ],
      ),
      body: Center(
        child: Container(
          width: width > 1000 ? 900 : double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset('assets/images/5.jpg', width: double.infinity, height: 400, fit: BoxFit.cover),
                const SizedBox(height: 40),
                const Text('Glow like never before!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
                  child: const Text('SHOP NOW'),
                ),
                const SizedBox(height: 40),
                const Text('Featured Product', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                SizedBox(
                  height: 160,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      buildProductCard(context, 'assets/images/2.jpg', 'LUX SHINE'),
                      buildProductCard(context, 'assets/images/3.jpg', 'POUR FEMME'),
                      buildProductCard(context, 'assets/images/4.jpg', 'ROSE TOUCH'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildProductCard(BuildContext context, String imagePath, String title) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(imagePath: imagePath, title: title),
          ),
        );
      },
      child: Container(
        width: 120,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Image.asset(imagePath, height: 80),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('منتج رائع للعناية بالبشرة والجمال الطبيعي.', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class ProductDetailsPage extends StatefulWidget {
  final String imagePath;
  final String title;

  const ProductDetailsPage({super.key, required this.imagePath, required this.title});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String? selectedWilaya;
  String? selectedSize;
  int quantity = 1;
  int deliveryType = 1;

  Future<void> submitToSheet() async {
    const String sheetUrl = 'https://script.google.com/macros/s/AKfycbyhnKbZKvYuZCSteQsQcKYGcVj7LwoWnWoU5Ua8EEIm31gTCBD7K-OVQwq_ztXEmEi6/exec';

    final response = await http.post(
      Uri.parse(sheetUrl),
      body: {
        'name': nameController.text,
        'phone': phoneController.text,
        'wilaya': selectedWilaya ?? '',
        'quantity': quantity.toString(),
        'size': selectedSize ?? '',
        'delivery': deliveryType == 1 ? "إلى العنوان" : "إلى مكتب مخصص",
        'product': widget.title,
      },
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("تم إرسال الطلب"),
          content: const Text("شكراً على طلبك! سيتم التواصل معك قريباً."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // close dialog
                Navigator.of(context).pop(); // go back
              },
              child: const Text("العودة"),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text("فشل في الإرسال"),
          content: Text("حدث خطأ أثناء إرسال البيانات. حاول مرة أخرى."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), backgroundColor: Colors.pinkAccent),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(widget.imagePath, height: 300, width: double.infinity, fit: BoxFit.cover),
              const SizedBox(height: 16),
              Text(widget.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.pink.shade50,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(child: Text("أطلب الآن", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
                    const SizedBox(height: 16),
                    TextField(controller: nameController, decoration: const InputDecoration(labelText: 'الاسم الكامل')),
                    TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'رقم الهاتف')),
                    const SizedBox(height: 8),
                    DropdownButtonFormField(
                      value: selectedWilaya,
                      decoration: const InputDecoration(labelText: 'الولاية'),
                      items: List.generate(58, (index) {
                        int num = index + 1;
                        return DropdownMenuItem(value: num.toString(), child: Text("ولاية $num"));
                      }),
                      onChanged: (value) => setState(() => selectedWilaya = value),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text("الكمية: "),
                        IconButton(icon: const Icon(Icons.remove), onPressed: () => setState(() => quantity = (quantity > 1) ? quantity - 1 : 1)),
                        Text('$quantity'),
                        IconButton(icon: const Icon(Icons.add), onPressed: () => setState(() => quantity++)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField(
                      value: selectedSize,
                      decoration: const InputDecoration(labelText: 'الحجم'),
                      items: const [
                        DropdownMenuItem(value: 'صغير', child: Text('صغير')),
                        DropdownMenuItem(value: 'متوسط', child: Text('متوسط')),
                        DropdownMenuItem(value: 'كبير', child: Text('كبير')),
                      ],
                      onChanged: (value) => setState(() => selectedSize = value),
                    ),
                    const SizedBox(height: 12),
                    const Text("نوع التوصيل:"),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile(
                            title: const Text("إلى العنوان"),
                            value: 1,
                            groupValue: deliveryType,
                            onChanged: (value) => setState(() => deliveryType = value!),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            title: const Text("إلى مكتب مخصص"),
                            value: 2,
                            groupValue: deliveryType,
                            onChanged: (value) => setState(() => deliveryType = value!),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: submitToSheet,
                child: const Text("تأكيد الطلب"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
