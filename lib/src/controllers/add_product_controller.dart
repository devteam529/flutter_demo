import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_assignment_demo/src/models/product.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddProductController extends ControllerMVC {
  List<Product> product = <Product>[];
  late SharedPreferences sharedPreferences;
  bool isEmpty = true;
  late double ratingCount = 0;
  double screenSize = 0;
  bool isAlreadyAdded= false;

  final nameController = TextEditingController();
  final launchedAtController = TextEditingController();
  final launchSiteController = TextEditingController();

  AddProductController();

  void getProductData(int isIndex) async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      if (sharedPreferences.getString('product') != null) {
        var productJson = sharedPreferences.getString('product');
        List data = await json.decode(productJson!);
        data.asMap().forEach((index, jsonData) {
          if (isIndex == index) {
            setState(() {
              nameController.text = jsonData['name'];
              launchedAtController.text = jsonData['launchedAt'];
              launchSiteController.text = jsonData['launchSite'];
              ratingCount = jsonData['popularity'];
            });
          }
        });
      }
    } catch (exception) {
      debugPrint(exception.toString());
    }
  }

  void saveProduct(BuildContext context) async {
    List<dynamic> insertList = [];
    sharedPreferences = await SharedPreferences.getInstance();

    if (sharedPreferences.getString('product') != null) {
      var productJson = sharedPreferences.getString('product');

      var data = await json.decode(productJson!);

      for(int i=0;i<data.length; i++){
        if(data[i]['name'].toLowerCase()==nameController.text.toLowerCase()){
          isAlreadyAdded= true;
          setState(() {
          });
          break;

        }else{
          Product levelModel = Product(data[i]['name'], data[i]['launchedAt'], data[i]['launchSite'], data[i]['popularity']);
          insertList.add(json.encode(levelModel.toMap()));
          isAlreadyAdded= false;
          setState(() {
          });
        }
      }
    }

    if(!isAlreadyAdded){

      Product productModel = Product(nameController.text, launchedAtController.text, launchSiteController.text, ratingCount);
      insertList.add(json.encode(productModel.toMap()));
      setState(() {
      });
      sharedPreferences.setString('product', insertList.toString()).then((value) {
        Navigator.pop(context, "update");
      });
    }
  }

  void updateProduct(BuildContext context, int isIndex) async {
    List<dynamic> insertList = [];
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString('product') != null) {
      var productJson = sharedPreferences.getString('product');
      await json.decode(productJson!).asMap().forEach((index, jsondata) {
        if (isIndex == index) {
          Product productModel = Product(nameController.text, launchedAtController.text, launchSiteController.text, ratingCount);
          insertList.insert(isIndex, json.encode(productModel.toMap()));
        } else {
          Product levelModel = Product(jsondata['name'], jsondata['launchedAt'], jsondata['launchSite'], jsondata['popularity']);
          insertList.add(json.encode(levelModel.toMap()));
        }
      });
    }

    sharedPreferences.setString('product', insertList.toString()).then((value) {
      Navigator.pop(context, "update");
    });
  }

  void selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        String formattedDate = DateFormat('dd-MM-yyyy').format(picked);
        launchedAtController.text = formattedDate;
      });
    }
  }

  double screenWidth({required BuildContext context}) {
    return MediaQuery.of(context).size.width;
  }

}