import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/image_data_model.dart';
import '../../../widgets/search_bar/anim_search_widget.dart';
import 'home_page_logic.dart';

class HomePageWidget extends StatelessWidget {
  final HomePageLogic _controller = Get.find<HomePageLogic>();
  final ScrollController _scrollController = ScrollController();

  HomePageWidget({super.key}) {
    // Add listener to the ScrollController for pagination
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        // When the user reaches the bottom of the list, load more images
        _controller.fetchImages(loadMore: true,query: _controller.lastQuery);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
   var size =  MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(size.width, size.height/18),
        child: Stack(
          children: [
            AppBar(
              title: const Text('Pixabay Image Gallery'),
            ),
            Positioned(
                bottom: 10,
                right: 10,
                child: _buildSearchBar(context)),
          ],
        ),
      ),
      body: Column(
        children: [

          Expanded(
            child: Obx(() {
              if (_controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return _buildImageGrid(context);
            }),
          ),
          Obx(() {
            return _controller.isLoadingMore.value
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : const SizedBox();
          })
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    TextEditingController textController = TextEditingController();
    return AnimSearchBar(
      width: screenWidth - 50,
      height: 30,
      textController: textController,
      boxShadow: true,
      rtl: true,
      onSuffixTap: () {
        textController.clear();
      },
      searchBarOpen: (_) {},
      onSubmitted: (query) {
        _controller.fetchImages(query: query);
      },
    );
  }

  // Calculate the number of columns dynamically based on screen width
  Widget _buildImageGrid(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var crossAxisCount = (screenWidth ~/ 150); // Calculate number of columns
    ScrollPhysics getScrollPhysics() {
      if (kIsWeb) {
        return const ClampingScrollPhysics();
      } else if (Platform.isAndroid || Platform.isIOS) {
        return const BouncingScrollPhysics();
      } else {
        return const AlwaysScrollableScrollPhysics();
      }
    }
    return GridView.builder(
      physics: getScrollPhysics(),
      controller: _scrollController, // Attach the ScrollController for pagination
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount, // Use calculated columns count
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
        childAspectRatio: 0.85, // Ensures that items are displayed as squares
      ),
      itemCount: _controller.imageList.length,
      itemBuilder: (context, index) {
        var image = _controller.imageList[index];
        return _buildImageCard(image);
      },
    );
  }

  Widget _buildImageCard(ImageData image) {
    return Card(
      margin: EdgeInsets.zero,
      child: Stack(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 8.5/10, // Ensure the image is displayed as a square
            child: CachedNetworkImage(imageUrl: image.webformatUrl!,fit: BoxFit.cover)
            // child:Image.network(image.webformatUrl!, fit: BoxFit.cover),
          ),
           LikesAndViews(image),
        ],
      ),
    );
  }
}

class LikesAndViews extends StatelessWidget {
  final ImageData image;

  const LikesAndViews(this.image, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final img = Image.network(image.webformatUrl!);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: kIsWeb?
      LikeAndView(backColor: Colors.black26, image: image, textColor: Colors.white)
          :FutureBuilder(
          future: ColorScheme.fromImageProvider(provider: img.image),
        builder: (context,snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const SizedBox.shrink();
          }
          final textColor = snap.data!.primaryContainer;
          final backColor = snap.data!.onPrimaryFixedVariant;
          return LikeAndView(backColor: backColor, image: image, textColor: textColor);
        }
      ),
    );
  }
}

class LikeAndView extends StatelessWidget {
  const LikeAndView({
    super.key,
    required this.backColor,
    required this.image,
    required this.textColor,
  });

  final Color backColor;
  final ImageData image;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color:backColor
            ),
            child: Text('${image.likes} likes', style:  TextStyle(fontSize: 12, color: textColor))),
        const SizedBox(
          height: 5,
        ),
        Container(
            padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color:backColor
            ),child: Text('${image.views} views', style: TextStyle(fontSize: 12, color: textColor))),
      ],
    );
  }
}
