import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:tanyapakar/Screens/member/perkatpakar_member.dart';
import 'package:tanyapakar/Screens/profile/member_profile.dart';

import 'package:tanyapakar/components/background.dart';
import 'package:tanyapakar/constanta/warna.dart';
import 'package:tanyapakar/model/kategori/kategori_model.dart';
import 'package:tanyapakar/api/apiutils.dart';
import 'package:tanyapakar/model/pengguna/pengguna_model.dart';

class KatMemberScreen extends StatefulWidget {
  final String idPengguna;
  const KatMemberScreen({Key? key, required this.idPengguna}) : super(key: key);

  @override
  _KatMemberState createState() => _KatMemberState();
}

class _KatMemberState extends State<KatMemberScreen> {
  final ApiUtils apiUtils = ApiUtils();
  bool sdhCari = false;
  int offset = 0;
  int perpage = 0;
  List<Kategori> listKategori = [];
  List<Pengguna> listPengguna = [];
  Future? nextFuture;
  TextEditingController ctrlCari = TextEditingController();
  Pengguna pengguna = Pengguna();
  late Kategori kategori;

  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _getPengguna();
    _firstLoad();
    _controller = ScrollController()
      ..addListener(() {
        _loadMore();
      });
  }

  @override
  void dispose() {
    _controller.removeListener(() {
      _loadMore();
    });
    super.dispose();
  }

  Future<void> _firstLoad() async {
    FormData formdata = FormData.fromMap({"offset": offset});

    setState(() {
      _isFirstLoadRunning = true;
    });

    try {
      Response response = await apiUtils
          .getDataService()
          .post("pakar/getKategoriNew", data: formdata);
      if (response.statusCode == 200) {
        var getData = response.data["data"] as List;
        var listData = getData.map((e) => Kategori.fromJson(e)).toList();
        listKategori.clear();
        listKategori.addAll(listData);
        offset = 0;
        perpage = response.data["perpage"];
        setState(() {});
      } else {
        debugPrint("Failed to load Kategori");
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  Future<void> _cari(String? query) async {
    FormData formdata = FormData.fromMap({"key": query});

    setState(() {
      _isFirstLoadRunning = true;
    });

    try {
      Response response = await apiUtils
          .getDataService()
          .post("pakar/cariKategori", data: formdata);
      if (response.statusCode == 200) {
        var getData = response.data as List;
        var listData = getData.map((e) => Kategori.fromJson(e)).toList();
        listKategori.clear();
        listKategori.addAll(listData);
        setState(() {});
      } else {
        debugPrint("Failed to load Kategori");
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true;
      });

      offset += perpage;
      try {
        FormData formdata = FormData.fromMap({"offset": offset});

        Response response = await apiUtils
            .getDataService()
            .post("pakar/getKategoriNew", data: formdata);

        if (response.statusCode == 200) {
          if (response.data["error"] == 2) {
            var getData = response.data["data"] as List;
            var listData = getData.map((e) => Kategori.fromJson(e)).toList();
            listKategori.addAll(listData);
            perpage = response.data["perpage"];
            setState(() {});
          } else {
            _hasNextPage = false;
          }
        } else {
          debugPrint("Failed to load Kategori");
        }
      } catch (e) {
        debugPrint(e.toString());
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  Future<void> _getPengguna() async {
    FormData formdata = FormData.fromMap({"idPengguna": widget.idPengguna});
    try {
      Response response = await apiUtils
          .getDataService()
          .post("pakar/getPengguna", data: formdata);
      if (response.statusCode == 200) {
        var getData = response.data as List;
        listPengguna = getData.map((e) => Pengguna.fromJSON(e)).toList();
        pengguna = listPengguna[0];
        setState(() {});
      } else {
        debugPrint("Failed to load Pengguna");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Background(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 5),
              child: Row(
                children: [
                  Container(
                    height: 100,
                    width: size.width * 0.65,
                    margin: const EdgeInsets.only(top: 70, left: 10, right: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent, width: 2.0),
                    ),
                    child: const Text("Space Iklan"),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      height: 100,
                      width: size.width * 0.25,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: listPengguna.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MemberProfileScreen(
                                    pengguna: pengguna,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 30.0,
                                  backgroundImage: NetworkImage(
                                      listPengguna[index]
                                          .avatarPengguna
                                          .toString()),
                                  backgroundColor: Colors.transparent,
                                ),
                                Text(
                                  listPengguna[index].nickName.toString(),
                                  style: const TextStyle(
                                      color: kOrange, fontSize: 12),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
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
                height: 20,
                child: TextField(
                  style: const TextStyle(fontSize: 12),
                  controller: ctrlCari,
                  decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.only(top: 3),
                      border: InputBorder.none,
                      hintStyle: const TextStyle(color: Colors.grey),
                      hintText: 'Cari Kategori',
                      suffixIcon: SizedBox(
                        width: 10,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (ctrlCari.text.isEmpty) {
                                if (sdhCari) {
                                  _firstLoad();
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
                                _cari(ctrlCari.text);
                                sdhCari = true;
                              }
                            });
                          },
                          child: const Icon(Icons.search_rounded),
                        ),
                      )
                      /*
                    IconButton(
                      padding: const EdgeInsets.only(top: 2, right: 0),
                      onPressed: () {
                        setState(() {
                          if (ctrlCari.text.isEmpty) {
                            if (sdhCari) {
                              _firstLoad();
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
                            _cari(ctrlCari.text);
                            sdhCari = true;
                          }
                        });
                      },
                      icon: const Icon(Icons.search_rounded),
                    ),
                    */
                      ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Kategori',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: _isFirstLoadRunning
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(left: 20, top: 20),
                      controller: _controller,
                      itemCount: listKategori.length,
                      itemBuilder: (context, index) {
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
                                              PerKatPakarMemberScreen(
                                            idKategori:
                                                listKategori[index].idKategori,
                                            pengguna: pengguna,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 30.0,
                                          backgroundImage: NetworkImage(
                                              listKategori[index]
                                                  .coverKategori),
                                          backgroundColor: Colors.transparent,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                listKategori[index]
                                                    .namaKategori,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                listKategori[index]
                                                    .deskripsiKategori,
                                                style:
                                                    subtitleTextStyle.copyWith(
                                                        color: colorDarkBlue,
                                                        fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                            listKategori[index].jmlPakar +
                                                ' Pakar',
                                            style:
                                                const TextStyle(fontSize: 12)),
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
                    ),
            ),
            if (_isLoadMoreRunning == true)
              const Padding(
                padding: EdgeInsets.only(top: 10, bottom: 40),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
