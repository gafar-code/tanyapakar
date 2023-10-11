import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tanyapakar/Screens/admin/admin_home.dart';
import 'package:tanyapakar/Screens/katahli/katpakar_ahli.dart';
import 'package:tanyapakar/Screens/member/katpakar_member.dart';
import 'package:tanyapakar/Screens/prelogin/prelogin.dart';
import 'package:tanyapakar/api/apiutils.dart';
import 'package:tanyapakar/components/background.dart';
import 'package:tanyapakar/components/rounded_button.dart';
import 'package:tanyapakar/constanta/warna.dart';

class LoginAfterScreen extends StatefulWidget {
  final idPengguna;
  final jenisPengguna;

  const LoginAfterScreen(
      {Key? key, required this.idPengguna, required this.jenisPengguna})
      : super(key: key);

  static const String routeName = 'loginAfterPage';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginAfterScreen> {
  TextEditingController ctrlEmail = TextEditingController();
  TextEditingController ctrlPwd = TextEditingController();
  final ApiUtils apiUtils = ApiUtils();

  @override
  void initState() {
    super.initState();
  }

  Future<void> getSharedSession() async {
    SharedPreferences sesLogin = await SharedPreferences.getInstance();
    String? idPengguna = sesLogin.getString("idPengguna");
    String? jenisPengguna = sesLogin.getString("jenisPengguna");
    if (idPengguna != null) {
      if (jenisPengguna != null) {
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
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
                          const EdgeInsets.only(top: 70, left: 10, right: 10),
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
                    SizedBox(
                      height: size.height * 0.10,
                    ),
                    SizedBox(
                      height: 50,
                      child: RoundedButton(
                        sizeWidth: 0.3,
                        borderRadius: BorderRadius.circular(29),
                        icon: Icons.home,
                        text: "Home",
                        press: () {
                          getSharedSession();
                        },
                        color: kPrimaryColor,
                        color2: kOrange,
                        textColor: colorWhite,
                      ),
                    ),
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
