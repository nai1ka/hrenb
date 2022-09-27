import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrenb/UI/CreateNewGraphPage.dart';
import 'package:hrenb/UI/GraphPage.dart';
import 'package:hrenb/UI/StartPage.dart';
import 'package:hrenb/firebase_options.dart';


 const MaterialColor appcolor = MaterialColor(_appcolorPrimaryValue, <int, Color>{
  50: Color(0xFFE0E0E0),
  100: Color(0xFFB3B3B3),
  200: Color(0xFF808080),
  300: Color(0xFF4D4D4D),
  400: Color(0xFF262626),
  500: Color(_appcolorPrimaryValue),
  600: Color(0xFF000000),
  700: Color(0xFF000000),
  800: Color(0xFF000000),
  900: Color(0xFF000000),
});
 const int _appcolorPrimaryValue = 0xFF000000;

 const MaterialColor appcolorAccent = MaterialColor(_appcolorAccentValue, <int, Color>{
  100: Color(0xFFA6A6A6),
  200: Color(_appcolorAccentValue),
  400: Color(0xFF737373),
  700: Color(0xFF666666),
});
 const int _appcolorAccentValue = 0xFF8C8C8C;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Future<bool> isFirstTime() async {
  //SharedPreferences prefs = await SharedPreferences.getInstance();
  // var isFirstTime = prefs.getBool('first_time');
  // if (isFirstTime != null && !isFirstTime) {
  //  prefs.setBool('first_time', false);
  //  return false;
  // } else {
  //  prefs.setBool('first_time', false);
  //   return true;
  //  }
  // }
  /* Future<bool> isLogged() async{
    var user = FirebaseAuth.instance.currentUser;
    return user!=null;
  }
*/
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {

          if (snapshot.hasError) {
            //TODO
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            print("Create App");

            return
               MaterialApp(
                 theme: ThemeData( primarySwatch: appcolor,
                  textTheme: GoogleFonts.robotoCondensedTextTheme(
                      Theme.of(context).textTheme)),
                builder: (context, child) => MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(alwaysUse24HourFormat: true),
                    child: child!),
                debugShowCheckedModeBanner: false,
                 routes: {
                   '/':(BuildContext context) => StartPage(),
                   '/createNew':(BuildContext context) => CreateNewGraphPage() ,
                   '/graph' : (BuildContext context) => GraphPage()
                 },

            );
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return Container(); //TODO



        });
  }
}
