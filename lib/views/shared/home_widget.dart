import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:sneaker_app/controllers/product_provider.dart';
import 'package:sneaker_app/views/pages/product_by_cat.dart';
import 'package:sneaker_app/views/pages/product_page.dart';
import 'package:sneaker_app/views/shared/product_card.dart';

import '../../models/sneakers_model.dart';
import 'app_style.dart';
import 'new_shoes.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({
    super.key,
    required Future<List<Sneakers>> male,
    required this.tabIndexNo,
  }) : _male = male;

  final Future<List<Sneakers>> _male;
  final int tabIndexNo;

  @override
  Widget build(BuildContext context) {
    var productNotifier = Provider.of<ProductNotifier>(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.46,
            child: FutureBuilder<List<Sneakers>>(
              future: _male,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(
                    color: Colors.white,
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text("ERROR: $snapshot.error"),);
                } else {
                  final male = snapshot.data;
                  return ListView.builder(
                    itemCount: male!.length,
                    // vertical
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final shoe = snapshot.data![index];
                      return GestureDetector(
                        onTap: () {
                          productNotifier.shoeSizes = shoe.sizes;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductPage(
                                id: shoe.id,
                                category: shoe.category,
                              ),
                            ),
                          );
                        },
                        child: ProductCard(
                            price: "\$${shoe.price}",
                            category: shoe.category,
                            id: shoe.id,
                            name: shoe.name,
                            image: shoe.imageUrl[0]),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 20, 12, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Latest Shoes",
                      style: appStyle(
                        24,
                        Colors.black,
                        FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductByCategory(
                              tabIndex: tabIndexNo,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            "Show All",
                            style: appStyle(
                              22,
                              Colors.black,
                              FontWeight.w500,
                            ),
                          ),
                          const Icon(
                            AntDesign.caretright,
                            size: 20,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
            height: MediaQuery.of(context).size.height * 0.14,
            child: FutureBuilder<List<Sneakers>>(
              future: _male,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("ERROR: $snapshot.error");
                } else {
                  final male = snapshot.data;
                  return ListView.builder(
                    // vertical
                    itemCount: male!.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final shoe = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: NewShoes(imageUrl: shoe.imageUrl[1]),
                      );
                    },
                  );
                }
              },
            ),
          ),
            ],
          ),
          // close
          
        ],
      ),
    );
  }
}
