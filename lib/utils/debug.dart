import 'dart:developer';

class Debug {
  static const debug = true;
  static const sandboxApiUrl = true;
  static const sandboxVerifyReceiptUrl = true;

  static printLog(String str) {
    if (debug) log(str);
  }

  static printLoge(String str, String msg) {
    if (debug) log(str,error: msg);
  }
}
