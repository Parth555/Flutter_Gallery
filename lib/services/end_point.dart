import '../utils/debug.dart';

abstract class EndPoint {
  static const liveURL = "https://pixabay.com/api/";
  static const localURL = "https://pixabay.com/api/";

  static getBaseURL() {
    if (Debug.sandboxApiUrl) {
      return localURL;
    } else {
      return liveURL;
    }
  }
}
