import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icons_broken.dart';

Widget defaultButton({
  required Function() function,
  required String text,
  double width = double.infinity,
  Color background = defaultColor,
  bool isUpperCase = true,
  double radius = 15,
}) =>
    Container(
      width: width,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: background,
      ),
      child: MaterialButton(
        onPressed: function,
        child: Text(isUpperCase ? text.toUpperCase() : text,
            style: const TextStyle(color: Colors.white)),
      ),
    );

Widget defaultFormField({
  required String label,
  required IconData prefix,
  IconData? suffix,
  TextInputType inputType = TextInputType.emailAddress,
  required TextEditingController controller,
  required String? Function(String?) validate,
  Function(String?)? onSubmit,
  Function(String?)? onChange,
  Function()? onSuffixPress,
  bool isPassword = false,
}) =>
    TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(prefix),
        suffixIcon: suffix == null
            ? null
            : IconButton(
                onPressed: onSuffixPress,
                icon: Icon(suffix),
              ),
      ),
      keyboardType: inputType,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      validator: validate,
      controller: controller,
      obscureText: isPassword ? true : false,
    );

PreferredSizeWidget? defaultAppBar({
  required BuildContext context,
  String? title,
  List<Widget>? actions,
}) {
  return AppBar(
    title: Text('$title'),
    leading: IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: const Icon(IconBroken.Arrow___Left_2),
    ),
    actions: actions,
  );
}

Future<bool?> showToast({
  required String msg,
  required ToastStates state,
}) {
  return Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: chooseToastColor(state),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}
