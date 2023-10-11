import 'package:flutter/material.dart';
import 'package:tanyapakar/Screens/bartab/daftar_member.dart';
import 'package:tanyapakar/Screens/bartab/daftar_pakar.dart';
import 'package:tanyapakar/components/background.dart';
import 'package:tanyapakar/constanta/warna.dart';

class PreloginScreen extends StatefulWidget {
  const PreloginScreen({Key? key}) : super(key: key);

  @override
  _PreloginState createState() => _PreloginState();
}

class _PreloginState extends State<PreloginScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
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
          children: <Widget>[
            SizedBox(height: size.height * 0.1),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text(
                "PENDAFTARAN",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 24),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: size.height * 0.08),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(29),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: TabBar(
                  unselectedLabelColor: Colors.black,
                  labelColor: Colors.white,
                  indicatorColor: Colors.red,
                  indicatorWeight: 2,
                  indicator: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(29),
                  ),
                  controller: tabController,
                  tabs: const [
                    Tab(
                      text: 'Pakar',
                    ),
                    Tab(
                      text: 'User/Klien',
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: size.height * 0.03),
            Expanded(
                child: Container(
              alignment: Alignment.center,
              child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: tabController,
                  children: const [
                    DaftarPakarScreen(),
                    DaftarKonsumenScreen(),
                  ]),
            )),
          ],
        ),
      ),
    );
  }
}
