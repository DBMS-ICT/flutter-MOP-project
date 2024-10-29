import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_kurdish_localization/flutter_kurdish_localization.dart';
import 'package:new_peshmargah_pro/pages/ResponsiveLoginLayout.dart';
import 'package:new_peshmargah_pro/pages/fbi.dart';
import 'package:new_peshmargah_pro/pages/helthy.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = Locale('en'); // Default locale

  void _changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690), // Base dimensions for scaling
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          locale: _locale,
          localizationsDelegates: [
            KurdishMaterialLocalizations.delegate,
            KurdishCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            AppLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en', ''), // English
            const Locale('ar', ''), // Arabic
            const Locale('ku', ''), // Central Kurdish (Sorani)
          ],
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            // Check if locale is Arabic or Kurdish (RTL languages)
            bool isRtl =
                _locale.languageCode == 'ar' || _locale.languageCode == 'ku';
            return Directionality(
              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
              child: child!,
            );
          },
          home: MainScreen(onLocaleChange: _changeLanguage),
        );
      },
    );
  }
}

class MainScreen extends StatelessWidget {
  final Function(Locale) onLocaleChange;

  MainScreen({required this.onLocaleChange});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
              builder: (context) =>
                  ResponsiveLoginLayout(onLocaleChange: onLocaleChange));
        },
      ),
      floatingActionButton: PopupMenuButton<String>(
        icon: Icon(
          Icons.language,
          color: Colors.black, // Set your desired icon color
          size: 30, // Set the size of the icon
        ),
        onSelected: (String value) {
          // Handle language selection
          switch (value) {
            case 'en':
              onLocaleChange(Locale('en'));
              break;
            case 'ar':
              onLocaleChange(Locale('ar'));
              break;
            case 'ku':
              onLocaleChange(Locale('ku'));
              break;
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'en',
            child: Text('English'),
          ),
          const PopupMenuItem<String>(
            value: 'ar',
            child: Text('عربي'),
          ),
          const PopupMenuItem<String>(
            value: 'ku',
            child: Text('کوردی'),
          ),
        ],
      ),
    );
  }
}