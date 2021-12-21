import 'package:flutter/material.dart';
import 'package:flutter_assignment_demo/src/controllers/add_product_controller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class AddProductWidget extends StatefulWidget {
  final bool isEdit;
  final int isIndex;

  const AddProductWidget({Key? key, required this.isEdit, required this.isIndex}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AddProductWidgetState();
  }
}

class _AddProductWidgetState extends StateMVC<AddProductWidget> {

  late AddProductController _con;

  _AddProductWidgetState():super(AddProductController()){
    _con = controller as AddProductController;
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.isEdit) {
      _con.getProductData(widget.isIndex);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() => _con.screenSize = _con.screenWidth(context: context));
    return Scaffold(
      backgroundColor: Color(int.parse("0xFFF8F8F8")),
      appBar: AppBar(
        leading:  IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => {
            Navigator.of(context).pop(),
          },
        ),
        centerTitle: true,
        title: Text(
          widget.isEdit ? 'Edit Product' : 'Add Product',
          style: TextStyle(
            color:  Color(int.parse("0xFF313131")),
          ),
        ),
        backgroundColor: Color(int.parse("0xFFF8F8F8")),
        elevation: 1,
      ),
      body: Container(
        padding: _con.screenSize >= 600
            ? EdgeInsets.symmetric(vertical: 30.0, horizontal: MediaQuery.of(context).size.width * 0.30)
            : const EdgeInsets.symmetric(vertical: 30.0, horizontal: 25.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              TextFormField(
                controller: _con.nameController,
                onChanged: (value) {},
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 0.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 0.0),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Visibility(
                    visible: _con.isAlreadyAdded,
                    child: const Text("This product was already added.", style: TextStyle(color: Colors.red),)),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: TextFormField(
                  controller: _con.launchedAtController,
                  enabled: true,
                  autofocus: false,
                  focusNode: AlwaysDisabledFocusNode(),
                  onChanged: (value) {},
                  onTap: () {
                    _con.selectDate(context);
                  },
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Please select date';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Launched At',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 0.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 0.0),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: TextFormField(
                  controller: _con.launchSiteController,
                  onChanged: (value) {},
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Please enter launch site';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Launch Site',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 0.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 0.0),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 25),
                child: Text("Popularity", style: TextStyle(color: Colors.black)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: RatingBar.builder(
                  initialRating: _con.ratingCount,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.orangeAccent,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _con.ratingCount = rating;
                    });
                  },
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color(int.parse("0xFFF83941"))),
                        foregroundColor: MaterialStateProperty.all<Color>(Color(int.parse("0xFFF83941"))),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                          side: BorderSide(color: Color(int.parse("0xFFF83941"))),
                          borderRadius: BorderRadius.circular(10.0),
                        ))),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (widget.isEdit) {
                          _con.updateProduct(context, widget.isIndex);
                        } else {
                          _con.saveProduct(context);
                        }
                      }
                    },
                    child: const Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      child: Text("Save", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}