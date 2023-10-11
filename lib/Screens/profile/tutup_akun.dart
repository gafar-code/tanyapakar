import 'package:flutter/material.dart';
import 'package:tanyapakar/api/apiutils.dart';
import 'package:tanyapakar/components/background.dart';
import 'package:tanyapakar/components/rounded_button.dart';

import 'package:tanyapakar/constanta/warna.dart';
import 'package:tanyapakar/model/pengguna/pengguna_model.dart';

class TutupAkun extends StatefulWidget {
  final Pengguna pengguna;
  const TutupAkun({Key? key, required this.pengguna}) : super(key: key);

  @override
  _WidgetState createState() => _WidgetState();
}

class _WidgetState extends State<TutupAkun> {
  final ApiUtils apiUtils = ApiUtils();

  TextEditingController ctrlPwdLama = TextEditingController();
  TextEditingController ctrlPwdBaru = TextEditingController();
  TextEditingController ctrlKonfirmasiPwdBaru = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: kPrimaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        elevation: 0,
      ),
      body: Background(
        child: Column(
          children: [
            SizedBox(height: size.height * 0.22),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text(
                'Penutupan Akun',
                style: TextStyle(fontSize: 30),
              ),
            ),
            SizedBox(height: size.height * 0.03),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: size.height * .03),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Text(
                        "Akun Anda akan ditutup Selamanya dan tidak bisa digunakan Lagi",
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Text(
                          "Kalau Anda Setuju dengan Penutupan Akun Secara Permanen Silahkan Klik Tombol Tutup di Bawah"),
                    ),
                    SizedBox(height: size.height * 0.05),
                    const Text(
                      "Terima Kasih",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: size.height * 0.05),
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      child: RoundedButton(
                        sizeWidth: 0.5,
                        borderRadius: BorderRadius.circular(29),
                        icon: Icons.power_settings_new,
                        text: "Tutup Permanen",
                        press: () {},
                        color: Colors.red,
                        color2: Colors.red,
                        textColor: Colors.white,
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
