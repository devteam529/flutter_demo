import 'package:flutter/material.dart';
import 'package:flutter_assignment_demo/src/models/product.dart';

import 'star_rating.dart';

class ProductItem extends StatelessWidget {
  final Product productModel;
  final ValueChanged<Product> onEditClick;
  final ValueChanged<Product> onDeleteClick;

  const ProductItem({
    required this.productModel,
    required this.onEditClick,
    required this.onDeleteClick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0.1,
            blurRadius: 1,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric( horizontal: 8, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(
                  productModel.name,
                  style:  TextStyle(color: Color(int.parse("0xFF313131")), fontWeight: FontWeight.bold, fontSize: 18),
                )),
                SizedBox.fromSize(
                  size: const Size(35, 35), // button width and height
                  child: ClipOval(
                    child: Material(
                      color: Colors.green, // button color
                      child: GestureDetector(
                        key: UniqueKey(),
                        behavior: HitTestBehavior.opaque,
                        onTap: () => onEditClick(productModel),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              Icons.edit,
                              color: Colors.white,
                            ), // icon
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: SizedBox.fromSize(
                    size: const Size(35, 35), // button width and height
                    child: ClipOval(
                      child: Material(
                        color: Colors.red, // button color
                        child: GestureDetector(
                          key: UniqueKey(),
                          behavior: HitTestBehavior.opaque,
                          onTap: () => onDeleteClick(productModel),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Icon(
                                Icons.delete,
                                color: Colors.white,
                              ), // icon
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Expanded(
                child: Text(
              productModel.launchedAt,
              style: TextStyle(color: Color(int.parse("0xFF313131"))),
            )),
            StarRating(
              rating: productModel.popularity,
              onRatingChanged: (rating) {
                productModel.popularity = rating;
              },
              color: Colors.orangeAccent,
            )
          ],
        ),
      ),
    );
  }
}
