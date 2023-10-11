import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tanyapakar/Screens/login/login_after.dart';
import 'package:tanyapakar/Screens/prelogin/prelogin.dart';
import 'package:tanyapakar/api/apiutils.dart';
import 'package:tanyapakar/components/background.dart';
import 'package:tanyapakar/components/rounded_button.dart';
import 'package:tanyapakar/components/text_field_pakar.dart';
import 'package:tanyapakar/constanta/warna.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String routeName = 'loginPage';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  TextEditingController ctrlEmail = TextEditingController();
  TextEditingController ctrlPwd = TextEditingController();
  final ApiUtils apiUtils = ApiUtils();

  @override
  void initState() {
    super.initState();
    getSharedSession();
  }

  _launchWhatsapp() async {
    final Uri _url =
        Uri.parse("whatsapp://send?phone=6289530183089&text=Halo TanyaPakar!");

    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }

  Future<void> getSharedSession() async {
    SharedPreferences sesLogin = await SharedPreferences.getInstance();
    String? idPengguna = sesLogin.getString("idPengguna");
    String? jenisPengguna = sesLogin.getString("jenisPengguna");
    if (idPengguna != null) {
      if (jenisPengguna != null) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginAfterScreen(
              idPengguna: idPengguna,
              jenisPengguna: jenisPengguna,
            ),
          ),
        );

        /*
        if (jenisPengguna == "1") {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => KatMyAhliScreen(
                idPengguna: idPengguna,
              ),
            ),
          );
        } else if (jenisPengguna == "2") {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => KatMemberScreen(
                idPengguna: idPengguna,
              ),
            ),
          );
        } else if (jenisPengguna == "3") {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeAdminScreen(),
            ),
          );
        }
        */
      } else {
        await sesLogin.clear();
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PreloginScreen(),
          ),
        );
      }
    }
  }

  Future setLogin() async {
    FormData formData = FormData.fromMap({
      "email": ctrlEmail.text,
      "pwd": ctrlPwd.text,
    });

    Response response =
        await apiUtils.getDataService().post("pakar/login", data: formData);
    if (response.statusCode == 200) {
      late SharedPreferences loginData;

      if (response.data["error"] == 2) {
        ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
            type: ArtSweetAlertType.danger,
            text: response.data["msgErr"],
          ),
        );
      } else {
        loginData = await SharedPreferences.getInstance();
        loginData.setString("idPengguna", response.data["idPengguna"]);
        loginData.setString("jenisPengguna", response.data["jenisPengguna"]);

        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginAfterScreen(
              idPengguna: response.data["idPengguna"],
              jenisPengguna: response.data["jenisPengguna"],
            ),
          ),
        );

        /*
        if (response.data["jenisPengguna"] == "1") {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => KatMyAhliScreen(
                idPengguna: response.data["idPengguna"],
              ),
            ),
          );
        } else if (response.data["jenisPengguna"] == "2") {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => KatMemberScreen(
                idPengguna: response.data["idPengguna"],
              ),
            ),
          );
        } else if (response.data["jenisPengguna"] == "3") {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeAdminScreen(),
            ),
          );
        }

        */
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () {
          _launchWhatsapp();
        },
        backgroundColor: Colors.indigo,
        child: const Text(
          "CS",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Background(
        child: Column(
          children: <Widget>[
            SizedBox(height: size.height * 0.05),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: const Text(
                "TANYA PAKAR",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 20),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: size.height * 0.03),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      margin:
                          const EdgeInsets.only(top: 20, left: 10, right: 10),
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.blueAccent, // Set border color
                            width: 2.0), // Set border width
                        // Set rounded corner radius
                      ),
                      child: const Text("Space Iklan"),
                    ),
                    SizedBox(height: size.height * 0.05),
                    SizedBox(
                      height: 35,
                      child: TextFieldPakar(
                          controller: ctrlEmail, label: "E-Mail/WA"),
                    ),
                    SizedBox(height: size.height * 0.03),
                    SizedBox(
                      height: 35,
                      child: TextFieldPakar(
                          controller: ctrlPwd, label: "Passwrod", isPwd: true),
                    ),
                    Container(
                      height: 35,
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Lupa Password',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 0,
                      ),
                      child: SizedBox(
                        height: 50,
                        child: RoundedButton(
                          sizeWidth: 0.3,
                          borderRadius: BorderRadius.circular(29),
                          icon: Icons.arrow_forward_outlined,
                          text: "Login",
                          press: () {
                            setLogin();
                          },
                          color: kPrimaryColor,
                          color2: kOrange,
                          textColor: colorWhite,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(10.0),
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.blueAccent)),
                            child: const Text(
                              'Space Iklan',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(10.0),
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.orangeAccent)),
                            child: const Text(
                              'Space Iklan',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(10.0),
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.greenAccent)),
                            child: const Text(
                              'Space Iklan',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: const [
                              Text(
                                "Belum Punya Akun?",
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Column(
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const PreloginScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Buat Akun",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
