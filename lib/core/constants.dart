import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const kScaffoldBgColor = Color.fromARGB(255, 207, 228, 255);
const kSplashBgColor = Colors.deepPurpleAccent;

const kButtonStyle =
    TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white);

const kAppbarTitleStyle = TextStyle(
  color: Colors.white,
  fontSize: 24,
  fontWeight: FontWeight.w600,
);

const kLeadingIcon = Icon(Icons.arrow_back_ios_new,size: 30,);

const kHeight10 = SizedBox(
  height: 10,
);
const kHeight20 = SizedBox(
  height: 20,
);
const kHeight50 = SizedBox(
  height: 50,
);
const kWidth10 = SizedBox(
  width: 10,
);

const dividerstyle = Divider(
  color: Colors.grey,
  thickness: 1,
  indent: 50,
  endIndent: 50,
);

String parseDate(DateTime displayDate) {
  return DateFormat.yMMMd('en_US').format(displayDate);
}

Widget displayTextField(controller, keyboardType, hintText) {
  return TextFormField(
    onTap: () {
      FocusManager.instance.primaryFocus?.unfocus();
    },
    controller: controller,
    keyboardType: keyboardType,
    decoration:
        InputDecoration(border: const OutlineInputBorder(), hintText: hintText),
  );
}

ageValidation(BuildContext context, age) {
  int ageValid = int.parse(age);
  if (ageValid <= 0 || ageValid > 150) {
    showSnackBarMsg(context, Colors.redAccent, "Please enter a valid age");
    return;
  }
}

nameValidation(BuildContext context, name) {
  RegExp regex = RegExp(r'^[a-zA-Z ]+$');
  if (!regex.hasMatch(name)) {
    showSnackBarMsg(context, Colors.redAccent, "Please enter a valid name");
    return;
  }
}

showSnackBarMsg(BuildContext context, color, text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: color,
      margin: const EdgeInsets.all(20),
      behavior: SnackBarBehavior.floating,
      content: Text(text),
      duration: const Duration(seconds: 2),
    ),
  );
}
