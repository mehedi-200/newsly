import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:newsly/app/routes.dart';
import 'package:newsly/cubits/bookmarks/bookmarksCubit.dart';
import 'package:newsly/cubits/settings/themeCubit.dart';
import 'package:newsly/data/repositories/settingsRepository.dart';
import 'package:newsly/ui/styles/appTheme.dart';
import 'package:newsly/utils/hiveBoxKeys.dart';

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  //Boxes are opened up front so repositories can stay synchronous.
  await Hive.initFlutter();
  await Hive.openBox(settingsBoxKey);
  await Hive.openBox(bookmarksBoxKey);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        //App-wide cubits only. Feature cubits are provided by their screen.
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit(SettingsRepository()),
        ),
        BlocProvider<BookmarksCubit>(
          create: (_) => BookmarksCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return GetMaterialApp(
            title: "Newsly",
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: themeMode,
            getPages: Routes.getPages,
            initialRoute: Routes.splashScreen,
          );
        },
      ),
    );
  }
}
