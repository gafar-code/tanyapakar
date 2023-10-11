import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:tanyapakar/api/apiutils.dart';
import 'package:tanyapakar/components/rounded_button.dart';
import 'package:tanyapakar/constanta/warna.dart';
import 'package:tanyapakar/model/bb/saldo_pakar_model.dart';
import 'package:tanyapakar/model/bb/saldo_total_model.dart';
import 'package:tanyapakar/model/pengguna/pengguna_model.dart';

class SaldoAhliFragment extends StatefulWidget {
  final Pengguna pengguna;
  const SaldoAhliFragment({Key? key, required this.pengguna}) : super(key: key);

  @override
  _ChatFragmentState createState() => _ChatFragmentState();
}

class _ChatFragmentState extends State<SaldoAhliFragment> {
  int total = 0;
  TextEditingController ctrlWD = TextEditingController();

  void penarikan() async {
    FormData formData = FormData.fromMap({
      "idPengguna": widget.pengguna.idPengguna,
      "jumlah": ctrlWD.text,
    });

    Response response =
        await ApiUtils().getDataService().post("pakar/WD", data: formData);
    if (response.statusCode == 200) {
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
        ArtSweetAlert.show(
          context: context,
          barrierDismissible: false,
          artDialogArgs: ArtDialogArgs(
            type: ArtSweetAlertType.success,
            text: response.data["msgErr"],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: size.height * 0.1),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          child: const Text(
            'Saldo Tersedia',
            style: TextStyle(fontSize: 30),
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          child: FutureBuilder(
            future: ApiUtils()
                .getSaldoTotal(idPengguna: widget.pengguna.idPengguna!),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var _total = (snapshot.data as List<SaldoTotal>)[0];
                return Text(
                  _total.total,
                  style: const TextStyle(
                    fontSize: 30,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
        Expanded(
          child: SizedBox(
            height: 300,
            child: FutureBuilder(
              future: ApiUtils()
                  .getSaldoPakar(idPengguna: widget.pengguna.idPengguna!),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(left: 20, top: 20),
                    itemBuilder: (context, index) {
                      var _saldo = (snapshot.data as List<SaldoPakar>)[index];
                      return Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding:
                                const EdgeInsets.only(right: 10, bottom: 10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 40.0,
                                      backgroundImage:
                                          NetworkImage(_saldo.imgAvatar),
                                      backgroundColor: Colors.transparent,
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(_saldo.nickName,
                                            style:
                                                const TextStyle(fontSize: 20)),
                                        Text(
                                          _saldo.tgl,
                                          style: subtitleTextStyle.copyWith(
                                              color: colorDarkBlue),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Text(_saldo.kredit,
                                        style: const TextStyle(fontSize: 18)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                    itemCount: (snapshot.data as List<SaldoPakar>).length,
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ),
        SizedBox(height: size.height * 0.03),
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 40),
          child: TextField(
            controller: ctrlWD,
            textAlign: TextAlign.end,
            decoration: const InputDecoration(labelText: "Withdrawal"),
            keyboardType: TextInputType.number,
            inputFormatters: [ThousandsFormatter()],
          ),
        ),
        SizedBox(height: size.height * 0.03),
        Container(
          alignment: Alignment.centerRight,
          margin: const EdgeInsets.symmetric(horizontal: 40),
          child: RoundedButton(
            sizeWidth: 0.4,
            text: "Request",
            press: () {
              penarikan();
            },
            color: kPrimaryColor,
            color2: kPrimaryColor,
            textColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
