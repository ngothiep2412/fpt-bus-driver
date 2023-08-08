import 'package:fbus_app_driver/src/core/const/colors.dart';
import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  final String hintText;
  final EdgeInsets padding;
  final TextEditingController textController;
  final TextInputType textInputType;

  CustomTextInput({
    required this.hintText,
    this.padding = const EdgeInsets.only(left: 40),
    required this.textController,
    required this.textInputType,
    required Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: ShapeDecoration(
        color: AppColor.textColor,
        shape: StadiumBorder(),
        shadows: [
          BoxShadow(
            color: AppColor.busdetailColor.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: textController,
        keyboardType: textInputType,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: AppColor.text1Color,
          ),
          contentPadding: padding,
        ),
      ),
    );
  }
}
