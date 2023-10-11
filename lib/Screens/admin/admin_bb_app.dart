import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tanyapakar/api/apiutils.dart';
import 'package:tanyapakar/constanta/warna.dart';
import 'package:tanyapakar/model/bb/bukti_bayar_model.dart';

class AdminBBApp extends StatefulWidget {
  const AdminBBApp({Key? key}) : super(key: key);

  @override
  _WidgetState createState() => _WidgetState();
}

class _WidgetState extends State<AdminBBApp> {
  Future? nextFuture;
  bool sdhCari = false;
  TextEditingController ctrlCari = TextEditingController();

  @override
  void initState() {
    super.initState();
    nextFuture = ApiUtils().getBuktiBayar();
  }

  Future<void> _appBB(String idBukti, String aksi) async {
    final String msgAksi =
        aksi == "3" ? "Yakin Tolak Data?" : "Yakin App Data?";

    ArtDialogResponse artDialogResponse = await ArtSweetAlert.show(
      barrierDismissible: false,
      context: context,
      artDialogArgs: ArtDialogArgs(
        type: ArtSweetAlertType.question,
        confirmButtonText: "Yakin",
        denyButtonText: "Tidak",
        text: msgAksi,
        title: "App Bukti Bayar",
      ),
    );

    if (artDialogResponse.isTapConfirmButton) {
      try {
        FormData formData = FormData.fromMap({
          "idBuktiBayar": idBukti,
          "aksi": aksi,
        });

        Response response = await ApiUtils()
            .getDataService()
            .post("pakar/appBuktiBayar", data: formData);

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
            setState(() {
              nextFuture = ApiUtils().getBuktiBayar();
            });
            ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.success,
                text: response.data["msgErr"],
              ),
            );
          }
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  Future<void> _showPopupMenu(BuildContext context, TapDownDetails details,
      BuktiBayar buktiBayar) async {
    var selected = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        details.globalPosition.dx,
        details.globalPosition.dy,
        details.globalPosition.dx,
        details.globalPosition.dy,
      ),
      items: [
        _buildMenuItem("App", Icons.check, 2),
        _buildMenuItem("Tolak", Icons.delete_forever, 3),
      ],
      elevation: 8.0,
    );

    if (selected == 2) {
      _appBB(buktiBayar.idBuktiBayar, selected.toString());
    } else if (selected == 3) {
      _appBB(buktiBayar.idBuktiBayar, selected.toString());
    } else {
      return;
    }
  }

  PopupMenuItem _buildMenuItem(String title, IconData iconData, int position) {
    return PopupMenuItem(
      value: position,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            iconData,
            color: Colors.black,
          ),
          Text(title),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: size.height * 0.02),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(29),
            ),
            child: TextField(
              controller: ctrlCari,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Cari Bukti Bayar',
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      if (ctrlCari.text.isEmpty) {
                        if (sdhCari) {
                          nextFuture = ApiUtils().getBuktiBayar();
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
                        nextFuture =
                            ApiUtils().getBuktiBayarCari(query: ctrlCari.text);
                        sdhCari = true;
                      }
                    });
                  },
                  icon: const Icon(Icons.search_rounded),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: nextFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  int ada = (snapshot.data as List<BuktiBayar>).length;
                  if (ada > 0) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(left: 20, top: 20),
                      itemBuilder: (context, index) {
                        var bb = (snapshot.data as List<BuktiBayar>)[index];
                        return Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(right: 10),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 40.0,
                                        backgroundImage:
                                            NetworkImage(bb.avatarPengguna),
                                        backgroundColor: Colors.transparent,
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(bb.nickName,
                                              style: const TextStyle(
                                                  fontSize: 20)),
                                          Text(
                                            bb.hp + ' (Rp. ${bb.jumlah} )',
                                            style: subtitleTextStyle.copyWith(
                                                color: colorDarkBlue),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          SizedBox(
                                            child: GestureDetector(
                                              child:
                                                  const Icon(Icons.more_vert),
                                              onTapDown: (details) =>
                                                  _showPopupMenu(
                                                      context, details, bb),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: size.height * 0.03),
                                ],
                              ),
                            )
                          ],
                        );
                      },
                      itemCount: (snapshot.data as List<BuktiBayar>).length,
                    );
                  } else {
                    return const Center(
                      child: Text(
                        "Data Kosong",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
