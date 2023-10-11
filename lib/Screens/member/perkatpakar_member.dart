import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tanyapakar/Screens/katahli/detailklasifikasi.dart';
import 'package:tanyapakar/Screens/profile/member_profile.dart';
import 'package:tanyapakar/api/apiutils.dart';

import 'package:tanyapakar/components/background.dart';
import 'package:tanyapakar/constanta/warna.dart';
import 'package:tanyapakar/model/kategori/kategori_model.dart';
import 'package:tanyapakar/model/klasifikasi/member_klasifikasi_model.dart';
import 'package:tanyapakar/model/pengguna/pengguna_model.dart';
import 'package:toggle_switch/toggle_switch.dart';

class PerKatPakarMemberScreen extends StatefulWidget {
  final String idKategori;
  final Pengguna pengguna;

  const PerKatPakarMemberScreen(
      {Key? key, required this.idKategori, required this.pengguna})
      : super(key: key);

  @override
  _WidgetState createState() => _WidgetState();
}

class _WidgetState extends State<PerKatPakarMemberScreen> {
  final ApiUtils apiUtils = ApiUtils();
  bool sdhCari = false;
  List<Kategori> listKategori = [];
  List<MemberKlasifikasi> listMemberKlasifikasi = [];
  TextEditingController ctrlCari = TextEditingController();

