import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:tanyapakar/Screens/katahli/edit_keahlian.dart';
import 'package:tanyapakar/Screens/profile/pakar_profile.dart';
import 'package:tanyapakar/api/apiutils.dart';

import 'package:tanyapakar/components/background.dart';
import 'package:tanyapakar/constanta/warna.dart';

import 'package:tanyapakar/model/klasifikasi/klasifikasi_model.dart';
import 'package:tanyapakar/model/pakar/kategori_pakar_model.dart';
import 'package:tanyapakar/model/pengguna/pengguna_model.dart';

class PerKatAhliScreen extends StatefulWidget {
  final MyKategori myKategori;
  final Pengguna pengguna;

  const PerKatAhliScreen(
      {Key? key, required this.myKategori, required this.pengguna})
      : super(key: key);

  @override
  _PerKatAhliScreenState createState() => _PerKatAhliScreenState();
}

class _PerKatAhliScreenState extends State<PerKatAhliScreen> {
  final ApiUtils apiUtils = ApiUtils();
  bool sdhCari = false;
  Future? nextFuture;
  TextEditingController ctrlCari = TextEditingController();

  @override
  void initState() {
    super.initState();
    nextFuture = apiUtils.getKlasifikasiPakar(
        idKategori: widget.myKategori.idKategori,
        idPengguna: widget.pengguna.idPengguna!);
  }

  Future<void> _showPopupMenu(BuildContext context, TapDownDetails details,
      Klasifikasi klasifikasi) async {
    var selected = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        details.globalPosition.dx,
        details.globalPosition.dy,
        details.globalPosition.dx,
        details.globalPosition.dy,
      ),
      items: [
        _buildMenuItem("Edit", Icons.edit, 1),
        _buildMenuItem("Delete", Icons.delete_forever, 2),
      ],
      elevation: 8.0,
    );

    if (selected == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditKeahlianScreen(
            idPengguna: widget.pengguna.idPengguna!,
            klasifikasi: klasifikasi,
          ),
        ),
      );
    } else if (selected == 2) {
      _hapus(klasifikasi.idKlasifikasi);
    }
  }

  void _hapus(String idKlasifikasi) async {
    FormData formdata = FormData.fromMap({
      "idKlasifikasi": idKlasifikasi,
      "idPengguna": widget.pengguna.idPengguna!
    });

    try {
      ArtDialogResponse _tanya = await ArtSweetAlert.show(
        barrierDismissible: false,
        context: context,
        artDialogArgs: ArtDialogArgs(
          type: ArtSweetAlertType.question,
          confirmButtonText: "Yakin!",
          denyButtonText: "Tidak",
          text: "Yakin Hapus Data Klasifikasi Anda?",
          title: "Hapus",
        ),
      );

      if (_tanya.isTapConfirmButton) {
        Response response = await apiUtils
            .getDataService()
            .post("pakar/hapusKlasifikasi", data: formdata);
        if (response.statusCode == 200) {
          if (response.data["error"] == 2) {
            ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.danger,
                text: response.data["msgErr"],
              ),
            );
          } else {
            ArtDialogResponse _sukses = await ArtSweetAlert.show(
              barrierDismissible: false,
              context: context,
              artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.success,
                confirmButtonText: "Ok!",
                text: "Sukses Hapus Data Klasifikasi",
              ),
            );

            if (_sukses.isTapConfirmButton) {
              setState(() {
                nextFuture = apiUtils.getKlasifikasiPakar(
                    idKategori: widget.myKategori.idKategori,
                    idPengguna: widget.pengguna.idPengguna!);
              });
            }
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  PopupMenuItem _buildMenuItem(String title, IconData iconData, int position) {
    return PopupMenuItem(
      value: position,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            child: Icon(
              iconData,
              color: Colors.black,
            ),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget futureBuilder(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: nextFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(left: 10, top: 10, right: 1),
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var klasifikasi = (snapshot.data as List<Klasifikasi>)[index];
                return Column(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Column(
                                children: [
                                  CircleAvatar(
                                    radius: 30.0,
                                    backgroundImage: NetworkImage(
                                        klasifikasi.coverKlasifikasi),
                                    backgroundColor: Colors.transparent,
                                  ),
                                ],
                              ),
                              SizedBox(width: size.width * 0.02),
                              SizedBox(
                                width: size.width * 0.32,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      klasifikasi.namaKlasifikasi,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Jasa : " + klasifikasi.jasa,
                                      style: const TextStyle(fontSize: 12),
                                      textAlign: TextAlign.end,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  width: size.width * 0.25,
                                  margin: const EdgeInsets.only(right: 10),
                                  child: Column(
                                    children: [
                                      RatingBar.builder(
                                        initialRating:
                                            double.parse(klasifikasi.rating),
                                        minRating: 0,
                                        itemSize: 15,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        ignoreGestures: true,
                                        itemCount: 5,
                                        itemPadding: const EdgeInsets.symmetric(
                                            horizontal: 1),
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {},
                                      ),
                                      Text(
                                        '${klasifikasi.jmlKonsultasi} Konsultasi',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      GestureDetector(
                                        child: const Icon(Icons.more_horiz),
                                        onTapDown: (details) => _showPopupMenu(
                                            context, details, klasifikasi),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.04),
                  ],
                );
              },
              itemCount: (snapshot.data as List<Klasifikasi>).length,
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
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
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 40, right: 10),
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PakarProfileScreen(pengguna: widget.pengguna),
                          ),
                        );
                      },
                      child: Column(children: [
                        CircleAvatar(
                          radius: 30.0,
                          backgroundImage:
                              NetworkImage(widget.pengguna.avatarPengguna!),
                          backgroundColor: Colors.transparent,
                        ),
                        Text('${widget.pengguna.nickName}',
                            style:
                                const TextStyle(color: kOrange, fontSize: 12)),
                      ]),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(29),
              ),
              child: SizedBox(
                height: 30,
                child: TextField(
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                  controller: ctrlCari,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Cari Klasifikasi',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          if (ctrlCari.text.isEmpty) {
                            if (sdhCari) {
                              nextFuture = apiUtils.getKlasifikasiPakar(
                                idKategori: widget.myKategori.idKategori,
                                idPengguna: widget.pengguna.idPengguna!,
                              );
                              sdhCari = false;
                            } else {
                              ArtSweetAlert.show(
                                context: context,
                                artDialogArgs: ArtDialogArgs(
                                  type: ArtSweetAlertType.danger,
                                  text: "Kata Kunci Kosong",
                                ),
                              );
                            }
                          } else {
                            nextFuture = apiUtils.getKlasifikasiPakarCari(
                                idKategori: widget.myKategori.idKategori,
                                idPengguna: widget.pengguna.idPengguna!,
                                query: ctrlCari.text);
                            sdhCari = true;
                          }
                        });
                      },
                      icon: const Icon(Icons.search_rounded),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(top: 10, left: 10),
              child: Text(
                widget.myKategori.namaKategori,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: futureBuilder(context),
            ),
          ],
        ),
      ),
    );
  }
}
