import 'dart:convert';

import 'package:fluttergallery/utils/constant.dart';
import 'package:get/get.dart';

import '../../../models/image_data_model.dart';
import '../../../services/dio_client.dart';

class HomePageLogic extends GetxController {
  var isLoading = true.obs;
  var isLoadingMore = false.obs;
  var imageList = <ImageData>[].obs;
  var page = 1;
  var hasMore = true;

  @override
  void onInit() {
    fetchImages();
    super.onInit();
  }

  void fetchImages({String query = "nature", bool loadMore = false}) async {
    if (!loadMore) {
      isLoading(true);
      page = 1; // Reset to page 1 for new searches
      imageList.clear();
    } else {
      if (isLoadingMore.value || !hasMore) return; // Prevent loading more if already loading or no more images
      isLoadingMore(true);
      page++;
    }

    try {
      var response = await DioClient.shared.get(
        '?key=${Constant.apiKey}&'
        'q=$query&'
        'image_type=photo&'
        'page=$page&'
        'per_page=20',
      );
      if (response.statusCode == 200) {
        final imageData = imageDataModelFromJson(jsonEncode(response.data)).images;
        if (imageData==null||imageData.isEmpty) {
          hasMore = false; // No more images
        } else {
          imageList.addAll(imageData);
        }
      }
    } catch (e) {
      print('Error fetching images: $e');
    } finally {
      isLoading(false);
      isLoadingMore(false);
    }
  }
}
