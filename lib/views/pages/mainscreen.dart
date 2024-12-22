import 'package:flutter/material.dart';
import 'package:sneaker_app/views/pages/cart_page.dart';
import 'package:sneaker_app/views/pages/home_page.dart';
import 'package:sneaker_app/views/pages/profile_page.dart';

// SERVICES
import '../../controllers/mainscreen_provider.dart';
import 'package:provider/provider.dart';

// PAGES
import '../shared/bottom_nav.dart';

import 'favorites.dart';

class MainScreen extends StatelessWidget {
  final String userEmail;

  const MainScreen({super.key, required this.userEmail});

  List<Widget> pageList(String userEmail) {
    return [
      const HomePage(),
      const Favourites(),
      const CartPage(),
      ProfilePage(userEmail: userEmail),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainScreenNotifier>(
      builder: (context, mainScreenNotifier, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFE2E2E2),
          body: pageList(userEmail)[mainScreenNotifier.pageIndex],
          bottomNavigationBar: const BottomNav(),
        );
      },
    );
  }
}
