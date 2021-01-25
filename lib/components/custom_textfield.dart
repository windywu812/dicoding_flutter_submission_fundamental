import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constant.dart' as Constant;

class CustomTextfield extends StatelessWidget {
  final Function onTapFunction;
  final Function onChangedFunction;

  const CustomTextfield({Key key, this.onTapFunction, this.onChangedFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      onTap: () {
        onTapFunction();
      },
      onChanged: (text) {
        onChangedFunction(text);
      },
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      prefix: Padding(
        padding: EdgeInsets.only(left: 8, right: 4),
        child: Icon(Icons.search),
      ),
      cursorColor: Constant.primaryColor,
      autocorrect: false,
      placeholder: 'Search Restaurants',
      placeholderStyle: TextStyle(
        fontFamily: 'Futura',
        color: Colors.black.withOpacity(0.5),
      ),
      padding: EdgeInsets.symmetric(vertical: 8),
    );
  }
}
