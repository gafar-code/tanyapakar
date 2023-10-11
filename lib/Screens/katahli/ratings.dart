import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tanyapakar/api/apiutils.dart';
import 'package:tanyapakar/components/background.dart';
import 'package:tanyapakar/components/rounded_button.dart';
import 'package:tanyapakar/constanta/warna.dart';
import 'package:tanyapakar/model/klasifikasi/member_klasifikasi_model.dart';
import 'package:tanyapakar/model/pengguna/pengguna_model.dart';

class RatingScreen extends StatefulWidget {
  final MemberKlasifikasi memberKlasifikasi;
  final Pengguna pengguna;
  const RatingScreen(
      {Key? key, required this.memberKlasifikasi, required this.pengguna})
      : super(key: key);

  @override
  _WidgetState createState() => _WidgetState();
}

class _WidgetState extends State<RatingScreen> {
  double nilaiRating = 0;

  Future<void> submitRating(BuildContext context) async {
    FormData formData = FormData.fromMap({
      "idPengguna": widget.pengguna.idPengguna,
      "idPakar": widget.memberKlasifikasi.idPakar,
      "nilai": nilaiRating.toString(),
    });

    Response response = await ApiUtils()
        .getDataService()
        .post("pakar/saveRating", data: formData);

    if (response.statusCode == 200) {
      debugPrint(response.data["error"].toString());
      if (response.data["error"] == 2) {
        ArtSweetAlert.show(
          context: context,
          barrierDismissible: false,
          artDialogArgs: ArtDialogArgs(
            type: ArtSweetAlertType.danger,
            text: response.data["msgErr"],
          ),
        );
      } else {
        ArtDialogResponse rsp = await ArtSweetAlert.show(
          context: context,
          barrierDismissible: false,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.success,
              text: response.data["msgErr"],
              confirmButtonText: "Ok!"),
        );

        if (rsp.isTapConfirmButton) {
          Navigator.pop(context);
        } else {
          return;
        }
      }
    }
  }

  Column header() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 35),
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: kPrimaryLightColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(40),
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage:
                    NetworkImage(widget.memberKlasifikasi.imgAvatar),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.memberKlasifikasi.nickName,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(widget.memberKlasifikasi.namaKlasifikasi,
                      style: const TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

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
        child: Stack(
          children: [
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Column(
                children: <Widget>[
                  SizedBox(height: size.height * 0.07),
                  header(),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      "Silahkan berikan Penilaian Anda atas Solusi yang telah dijelaskan",
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(children: [
                          RatingBar.builder(
                            initialRating: 0,
                            minRating: 0,
                            itemSize: 30,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 1),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              setState(() {
                                nilaiRating = rating;
                              });
                            },
                          ),
                          SizedBox(height: size.height * 0.04),
                          RoundedButton(
                            sizeWidth: 0.4,
                            borderRadius: BorderRadius.circular(29),
                            icon: Icons.save_as_outlined,
                            text: "Submit",
                            press: () {
                              submitRating(context);
                            },
                            color: kPrimaryColor,
                            color2: kOrange,
                            textColor: colorWhite,
                          ),
                        ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
