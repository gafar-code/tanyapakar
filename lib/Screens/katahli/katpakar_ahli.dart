import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tanyapakar/Screens/katahli/perkatpakar_ahli.dart';
import 'package:tanyapakar/Screens/katahli/tambah_keahlian.dart';
import 'package:tanyapakar/Screens/profile/pakar_profile.dart';
import 'package:tanyapakar/components/background.dart';
import 'package:tanyapakar/constanta/warna.dart';
import 'package:tanyapakar/api/apiutils.dart';
import 'package:tanyapakar/controllers/pakar/pakar_controller.dart';
import 'package:tanyapakar/model/pakar/kategori_pakar_model.dart';
import 'package:tanyapakar/model/pengguna/pengguna_model.dart';
import 'package:toggle_switch/toggle_switch.dart';

class KatMyAhliScreen extends StatefulWidget {
  final String idPengguna;

  const KatMyAhliScreen({Key? key, required this.idPengguna}) : super(key: key);

  @override
  _KatMyAhliState createState() => _KatMyAhliState();
}

class _KatMyAhliState extends State<KatMyAhliScreen> {
  final ApiUtils apiUtils = ApiUtils();
  bool sdhCari = false;
  Future? nextFuture;
  TextEditingController ctrlCari = TextEditingController();
  late Pengguna _pengguna;

  @override
  void initState() {
    super.initState();
    nextFuture = apiUtils.getMyKategori(idPengguna: widget.idPengguna);
  }

  Future<void> setStatus(int? index) async {
    FormData formData = FormData.fromMap({
      "idPengguna": widget.idPengguna,
      "state": index.toString(),
    });

    Response response = await apiUtils
        .getDataService()
        .post("pakar/setPakarAvail", data: formData);
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
        ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
            type: ArtSweetAlertType.success,
            text: response.data["msgErr"],
          ),
        );
      }
    }
  }

  Future<void> hapus(int idKat) async {}

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        mini: true,
        heroTag: "btnTambahKeahlian",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  TambahKeahlianScreen(idPengguna: widget.idPengguna),
            ),
          );
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Background(
        child: Column(
          children: [
            FutureBuilder(
              future: apiUtils.getPengguna(idPengguna: widget.idPengguna),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _pengguna = (snapshot.data as List<Pengguna>)[0];
                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(left: 5),
                        child: Row(
                          children: [
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: size.height * 0.15),
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      child: ToggleSwitch(
                                        minWidth: 47.0,
                                        cornerRadius: 20.0,
                                        activeBgColors: [
                                          [Colors.red[800]!],
                                          [Colors.green[800]!]
                                        ],
                                        activeFgColor: Colors.white,
                                        inactiveBgColor: Colors.grey,
                                        inactiveFgColor: Colors.white,
                                        initialLabelIndex:
                                            int.parse(_pengguna.tersedia!),
                                        totalSwitches: 2,
                                        labels: const ['OFF', 'ON'],
                                        radiusStyle: true,
                                        onToggle: (index) {
                                          setStatus(index);
                                        },
                                      ),
                                    ),
                                    SizedBox(width: size.width * 0.02),
                                    FloatingActionButton(
                                      heroTag: "btnChatPakar",
                                      onPressed: () async {},
                                      mini: true,
                                      child: const Icon(Icons.send, size: 20),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              margin: const EdgeInsets.only(top: 40, right: 10),
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PakarProfileScreen(
                                          pengguna: _pengguna),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 30.0,
                                      backgroundImage: NetworkImage(
                                          _pengguna.avatarPengguna!),
                                      backgroundColor: Colors.transparent,
                                    ),
                                    Text(
                                      '${_pengguna.nickName}',
                                      style: const TextStyle(
                                          color: kOrange, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
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
                    fontSize: 12,
                  ),
                  controller: ctrlCari,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Cari Keahlian Saya',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          if (ctrlCari.text.isEmpty) {
                            if (sdhCari) {
                              nextFuture = PakarController()
                                  .getMyKategori(idPengguna: widget.idPengguna);
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
                            nextFuture = PakarController().getMyKategoriCari(
                                idPengguna: widget.idPengguna,
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
              child: const Text(
                'Keahlian Saya',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
                      padding: const EdgeInsets.only(left: 20, top: 10),
                      itemBuilder: (context, index) {
                        var kategori =
                            (snapshot.data as List<MyKategori>)[index];
                        return Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(right: 10),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PerKatAhliScreen(
                                                  myKategori: kategori,
                                                  pengguna: _pengguna),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 30.0,
                                          backgroundImage: NetworkImage(
                                              kategori.coverKategori),
                                          backgroundColor: Colors.transparent,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                kategori.namaKategori,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                kategori.desKategori,
                                                style:
                                                    subtitleTextStyle.copyWith(
                                                        color: colorDarkBlue,
                                                        fontSize: 12),
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
                      itemCount: (snapshot.data as List<MyKategori>).length,
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
      ),
    );
  }
}
