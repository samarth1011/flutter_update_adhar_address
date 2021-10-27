import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_update_adhar_address/resources/colors/ui_palette.dart';
import 'package:flutter_update_adhar_address/resources/values/dimens.dart';

void showSimpleMessageSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}

Future<void> showSimpleAlertDialog(BuildContext context,
    {required String title, required String description}) async {
  await showDialog(
    context: context,
    builder: (context) {
      return SimpleDialog(
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: UiPalette.textDarkShade(1),
            fontWeight: FontWeight.bold,
          ),
        ),
        children: [
          Text(
            description,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: UiPalette.textDarkShade(5),
            ),
          ),
        ],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            Dimens.buttonCornerRadius,
          ),
        ),
      );
    },
  );
}
