import 'package:flutter/material.dart';
import 'package:tanyapakar/api/apiutils.dart';
import 'package:tanyapakar/components/background.dart';
import 'package:tanyapakar/constanta/warna.dart';

class KodeReff extends StatefulWidget {
  const KodeReff({Key? key}) : super(key: key);

  @override
  _WidgetState createState() => _WidgetState();
}

class _WidgetState extends State<KodeReff> {
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
                'Kode Reffreal',
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
                        "Silahkan Bagikan Kode Reffreal Anda kepada Orang yang Anda Referensikan",
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    const Text("Kode Reffreal Anda :"),
                    SizedBox(height: size.height * 0.05),
                    const Text(
                      "XYZK24",
                      style: TextStyle(fontWeight: FontWeight.bold),
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
