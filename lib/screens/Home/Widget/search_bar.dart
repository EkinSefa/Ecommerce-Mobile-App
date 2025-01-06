import 'package:flutter/material.dart';
import 'package:shopa/constants.dart';

class MySearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onSearch;

  const MySearchBar({
    super.key,
    required this.searchController,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: double.infinity,
      decoration: BoxDecoration(
        color: kcontentColor,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            color: Colors.grey,
            size: 30,
          ),
          const SizedBox(width: 10),
          Flexible(
            flex: 4,
            child: TextField(
              controller: searchController,
              onChanged: onSearch, // Kullanıcı yazdıkça filtreleme yapılacak
              decoration: const InputDecoration(
                hintText: 'Ara...',
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
