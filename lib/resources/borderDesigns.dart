import 'package:flutter/material.dart';
import 'package:user_management/resources/colors.dart';

mixin BorderDesign {
  OutlineInputBorder inputdecBorderStyle(borderRadius) {
    return OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.black,
      ),
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }

  OutlineInputBorder inputdecEnableborderStyle(borderRadius) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: darkGreyColor,
      ),
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }

  OutlineInputBorder inputdecFocusedborderStyle(borderRadius) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: primaryColor,
      ),
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }
  OutlineInputBorder inputdec_borderStyle(inputBorderRadius) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(inputBorderRadius),
    );
  }

  OutlineInputBorder inputdec_enableborderStyle(inputBorderRadius) {
    return OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.grey,
      ),
      borderRadius: BorderRadius.circular(inputBorderRadius),
    );
  }

  OutlineInputBorder outerLineColor(inputBorderRadius) {
    return OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.red),
      borderRadius: BorderRadius.circular(inputBorderRadius),
    );
  }


}