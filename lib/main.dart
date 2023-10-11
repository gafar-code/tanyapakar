import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as io_pakar;
import 'package:tanyapakar/Screens/katahli/chats_pakar.dart';
import 'package:tanyapakar/Screens/katahli/chatsy.dart';
import 'package:tanyapakar/Screens/login/login.dart';
import 'package:tanyapakar/api/apiutils.dart';
import 'package:tanyapakar/constanta/warna.dart';
import 'package:tanyapakar/firebase/messaging.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

String? idPenggunaLogged;
String? tokenLogged;
String? jenisPenggunaLogged;
String? idKepada;
String? idDari;
String? router;
String? idKlasifikasiNotif;
int? mulaiChat = 0;
String? pageChatPakar;
String? pageChatMember;

final io_pakar.Socket socket = io_pakar.io(
  'http://api.tanyapakar.com:4545',
  io_pakar.OptionBuilder().setTransports(['websocket']).disableAutoConnect().build(),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var sesLogin = await SharedPreferences.getInstance();
  idPenggunaLogged = sesLogin.getString("idPengguna");
  jenisPenggunaLogged = sesLogin.getString("jenisPengguna");
  mulaiChat = sesLogin.getInt("mulaiChat");
  await Firebase.initializeApp();
  await FcmService.init();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _WidgetState createState() => _WidgetState();
}

class _WidgetState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    tokenGet();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void tokenGet() async {
    String? token = await FirebaseMessaging.instance.getToken();

    FormData formData = FormData.fromMap({
      "idPengguna": idPenggunaLogged,
      "token": token,
    });

    Response response = await ApiUtils().getDataService().post("pakar/saveToken", data: formData);
    if (response.statusCode == 200) {
      debugPrint(token.toString());
      tokenLogged = token;
    } else {
      debugPrint("gagal");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tanya Pakar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        "loginPage": (context) => const LoginScreen(),
        "chater": (context) => ChatyScreen(
              idKlasifikasi: idKlasifikasiNotif!,
              idPakar: idKepada!,
              idPengguna: idPenggunaLogged!,
            ),
        "chaterpakar": (context) => ChatScreenPakar(idMemberKlasifikasi: idKepada!, myIdPengguna: idDari!, myidKlasifikasi: idKlasifikasiNotif!),
      },
      initialRoute: "loginPage",
      navigatorKey: navigatorKey,
    );
  }
}
