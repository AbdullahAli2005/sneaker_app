import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:sneaker_app/views/pages/favorites.dart';
import 'package:sneaker_app/views/shared/app_style.dart';
import '../../controllers/favorites_provider.dart';
import '../../models/constants.dart';

class ProductCard extends StatefulWidget {
  const ProductCard(
      {super.key,
      required this.price,
      required this.category,
      required this.id,
      required this.name,
      required this.image});

  final String price;
  final String category;
  final String id;
  final String name;
  final String image;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  // final _favBox = Hive.box("fav_box");

  @override
  Widget build(BuildContext context) {
    var favouritesNotifier =
        Provider.of<FavouritesNotifier>(context, listen: true);
    favouritesNotifier.getFavourites();

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 20, 0),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width * 0.64,
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
                color: Color.fromARGB(255, 243, 243, 243),
                spreadRadius: 1,
                blurRadius: 0.6,
                offset: Offset(1, 1))
          ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.23,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(widget.image),
                              fit: BoxFit.contain)),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: GestureDetector(
                      onTap: () async {
                        if (favouritesNotifier.ids.contains(widget.id)) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Favourites()),
                          );
                        } else {
                          await favouritesNotifier.createFav({
                            "id": widget.id,
                            "name": widget.name,
                            "category": widget.category,
                            "price": widget.price,
                            "imageUrl": widget.image,
                          });
                          setState(() {
                            ids.add(widget
                                .id); // Update the state to include the new favorite
                          });
                        }
                      },
                      child: favouritesNotifier.ids.contains(widget.id)
                          ? const Icon(AntDesign.heart)
                          : const Icon(AntDesign.hearto),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: appstyleWithHt(
                          36, Colors.black, FontWeight.bold, 1.1),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      widget.category,
                      style:
                          appstyleWithHt(18, Colors.grey, FontWeight.bold, 1.5),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Text(
                  widget.price,
                  style: appStyle(30, Colors.black, FontWeight.w600),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
