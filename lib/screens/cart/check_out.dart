import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopa/Provider/cart_provider.dart';
import 'package:shopa/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopa/screens/Profile/user_auth_page.dart';

class CheckOutBox extends StatefulWidget {
  const CheckOutBox({super.key});

  @override
  State<CheckOutBox> createState() => _CheckOutBoxState();
}

class _CheckOutBoxState extends State<CheckOutBox> {
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  double discountAmount = 0.0;
  bool isCashSelected = true;
  String? userAddress;

  Future<void> _checkOut() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final address = prefs.getString('address');

    if (username == null || address == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UserAuthPage()),
      );
    } else {
      setState(() {
        userAddress = address;
      });
      _showPaymentDialog();
    }
  }

  void _showPaymentDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Ödeme Yöntemi Seçin"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Radio<bool>(
                  value: true,
                  groupValue: isCashSelected,
                  onChanged: (value) {
                    setState(() {
                      isCashSelected = value!;
                    });
                    Navigator.pop(context);
                    _showPaymentDialog();
                  },
                ),
                title: const Text("Nakit"),
              ),
              ListTile(
                leading: Radio<bool>(
                  value: false,
                  groupValue: isCashSelected,
                  onChanged: (value) {
                    setState(() {
                      isCashSelected = value!;
                    });
                    Navigator.pop(context);
                    _showPaymentDialog();
                  },
                ),
                title: const Text("Kart"),
              ),
              if (!isCashSelected)
                Column(
                  children: [
                    TextField(
                      controller: _cardNumberController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Kart Numarası",
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _expiryDateController,
                      keyboardType: TextInputType.datetime,
                      decoration: const InputDecoration(
                        labelText: "Son Kullanma Tarihi (YY/AA)",
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _cvvController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "CVV",
                      ),
                    ),
                  ],
                ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: kprimaryColor),
              onPressed: () {
                if (isCashSelected) {
                  Navigator.pop(context);
                  _finalizeOrder();
                } else {
                  if (_cardNumberController.text.isNotEmpty &&
                      _expiryDateController.text.isNotEmpty &&
                      _cvvController.text.isNotEmpty) {
                    Navigator.pop(context);
                    _finalizeOrder();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Lütfen kart bilgilerini doldurun!"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text("Siparişi Onayla"),
            ),
          ],
        );
      },
    );
  }

  void _finalizeOrder() {
    final provider = Provider.of<CartProvider>(context,
        listen: false); // listen: false eklendi
    provider.clearCart(); // Sepeti temizle
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Siparişiniz onaylandı!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CartProvider>(context);

    return ValueListenableBuilder(
      valueListenable: provider.cartNotifier,
      builder: (context, cart, _) {
        final double totalPrice = provider.totalPrice();
        final double tax = totalPrice * 0.05;
        final double finalPrice = totalPrice + tax - discountAmount;

        return Container(
          height: 300,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: _discountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: kcontentColor,
                  hintText: "İndirim Kodu",
                  suffixIcon: TextButton(
                    onPressed: () {
                      setState(() {
                        discountAmount =
                            double.tryParse(_discountController.text) ?? 0.0;
                      });
                    },
                    child: const Text(
                      "Uygula",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: kprimaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Vergi (%5)", style: TextStyle(fontSize: 16)),
                  Text("₺${tax.toStringAsFixed(2)}"),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Toplam", style: TextStyle(fontSize: 18)),
                  Text("₺${finalPrice.toStringAsFixed(2)}"),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kprimaryColor,
                  minimumSize: const Size(double.infinity, 55),
                ),
                onPressed: _checkOut,
                child: const Text(
                  "Kontrol Et",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
