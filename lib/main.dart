import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kelawin/Modules/Mainscreen.dart';
import 'package:kelawin/firebase_options.dart';
import 'package:kelawin/presentation/multikissanbill/provider/multi_kissan_pro.dart';
import 'package:provider/provider.dart';

import 'viewmodel/calcWidgetVisibilty/grandtotalvisible_provider.dart';
import 'viewmodel/multikissanbillcalc/multi_grandtotal.dart';

void main() {
  const MyApp()._datacon();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MultiKissanPro()),
        ChangeNotifierProvider(create: (_) => GrandtotalVisibleProvider()),
        ChangeNotifierProvider(create: (_) => MultiGrandtotal()),
      ],
      builder: (context, child) => MaterialApp(
        theme: ThemeData(
          textSelectionTheme: TextSelectionThemeData(
            selectionColor:
                Colors.blueAccent.shade100, // Background color of selected text
            cursorColor: Colors.grey, // Cursor color
            selectionHandleColor: Colors.blue, // Handle color
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: const Mainscreen(),
      ),
    );
  }

  Future _datacon() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // await Firebase.initializeApp(
    //     options: const FirebaseOptions(
    //         apiKey: "AIzaSyCNpkJyIiwTbv0XwDx4S6Z4Ca4WreHj7RU",
    //         appId: "1:551633722216:android:096cb608c1e4f5e90e94dd",
    //         messagingSenderId: "551633722216",
    //         projectId: "aniket1-d3f36"));
  }
}
