import 'package:get/get.dart';
import 'package:newsly/ui/screens/bookmarks/bookmarksScreen.dart';
import 'package:newsly/ui/screens/home/homeScreen.dart';
import 'package:newsly/ui/screens/search/searchScreen.dart';
import 'package:newsly/ui/screens/splashScreen.dart';
import 'package:newsly/ui/screens/storyDetails/storyDetailsScreen.dart';

class Routes {
  static String splashScreen = "/splash";
  static String homeScreen = "/";
  static String storyDetailsScreen = "/story-details";
  static String searchScreen = "/search";
  static String bookmarksScreen = "/bookmarks";

  /// Every screen exposes a static `getRouteInstance()` so screen-scoped
  /// BlocProviders live next to the screen instead of in this file.
  static List<GetPage<dynamic>> getPages = [
    GetPage(
      name: splashScreen,
      page: SplashScreen.getRouteInstance,
    ),
    GetPage(
      name: homeScreen,
      page: HomeScreen.getRouteInstance,
    ),
    GetPage(
      name: storyDetailsScreen,
      page: StoryDetailsScreen.getRouteInstance,
    ),
    GetPage(
      name: searchScreen,
      page: SearchScreen.getRouteInstance,
    ),
    GetPage(
      name: bookmarksScreen,
      page: BookmarksScreen.getRouteInstance,
    ),
  ];
}
