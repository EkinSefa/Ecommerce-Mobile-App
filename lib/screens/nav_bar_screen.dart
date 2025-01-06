import 'package:flutter/material.dart';
import 'package:shopa/Provider/favorite_provider.dart';
import 'package:shopa/constants.dart';
import 'package:shopa/screens/Profile/profile.dart';
import 'package:shopa/screens/StoreScreen/store_screen.dart';

import 'package:shopa/screens/cart/cart_screen.dart';
import 'package:shopa/screens/home/home_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _ButtomNavBarState();
}

class _ButtomNavBarState extends State<BottomNavBar> {
  int cuttentIndex = 2;
  List<Widget> screens = [
    const StoreScreen(), // Burada widget'ların örneğini oluşturmalıyız
    const Favorite(),
    const HomeScreen(),
    const CartScreen(),
    const Profile()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            cuttentIndex = 2;
          });
        },
        shape: const CircleBorder(),
        backgroundColor: Colors.blue.shade400,
        child: const Icon(
          Icons.home,
          color: Colors.white,
          size: 35,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        elevation: 1,
        height: 60,
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  cuttentIndex = 0;
                });
              },
              icon: Icon(
                Icons.grid_view_outlined,
                size: 30,
                color: cuttentIndex == 0 ? kprimaryColor : Colors.grey.shade400,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  cuttentIndex = 1;
                });
              },
              icon: Icon(
                Icons.favorite_border,
                size: 30,
                color:
                    cuttentIndex == 1 ? kprimaryColorr : Colors.grey.shade400,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  cuttentIndex = 3;
                });
              },
              icon: Icon(
                Icons.shopping_cart_outlined,
                size: 30,
                color: cuttentIndex == 3 ? kprimaryColor : Colors.grey.shade400,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  cuttentIndex = 4;
                });
              },
              icon: Icon(
                Icons.person,
                size: 30,
                color: cuttentIndex == 4 ? kprimaryColor : Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
      body: screens[
          cuttentIndex], // Burada artık widget'ları doğru şekilde çağırıyoruz
    );
  }
}
