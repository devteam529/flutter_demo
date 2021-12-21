import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignment_demo/src/controllers/home_controller.dart';
import 'package:flutter_assignment_demo/src/elements/EmptyProductsWidget.dart';
import 'package:flutter_assignment_demo/src/elements/product_item.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import 'add_product.dart';

class HomeWidget extends StatefulWidget {

  const HomeWidget({Key? key}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends StateMVC<HomeWidget> {
  late HomeController _con;

  _HomeWidgetState():super(HomeController()){
    _con = controller as HomeController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(int.parse("0xFFF8F8F8")),
      appBar: AppBar(
        centerTitle: true,
        title:  Center(
          child: Text(
            'Flutter Assignment ',
            style: TextStyle(
              color: Color(int.parse("0xFF313131")),
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Color(int.parse("0xFF313131")),
            ),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddProductWidget(
                      isEdit: false,
                      isIndex: 0,
                    )),
              );
              if (result == "update") {
                _con.getSavedProduct();
              }
            },
          )
        ],
        elevation: 1,
        backgroundColor: Color(int.parse("0xFFF8F8F8")),
        bottom: PreferredSize(
            child: Container(
              color: Color(int.parse("0xFF454545")).withOpacity(0.2),
              height: 0.5,
            ),
            preferredSize: const Size.fromHeight(4.0)),
      ),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            return Container(
              margin: const EdgeInsets.all(8),
              width: _con.screenWidth(context: context),
              child: _con.isEmpty
                  ? const EmptyOrdersWidget()
                  : Column(
                children: [
                  Visibility(
                    visible: _con.screenWidth(context: context) >= 600 && kIsWeb == true ? true : false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _con.layout = 'list';
                            });
                          },
                          icon: Icon(
                            Icons.format_list_bulleted,
                            color: _con.layout == 'list' ? Colors.black : Theme.of(context).focusColor,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {_con.layout = 'grid';
                            });
                          },
                          icon: Icon(
                            Icons.apps,
                            color: _con.layout == 'grid' ? Colors.black : Theme.of(context).focusColor,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: (_con.screenWidth(context: context) >= 600)
                            ? _con.layout == "grid"
                            ? 3
                            : 1
                            : 1,
                        childAspectRatio: (_con.screenWidth(context: context) >= 600)
                            ? _con.layout == "grid"
                            ? _con.screenWidth(context: context) / (_con.screenHeight(context: context) / 2)
                            : _con.screenWidth(context: context) / (_con.screenHeight(context: context) / 6)
                            : _con.screenWidth(context: context) / (_con.screenHeight(context: context) / 6),
                      ),
                      itemCount: _con.product.length,
                      itemBuilder: (_, index) {
                        return ProductItem(
                          productModel: _con.product[index],
                          onDeleteClick: (value) {
                            _con.showAlertDialog(context, index);
                          },
                          onEditClick: (value) async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddProductWidget(
                                    isEdit: true,
                                    isIndex: index,
                                  )),
                            );
                            if (result == "update") {
                             _con.getSavedProduct();
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}