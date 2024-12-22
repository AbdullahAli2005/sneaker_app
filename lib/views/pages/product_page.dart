import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:sneaker_app/controllers/product_provider.dart';
import 'package:sneaker_app/views/shared/app_style.dart';

import '../../controllers/favorites_provider.dart';
import '../../models/constants.dart';
import '../../models/sneakers_model.dart';
import '../shared/checkout_btn.dart';
import 'favorites.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key, required this.id, required this.category});

  final String id;
  final String category;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final PageController pageController = PageController();
  final _cartBox = Hive.box("cart_box");
  // final _favBox = Hive.box("fav_box");

  Future<void> _createCart(Map<String, dynamic> newCart) async {
    await _cartBox.add(newCart);
  }

  @override
  Widget build(BuildContext context) {
    var productNotifier = Provider.of<ProductNotifier>(context);
    productNotifier.getShoes(widget.category, widget.id);

    var favouritesNotifier =
        Provider.of<FavouritesNotifier>(context, listen: true);
    favouritesNotifier.getFavourites();

    return Scaffold(
      body: FutureBuilder<Sneakers>(
        future: productNotifier.sneaker,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text("ERROR: $snapshot.error");
          } else {
            final sneaker = snapshot.data;
            return Consumer<ProductNotifier>(
              builder: (context, productNotifier, child) {
                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      leadingWidth: 0,
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                productNotifier.shoeSizes.clear();
                              },
                              child: const Icon(
                                AntDesign.close,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      pinned: true,
                      snap: false,
                      floating: true,
                      backgroundColor: Colors.transparent,
                      expandedHeight: MediaQuery.of(context).size.height,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.39,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.grey.shade300,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: CachedNetworkImage(
                                  imageUrl: sneaker!
                                      .imageUrl[0], // Show the first image only
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Positioned(
                              top: MediaQuery.of(context).size.height * 0.06,
                              right: 16,
                              child: Consumer<FavouritesNotifier>(
                                builder: (context, favouritesNotifier, child) {
                                  return GestureDetector(
                                    onTap: () async {
                                      if (favouritesNotifier.ids
                                          .contains(sneaker.id)) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Favourites()),
                                        );
                                      } else {
                                        await favouritesNotifier.createFav({
                                          "id": sneaker.id,
                                          "name": sneaker.name,
                                          "category": sneaker.category,
                                          "price": sneaker.price,
                                          "imageUrl": sneaker.imageUrl[0],
                                        });
                                        setState(() {
                                          ids.add(sneaker
                                              .id); // Update the state to include the new favorite
                                        });
                                      }
                                    },
                                    child: favouritesNotifier.ids
                                            .contains(sneaker.id)
                                        ? const Icon(AntDesign.heart)
                                        : const Icon(AntDesign.hearto),
                                  );
                                },
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              left: 0,
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4),
                                    child: CircleAvatar(
                                      radius: 5,
                                      backgroundColor: Colors
                                          .black, // Highlight the current indicator
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 30,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.62,
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            sneaker.name,
                                            style: appStyle(34, Colors.black,
                                                FontWeight.bold),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                sneaker.category,
                                                style: appStyle(20, Colors.grey,
                                                    FontWeight.w500),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              RatingBar.builder(
                                                initialRating: 4,
                                                minRating: 1,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemSize: 22,
                                                itemPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 1),
                                                itemBuilder: (context, _) =>
                                                    const Icon(
                                                  Icons.star,
                                                  size: 18,
                                                  color: Colors.black,
                                                ),
                                                onRatingUpdate: (rating) {},
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 18,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "\$${sneaker.price}",
                                                style: appStyle(
                                                    26,
                                                    Colors.black,
                                                    FontWeight.w600),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Colors",
                                                    style: appStyle(
                                                        18,
                                                        Colors.black,
                                                        FontWeight.w500),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  const CircleAvatar(
                                                    radius: 7,
                                                    backgroundColor:
                                                        Colors.black,
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  const CircleAvatar(
                                                    radius: 7,
                                                    backgroundColor:
                                                        Colors.grey,
                                                  ),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Column(
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "Select sizes",
                                                    style: appStyle(
                                                        20,
                                                        Colors.black,
                                                        FontWeight.w700),
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  Text(
                                                    "View size guide",
                                                    style: appStyle(
                                                        16,
                                                        Colors.grey,
                                                        FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              SizedBox(
                                                height: 50,
                                                child: ListView.builder(
                                                  itemCount: productNotifier
                                                      .shoeSizes.length,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  padding: EdgeInsets.zero,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final sizes =
                                                        productNotifier
                                                            .shoeSizes[index];
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8),
                                                      child: ChoiceChip(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(60),
                                                          side:
                                                              const BorderSide(
                                                            color: Colors.black,
                                                            width: 1,
                                                            style: BorderStyle
                                                                .solid,
                                                          ),
                                                        ),
                                                        disabledColor:
                                                            Colors.white,
                                                        label: Text(
                                                          sizes["size"],
                                                          style: appStyle(
                                                              18,
                                                              sizes['isSelected']
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                              FontWeight.w600),
                                                        ),
                                                        selectedColor:
                                                            Colors.black,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 8),
                                                        selected:
                                                            sizes["isSelected"],
                                                        onSelected: (newState) {
                                                          if (productNotifier
                                                              .sizes
                                                              .contains(sizes[
                                                                  "size"])) {
                                                            productNotifier
                                                                .sizes
                                                                .remove(sizes[
                                                                    "size"]);
                                                          } else {
                                                            productNotifier
                                                                .sizes
                                                                .add(sizes[
                                                                    "size"]);
                                                          }
                                                          productNotifier
                                                              .toggleCheck(
                                                                  index);
                                                          if (newState) {
                                                            // When size is selected
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                    "${sizes['size']} selected successfully!"),
                                                              ),
                                                            );
                                                          } else {
                                                            // When size is unselected
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                    "${sizes['size']} unselected successfully"),
                                                              ),
                                                            );
                                                          }
                                                        },
                                                        showCheckmark: false,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Divider(
                                            indent: 10,
                                            endIndent: 10,
                                            color: Colors.black,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            child: Text(
                                              sneaker.title,
                                              maxLines: 2,
                                              style: appStyle(24, Colors.black,
                                                  FontWeight.w700),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            sneaker.description,
                                            textAlign: TextAlign.justify,
                                            maxLines: 6,
                                            style: appStyle(16, Colors.black,
                                                FontWeight.normal),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 12),
                                              child: CheckoutButton(
                                                onTap: () async {
                                                  if (productNotifier
                                                      .sizes.isEmpty) {
                                                    // Show SnackBar if no size is selected
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            "Please select a size before adding to cart!"),
                                                      ),
                                                    );
                                                    return; // Stop further execution
                                                  }
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          "Added to cart successfully!"),
                                                    ),
                                                  );
                                                  _createCart(
                                                    {
                                                      "id": sneaker.id,
                                                      "name": sneaker.name,
                                                      "category":
                                                          sneaker.category,
                                                      "sizes":
                                                          productNotifier.sizes,
                                                      "imageUrl":
                                                          sneaker.imageUrl[0],
                                                      "price": sneaker.price,
                                                      "qty": 1
                                                    },
                                                  );
                                                  print(productNotifier.sizes);
                                                  productNotifier.sizes.clear();
                                                  // Navigator.pop(context);
                                                },
                                                label: "Add to Cart",
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 40,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
