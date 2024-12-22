import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:sneaker_app/views/shared/app_style.dart';
import 'package:sneaker_app/views/shared/category_button.dart';

import '../../controllers/product_provider.dart';
import '../shared/custom_spacer.dart';
import '../shared/latest_shoes.dart';

class ProductByCategory extends StatefulWidget {
  const ProductByCategory({super.key, required this.tabIndex});

  final int tabIndex;

  @override
  State<ProductByCategory> createState() => _ProductByCategoryState();
}

class _ProductByCategoryState extends State<ProductByCategory>
    with TickerProviderStateMixin {
  late TabController _tabController;
  double value = 100; // Move value here for persistent state

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.animateTo(widget.tabIndex, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<String> brand = [
    "assets/images/adidas.png",
    "assets/images/nike.png",
    "assets/images/gucci.png",
    "assets/images/jordan.png",
  ];

  @override
  Widget build(BuildContext context) {
    var productNotifier = Provider.of<ProductNotifier>(context);
    productNotifier.getMale();
    productNotifier.getFemale();
    productNotifier.getkids();
    return Scaffold(
      backgroundColor: const Color(0xFFE2E2E2),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 45, 0, 0),
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/top_image.png"),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(6, 12, 16, 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            AntDesign.close,
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            filter();
                          },
                          child: const Icon(
                            FontAwesome.sliders,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TabBar(
                    dividerColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: Colors.transparent,
                    controller: _tabController,
                    isScrollable: true,
                    labelColor: Colors.white,
                    labelStyle: appStyle(24, Colors.white, FontWeight.bold),
                    unselectedLabelColor: Colors.grey.withOpacity(0.3),
                    tabs: const [
                      Tab(
                        text: "Men Shoes",
                      ),
                      Tab(
                        text: "Women Shoes",
                      ),
                      Tab(
                        text: "Kids Shoes",
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.235,
                left: 16,
                right: 12,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    LatestShoes(male: productNotifier.male),
                    LatestShoes(male: productNotifier.female),
                    LatestShoes(male: productNotifier.kids),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> filter() {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.white54,
    builder: (context) {
      double modalValue = value; // Local value scoped to modal
      
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter modalSetState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.84,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    height: 5,
                    width: 40,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.black38,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Filter",
                    style: appStyle(40, Colors.black, FontWeight.bold),
                  ),
                  const CustomSpacer(),
                  Text(
                    "Gender",
                    style: appStyle(20, Colors.black, FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CategoryBtn(buttonClr: Colors.black, label: "Men"),
                      CategoryBtn(buttonClr: Colors.grey, label: "Women"),
                      CategoryBtn(buttonClr: Colors.grey, label: "Kids"),
                    ],
                  ),
                  const CustomSpacer(),
                  Text(
                    "Category",
                    style: appStyle(20, Colors.black, FontWeight.w600),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CategoryBtn(label: "Shoes", buttonClr: Colors.black),
                      CategoryBtn(label: "Apparel", buttonClr: Colors.grey),
                      CategoryBtn(label: "Sports", buttonClr: Colors.grey),
                    ],
                  ),
                  const CustomSpacer(),
                  Text(
                    "Price",
                    style: appStyle(20, Colors.black, FontWeight.bold),
                  ),
                  const CustomSpacer(),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '\$${modalValue.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Slider(
                          value: modalValue,
                          activeColor: Colors.black,
                          inactiveColor: Colors.grey,
                          thumbColor: Colors.black,
                          max: 500,
                          label: modalValue.round().toString(),
                          onChanged: (double newValue) {
                            modalSetState(() {
                              modalValue = newValue; // Update locally in modal
                            });

                            // Update global value as well
                            setState(() {
                              value = newValue;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const CustomSpacer(),
                  Text(
                    "Brand",
                    style: appStyle(20, Colors.black, FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(8),
                    height: 80,
                    child: ListView.builder(
                      itemCount: brand.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            height: 60,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            child: Image.asset(
                              brand[index],
                              height: 60,
                              width: 80,
                              color: Colors.black,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

}
