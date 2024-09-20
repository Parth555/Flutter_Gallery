import '../widgets/text/common_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// Conditional import of fluttertoast
import 'package:fluttertoast/fluttertoast.dart';

import 'app_color.dart';

class Utils {
  static showToast(BuildContext context, String message) {
    if (!kIsWeb) {
      return Fluttertoast.showToast(
        msg: message,
      );
    }
  }

  static showSnackBar(BuildContext context, String text, {GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey, bool isSuccess = false}) {
    //scaffoldMessengerKey?.currentState!.showSnackBar(snackBar);
    //ScaffoldMessenger.of(context).showSnackBar(snackBar);

    final snackBar = SnackBar(
      backgroundColor: isSuccess ? AppColor.bgGreen : AppColor.bgRed,
      content: CommonText(text: text, textAlign: TextAlign.start, textColor: AppColor.white),
      showCloseIcon: true,
      closeIconColor: AppColor.white,
      /*action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),*/
    );

    ScaffoldMessenger.of(context).showSnackBar(
      snackBar,
    );

    /*showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        barrierColor: AppColor.transparent,
        builder: (builderContext) {
          return Container(
            height: 60,
            color: isSuccess ? AppColor.bgGreen : AppColor.bgRed,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: ,
                ),
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.close,
                      size: 25,
                      color: AppColor.white,
                    ))
              ],
            ),
          );
        });
*/
    //ScaffoldMessenger.of(context).showMaterialBanner(snackBar);
  }

  /*static String getSelectedLanguage() {
    return Preference.shared.getString(Preference.selectedLanguage) ?? Constant.languageEn;
  }

  */ /*static UserData? getUserData() {
    var str = Preference.shared.getString(Preference.userData);
    if(str != null) {
      return UserData.fromJson(jsonDecode(str));
    }
    return null;
  }*/ /*

  static bool isLogin() {
    var accessToken = Preference.shared.getString(Preference.accessToken);
    return (accessToken != null && accessToken.isNotEmpty);
  }*/

  static Future<dynamic> showBottomSheetDialog(BuildContext context, {required Widget child, Color? bgColor}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: bgColor ?? AppColor.primaryBackground,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return child;
      },
    );
  }

  static dismissKeyboard(BuildContext context) {
    return FocusScope.of(context).unfocus();
  }

  static String capitalizeFirstLetter(String str) {
    if (str.isEmpty) {
      return str;
    }
    return str[0].toUpperCase() + str.substring(1);
  }

  static String normalizeContactNumber(String number, {bool includePlus = false}) {
    if (includePlus) {
      return number.replaceAll(RegExp('[^+^0-9]'), '');
    } else {
      return number.replaceAll(RegExp('[^0-9]'), '');
    }
  }
}
