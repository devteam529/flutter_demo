import 'package:flutter/material.dart';

class EmptyOrdersWidget extends StatefulWidget {
  const EmptyOrdersWidget({
    Key? key,
  }) : super(key: key);

  @override
  _EmptyOrdersWidgetState createState() => _EmptyOrdersWidgetState();
}

class _EmptyOrdersWidgetState extends State<EmptyOrdersWidget> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 120,
            height: 120,
            padding: const EdgeInsets.all(35),
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white
              ),
            child: Image.asset('assets/img/icon_empty_order.png', height: 50, width: 50,),
          ),
          const SizedBox(height: 30),
          Opacity(
            opacity: 0.5,
            child: Text(
             "No Products Available",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Color(int.parse("0xFF313131"))),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
