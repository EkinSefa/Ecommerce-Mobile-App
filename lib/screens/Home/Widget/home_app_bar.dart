import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blue, // Arka plan rengi mavi
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center, // Yazıyı ortalar
      child: const Text(
        "LUI Alışveriş",
        style: TextStyle(
          color: Colors.white, // Yazı rengi beyaz
          fontSize: 18, // Yazı boyutu
          fontWeight: FontWeight.bold, // Kalın yazı
        ),
      ),
    );
  }
}
