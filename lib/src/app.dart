import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:project_mesa/src/data/game_data.dart';
import 'package:project_mesa/src/model/navigator_args.dart';
import 'package:project_mesa/src/page/home/index.dart';
import 'package:project_mesa/src/page/item/index.dart';

import 'settings/settings_controller.dart';

import 'theme/theme.dart';

/// The Widget that configures your application.
class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  final SettingsController settingsController;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _dataLoaded = false;

  void _loadData() async {
    await loadData();
    setState(() {
      _dataLoaded = true;
      // whenever your initialization is completed, remove the splash screen:
      FlutterNativeSplash.remove();
    });
  }

  @override
  void initState() {
    //  LOAD JSON
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return AnimatedBuilder(
      animation: widget.settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(),
          darkTheme: Themes.darkTheme.copyWith(
            textSelectionTheme: const TextSelectionThemeData(
                cursorColor: Themes.textColor,
                selectionColor: Themes.primaryColor,
                selectionHandleColor: Themes.primaryColor),
          ),
          themeMode: widget.settingsController.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                if (_dataLoaded) {
                  switch (routeSettings.name) {
                    case Home.routeName:
                      return const Home();
                    case ItemDetail.routeName:
                      final args =
                          routeSettings.arguments as ItemDetailNavigatorArgs;
                      return ItemDetail(name: args.name);
                    default:
                      return const Home();
                  }
                }
                return Container();
              },
            );
          },
        );
      },
    );
  }
}
