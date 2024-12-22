import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sneaker_app/controllers/mainscreen_provider.dart';
import 'package:sneaker_app/controllers/product_provider.dart';
import 'package:sneaker_app/views/pages/cart_page.dart';
import 'package:sneaker_app/views/pages/favorites.dart';
import 'package:sneaker_app/views/pages/login_signup_page.dart';
import 'package:sneaker_app/views/pages/splash_screen.dart';

// PAGES
import '../views/pages/mainscreen.dart';
import 'controllers/cart_provider.dart';
import 'controllers/favorites_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await Hive.initFlutter();
  await Hive.openBox("cart_box");
  await Hive.openBox("fav_box");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MainScreenNotifier()),
        ChangeNotifierProvider(create: (context) => ProductNotifier()),
        ChangeNotifierProvider(create: (context) => FavouritesNotifier()),
        ChangeNotifierProvider(create: (context) => CartProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {
            '/main': (context) => const MainScreen(userEmail: 'example@example.com'),
            '/favorites': (context) => const Favourites(),
            '/cart': (context) => const CartPage(),
            '/login': (context) => const LoginSignupScreen(),
            '/splash': (context) => const SplashScreen(),
          },
          initialRoute: '/splash',
        );
      },
    );
  }
}
