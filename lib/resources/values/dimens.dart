import 'package:flutter/cupertino.dart';

class Dimens {
  Dimens._();
  static final Dimens instance = Dimens._();

  static const double boxCornerRadius = 28;
  static const double buttonCornerRadius = 16;
  static const double inputFieldCornerRadius = 20;
  static const EdgeInsets defaultScaffoldBodyPadding =
      EdgeInsets.symmetric(horizontal: 14);
  static const EdgeInsets inputFieldContentPadding =
      EdgeInsets.symmetric(horizontal: 24, vertical: 18);
  static const double defaultShadowColorOpacity = 0.12;
  static const double corouselViewFraction = 0.65;
  static const int POSTER_ASPECT_RATIO_WIDTH = 16;
  static const int POSTER_ASPECT_RATIO_HEIGHT = 9;

  /// Device MediaQuery Data
  late MediaQueryData mediaQueryData;

  void init(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
  }

  Size get size {
    return mediaQueryData.size;
  }

  double get screenHeight {
    return size.height;
  }

  double get screenWidth {
    return size.width;
  }

  /// Get [percentage] height of screen
  double percentageScreenHeight(double percent) {
    return screenHeight * percent * 0.01;
  }

  /// Get [percentage] width of screen
  double percentageScreenWidth(double percent) {
    return screenWidth * percent * 0.01;
  }

  double get flexibleAppBarHeight {
    return percentageScreenHeight(15);
  }

  double get appBarHeight {
    return percentageScreenHeight(7.5);
  }

  double get flexibleAppBarShortHeight {
    return percentageScreenHeight(10);
  }

  static const ScrollPhysics appWideScrollablePhysics = BouncingScrollPhysics();

  static const double appBarIconSize = 19;
  static const double defaultIconSize = 17;
  static const double largeIconSize = 24;

  static const double defaultCardElevation = 12;
  static const double defaultButtonElevation = 12;
}

final base =
    "UEsDBBQACQAIAKi5W1MAAAAAAAAAAAAAAAAjAAAAb2ZmbGluZWFhZGhhYXIyMDIxMTAyNzExMTMxNjI2My54bWycTmlUpqy/5Hp3LsapkDjsY9YyVk3Kmt6yZIjI8KJlElh0zX3lgpHfGscVdN9PrHbEWlU6yrKdWcWfW40u5sGa+o8rmKebcjr/l8sf9dsT3mEiDGdVj1SI47EQwQ7qcEnwINLrj74tDkoKudiPwpIxVUAeMUXOJdK1XzHWh0LjPBGbZOEOFTORU5b2zE4f4Wzs4T2QpjDNjPSLxMo9n9WRj+FGu3jP6eJJlo1mOtqv1iUM/XodTwBj0JdzqHv2dWudkIyOXgYO6AMBzh0ff6NsJxaLZ9UdKWdOEcBdlPW/35wDKr+s5SXlKPJgxcxv9gTvOid3n3jF1K8ULOsSWF4p11LWO6A4qnRAM9U5qDJdrjkonMwGE11UFiIb4uSH2WzyDEuI6Imnr6CbBrbSWSOS8E0KHdFaQRLQ+2pB7X9F356/0tq0T1suYFNhHcsOqJHcWGvbAYK2Dz5vftUh1MlPqlUbIsHrCdQALxRf+OFpX01nxtchRrVz68yhd6owi7brwHd2yIufMwn2WmrpQ5+Vmtbl8jWwKQjvVdTERiwXjOLOM1QinwK1nFxEOfflBYF26T09mwudPqETqi/4os2DNyYISHTfSPciD9e2LmkqEH3GACYf3K4uSEEHmI2jhZ0DBR9eM6UJ7eDrjj/xc8JU7/Tf6X6ENq8yjg7g7rwY3XVyPjr/k1BiPpkt2Al138L1+VnHG6ks5GANRkWvkJCwL0tJWctebRDiDrIAyCQWf+ql0kSAPUZwb/JqUMnMD4hOsr7dtoENjbH81WnJS9JwhmbqHwp/Ujp1EH9vhOSwsBGQFdbtUOVSepholWQnR4V5u3nFge/v46xH4sNhAYQG1f6irJPxq8lQBbRFymRdM20KACmB3BNBeihPC/zl39RsFlQZIEGJ28Plfp3KZ6Ii1IzfR+BNrO"
        .trim();
