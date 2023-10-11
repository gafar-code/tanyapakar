import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:tanyapakar/api/apiutils.dart';
import 'package:tanyapakar/constanta/warna.dart';
import 'package:tanyapakar/model/klasifikasi/klasifikasi_admin_model.dart';

class AdminKlasifikasiAktif extends StatefulWidget {
  const AdminKlasifikasiAktif({Key? key}) : super(key: key);

  @override
  _WidgetState createState() => _WidgetState();
}

class _WidgetState extends State<AdminKlasifikasiAktif> {
  Future? nextFuture;
  bool sdhCari = false;
  TextEditingController ctrlCari = TextEditingController();

  @override
  void initState() {
    super.initState();
    nextFuture = ApiUtils().getKlasifikasiAdmin(status: "1");
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
                hintText: 'Cari Klasifikasi',
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      if (ctrlCari.text.isEmpty) {
                        if (sdhCari) {
                          nextFuture = ApiUtils().getKlasifikasiAdmin(status: "1");
                          sdhCari = false;
                        } else {
                          ArtSweetAlert.show(
                            context: context,
                            barrierDismissible: false,
                            artDialogArgs: ArtDialogArgs(
                              type: ArtSweetAlertType.danger,
                              text: "Kata Kunci Kosong",
                            ),
                          );
                        }
                      } else {
                        nextFuture = ApiUtils().getKlasifikasiAdminCari(
                            status: "1", query: ctrlCari.text);
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
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(left: 20, top: 20),
                    itemBuilder: (context, index) {
                      var _klasifikasi =
                          (snapshot.data as List<KlasifikasiAdmin>)[index];
                      return Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(right: 10),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 40.0,
                                        backgroundImage: NetworkImage(
                                            _klasifikasi.coverKlasifikasi),
                                        backgroundColor: Colors.transparent,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(child: 
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _klasifikasi.nickName,
                                            style:
                                                const TextStyle(fontSize: 20),
                                          ),
                                           Text(
                                            _klasifikasi.namaKlasifikasi,
                                            style: subtitleTextStyle.copyWith(
                                                color: colorDarkBlue),
                                          ),
                                          Text(
                                            _klasifikasi.hp,
                                            style: subtitleTextStyle.copyWith(
                                                color: colorDarkBlue),
                                          ),
                                        ],
                                      ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: size.height * 0.03),
                              ],
                            ),
                          )
                        ],
                      );
                    },
                    itemCount: (snapshot.data as List<KlasifikasiAdmin>).length,
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