  int offset = 0;
  int perpage = 0;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _getCaption();
    _firstLoad();
    _controller = ScrollController()
      ..addListener(() {
        _loadMore();
      });
  }

  Future<void> _onRefresh() async {
    _firstLoad();
  }

  Future<void> _firstLoad() async {
    FormData formdata =
        FormData.fromMap({"offset": offset, "idKategori": widget.idKategori});

    setState(() {
      _isFirstLoadRunning = true;
    });

    try {
      Response response = await apiUtils
          .getDataService()
          .post("pakar/getKlasifikasiMemberPage", data: formdata);
      if (response.statusCode == 200) {
        var getData = response.data["data"] as List;
        var listData =
            getData.map((e) => MemberKlasifikasi.fromJSON(e)).toList();
        listMemberKlasifikasi.clear();
        listMemberKlasifikasi.addAll(listData);
        offset = 0;
        perpage = response.data["perpage"];
        setState(() {});
      } else {
        debugPrint("Failed to load First MemberKlasifikasi");
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
        FormData formdata = FormData.fromMap({
          "offset": offset,
          "idKategori": widget.idKategori,
        });

        Response response = await apiUtils
            .getDataService()
            .post("pakar/getKlasifikasiMemberPage", data: formdata);

        if (response.statusCode == 200) {
          if (response.data["error"] == 2) {
            var getData = response.data["data"] as List;
            var listData =
                getData.map((e) => MemberKlasifikasi.fromJSON(e)).toList();
            listMemberKlasifikasi.addAll(listData);
            perpage = response.data["perpage"];
            setState(() {});
          } else {
            _hasNextPage = false;
          }
        } else {
          debugPrint("Failed to load More MemberKlasifikasi");
        }
      } catch (e) {
        debugPrint(e.toString());
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  Future<void> _cari(String? query) async {
    FormData formdata = FormData.fromMap({
      "key": query,
      "idKategori": widget.idKategori,
    });

    setState(() {
      _isFirstLoadRunning = true;
    });

    try {
      Response response = await apiUtils
          .getDataService()
          .post("pakar/getKlasifikasiMemberCari", data: formdata);
      if (response.statusCode == 200) {
        var getData = response.data as List;
        var listData =
            getData.map((e) => MemberKlasifikasi.fromJSON(e)).toList();
        listMemberKlasifikasi.clear();
        listMemberKlasifikasi.addAll(listData);
        setState(() {});
      } else {
        debugPrint("Failed to load Cari MemberKlasifikasi");
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  Future<void> _getCaption() async {
    FormData formdata = FormData.fromMap({"idKategori": widget.idKategori});

    try {
      Response response = await apiUtils
          .getDataService()
          .post("pakar/getKategoriById", data: formdata);
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
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
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
              SizedBox(height: size.height * 0.02),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20, right: 10),
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MemberProfileScreen(
                                pengguna: widget.pengguna,
                              ),
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
                          Text(
                            '${widget.pengguna.nickName}',
                            style:
                                const TextStyle(color: kOrange, fontSize: 13),
                          ),
                        ]),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.05),
              Container(
                margin: const EdgeInsets.only(left: 10, right: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(29),
                ),
                child: SizedBox(
                  height: 30,
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
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20, top: 1),
                width: size.width,
                height: 50,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: listKategori.length,
                  padding: const EdgeInsets.only(left: 0, top: 20),
                  itemBuilder: (context, index) {
                    return Text(
                      listKategori[index].namaKategori.toUpperCase(),
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    );
                  },
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: _isFirstLoadRunning
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(left: 5),
                          itemCount: listMemberKlasifikasi.length,
                          controller: _controller,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailKlasifikasiScreen(
                                      pengguna: widget.pengguna,
                                      idKlasifikasi:
                                          listMemberKlasifikasi[index]
                                              .idKlasifikasi,
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Container(
                                    width: size.width * 0.15,
                                    padding: const EdgeInsets.only(right: 1),
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                          listMemberKlasifikasi[index]
                                              .coverKlasifikasi),
                                      backgroundColor: Colors.transparent,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: size.width * 0.6,
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                            listMemberKlasifikasi[index]
                                                .nickName,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            'Jasa Rp. ' +
                                                listMemberKlasifikasi[index]
                                                    .jasa,
                                            textAlign: TextAlign.left,
                                            style:
                                                const TextStyle(fontSize: 11),
                                          ),
                                          Text(
                                            listMemberKlasifikasi[index]
                                                .namaKlasifikasi,
                                            textAlign: TextAlign.justify,
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: size.width * 0.2,
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.only(
                                          right: 10, left: 5),
                                      child: Column(
                                        children: [
                                          RatingBar.builder(
                                            initialRating: double.parse(
                                                listMemberKlasifikasi[index]
                                                    .rating),
                                            minRating: 0,
                                            itemSize: 15,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            ignoreGestures: true,
                                            itemCount: 5,
                                            itemPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 1),
                                            itemBuilder: (context, _) =>
                                                const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) {},
                                          ),
                                          Text(
                                            listMemberKlasifikasi[index]
                                                    .jmlKonsultasi +
                                                ' Konsultasi',
                                            style:
                                                const TextStyle(fontSize: 10),
                                          ),
                                          SizedBox(height: size.height * 0.005),
                                          SizedBox(
                                            height: 20,
                                            child: ToggleSwitch(
                                              minWidth: 45,
                                              cornerRadius: 10,
                                              doubleTapDisable: true,
                                              activeBgColors:
                                                  listMemberKlasifikasi[index]
                                                              .tersedia ==
                                                          "1"
                                                      ? [
                                                          [Colors.green[800]!],
                                                        ]
                                                      : [
                                                          [Colors.grey[500]!],
                                                        ],
                                              activeFgColor: Colors.white,
                                              inactiveBgColor:
                                                  listMemberKlasifikasi[index]
                                                              .tersedia ==
                                                          "1"
                                                      ? Colors.green[800]
                                                      : Colors.grey,
                                              inactiveFgColor: Colors.white,
                                              initialLabelIndex: int.parse(
                                                  listMemberKlasifikasi[index]
                                                      .tersedia),
                                              totalSwitches: 1,
                                              labels:
                                                  listMemberKlasifikasi[index]
                                                              .tersedia ==
                                                          "1"
                                                      ? const ['ON']
                                                      : const ['OFF'],
                                              radiusStyle: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
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
      ),
    );
  }
}
