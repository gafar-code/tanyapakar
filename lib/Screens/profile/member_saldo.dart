import 'package:flutter/material.dart';
import 'package:tanyapakar/Screens/profile/member_upload_bukti.dart';
import 'package:tanyapakar/api/apiutils.dart';
import 'package:tanyapakar/components/background.dart';
import 'package:tanyapakar/constanta/warna.dart';
import 'package:tanyapakar/model/bb/bukti_bayar_model.dart';
import 'package:tanyapakar/model/pengguna/pengguna_model.dart';

class MemberSaldoFragment extends StatefulWidget {
  final Pengguna pengguna;
  const MemberSaldoFragment({Key? key, required this.pengguna})
      : super(key: key);

  @override
  _WidgetState createState() => _WidgetState();
}

class _WidgetState extends State<MemberSaldoFragment> {
  Future? nextFuture;

  @override
  void initState() {
    super.initState();
    nextFuture =
        ApiUtils().getBuktiBayarMember(idPengguna: widget.pengguna.idPengguna!);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  MemberUploadBBScreen(idPengguna: widget.pengguna.idPengguna!),
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
            SizedBox(height: size.height * 0.2),
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
                        var bbm = (snapshot.data as List<BuktiBayar>)[index];
                        return Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.only(right: 10, bottom: 10),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {},
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 40.0,
                                          backgroundImage:
                                              NetworkImage(bbm.avatarPengguna),
                                          backgroundColor: Colors.transparent,
                                        ),
                                        const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(bbm.nickName,
                                                style: const TextStyle(
                                                    fontSize: 20)),
                                            Text(
                                              bbm.hp,
                                              style: subtitleTextStyle.copyWith(
                                                  color: colorDarkBlue),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                      },
                      itemCount: (snapshot.data as List<BuktiBayar>).length,
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
