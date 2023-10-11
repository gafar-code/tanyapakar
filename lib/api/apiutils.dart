import 'package:dio/dio.dart';
import 'package:tanyapakar/api/logging.dart';
import 'package:tanyapakar/model/bb/bank.dart';
import 'package:tanyapakar/model/bb/bukti_bayar_model.dart';
import 'package:tanyapakar/model/bb/saldo_pakar_model.dart';
import 'package:tanyapakar/model/bb/saldo_total_model.dart';
import 'package:tanyapakar/model/kategori/kategori_model.dart';
import 'package:tanyapakar/model/klasifikasi/klasifikasi_admin_model.dart';
import 'package:tanyapakar/model/klasifikasi/klasifikasi_model.dart';
import 'package:tanyapakar/model/klasifikasi/member_klasifikasi_model.dart';
import 'package:tanyapakar/model/pakar/kategori_pakar_model.dart';
import 'package:tanyapakar/model/pengguna/pengguna_member_model.dart';
import 'package:tanyapakar/model/pengguna/pengguna_model.dart';

class ApiUtils {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://api.tanyapakar.com/",
      connectTimeout: 50000,
      receiveTimeout: 6000,
    ),
  )..interceptors.add(Logging());

  Dio getDataService() {
    return _dio;
  }

  Future<List<Banks>> getSuggestionBank(String query) async {
    try {
      FormData formData = FormData.fromMap({
        "key": query,
      });

      Response response = await _dio.post(
        "pakar/cariBank",
        data: formData,
      );

      if (response.statusCode == 200) {
        final List getData = response.data;

        return getData.map((json) => Banks.fromJSON(json)).where((what) {
          final nameLower = what.namaBank.toLowerCase();
          final queryLower = query.toLowerCase();

          return nameLower.contains(queryLower);
        }).toList();
      } else {
        throw Exception("Failed to load Data Bank");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Kategori>> getSuggestionKategori(String query) async {
    try {
      FormData formData = FormData.fromMap({
        "key": query,
      });

      Response response = await _dio.post(
        "pakar/cariKategori",
        data: formData,
      );

      if (response.statusCode == 200) {
        final List getData = response.data;

        return getData.map((json) => Kategori.fromJson(json)).where((kategori) {
          final nameLower = kategori.namaKategori.toLowerCase();
          final queryLower = query.toLowerCase();

          return nameLower.contains(queryLower);
        }).toList();
      } else {
        throw Exception("Failed to load Pengguna");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<BuktiBayar>> getBuktiBayarCari({required String query}) async {
    try {
      FormData formData = FormData.fromMap({"key": query});

      Response response =
          await _dio.post("pakar/getBuktiBayar", data: formData);

      if (response.statusCode == 200) {
        var getData = response.data as List;
        var listData = getData.map((e) => BuktiBayar.fromJSON(e)).toList();
        return Future.value(listData);
      } else {
        return throw Exception("Failed to load Bukti Bayar");
      }
    } catch (e) {
      return throw Exception(e);
    }
  }

  Future<List<BuktiBayar>> getBuktiBayar() async {
    try {
      Response response = await _dio.post("pakar/getBuktiBayar");

      if (response.statusCode == 200) {
        var getData = response.data as List;
        var listData = getData.map((e) => BuktiBayar.fromJSON(e)).toList();
        return Future.value(listData);
      } else {
        return throw Exception("Failed to load Bukti Bayar");
      }
    } catch (e) {
      return throw Exception(e);
    }
  }

  Future<List<BuktiBayar>> getBuktiBayarMember(
      {required String idPengguna}) async {
    try {
      FormData formData = FormData.fromMap({"idPengguna": idPengguna});
      Response response =
          await _dio.post("pakar/buktiBayarMember", data: formData);

      if (response.statusCode == 200) {
        var getData = response.data as List;
        var listData = getData.map((e) => BuktiBayar.fromJSON(e)).toList();
        return Future.value(listData);
      } else {
        return throw Exception("Failed to load Bukti Bayar");
      }
    } catch (e) {
      return throw Exception(e);
    }
  }

  Future<List<Pengguna>> getAllPenggunaCari({required String query}) async {
    try {
      FormData formData = FormData.fromMap({"key": query});
      Response response =
          await _dio.post("pakar/getAllPenggunaCari", data: formData);

      if (response.statusCode == 200) {
        var getData = response.data as List;
        var listData = getData.map((e) => Pengguna.fromJSON(e)).toList();
        return Future.value(listData);
      } else {
        return throw Exception("Failed to load Pengguna");
      }
    } catch (e) {
      return throw Exception(e);
    }
  }

  Future<List<Pengguna>> getAllPengguna() async {
    try {
      Response response = await _dio.get("pakar/getAllPengguna");

      if (response.statusCode == 200) {
        var getData = response.data as List;
        var listData = getData.map((e) => Pengguna.fromJSON(e)).toList();
        return Future.value(listData);
      } else {
        return throw Exception("Failed to load Pengguna");
      }
    } catch (e) {
      return throw Exception(e);
    }
  }

  Future<List<Pengguna>> getAllPenggunaNonAktif() async {
    try {
      Response response = await _dio.post("pakar/getAllPenggunaNonAktif");

      if (response.statusCode == 200) {
        var getData = response.data as List;
        var listData = getData.map((e) => Pengguna.fromJSON(e)).toList();
        return Future.value(listData);
      } else {
        return throw Exception("Failed to load Pengguna");
      }
    } catch (e) {
      return throw Exception(e);
    }
  }

  Future<List<Pengguna>> getPengguna({required String idPengguna}) async {
    FormData formData = FormData.fromMap({
      "idPengguna": idPengguna,
    });

    try {
      Response response = await _dio.post(
        "pakar/getPengguna",
        data: formData,
      );

      if (response.statusCode == 200) {
        var getData = response.data as List;
        var listData = getData.map((e) => Pengguna.fromJSON(e)).toList();
        return Future.value(listData);
      } else {
        return throw Exception("Failed to load Pengguna");
      }
    } catch (e) {
      return throw Exception(e);
    }
  }

  Future<List<PenggunaMember>> getPenggunaMember(
      {required String idPengguna}) async {
    FormData formData = FormData.fromMap({
      "idPengguna": idPengguna,
    });

    try {
      Response response = await _dio.post(
        "pakar/getPengguna",
        data: formData,
      );

      if (response.statusCode == 200) {
        var getData = response.data as List;
        var listData = getData.map((e) => PenggunaMember.fromJSON(e)).toList();
        return Future.value(listData);
      } else {
        return throw Exception("Failed to load Pengguna Member");
      }
    } catch (e) {
      return throw Exception(e);
    }
  }

  Future<List<MyKategori>> getMyKategori({required String idPengguna}) async {
    try {
      FormData formData = FormData.fromMap({
        "idPengguna": idPengguna,
      });

      Response response = await _dio.post("pakar/myKategori", data: formData);
      if (response.statusCode == 200) {
        var getData = response.data as List;
        var listData = getData.map((e) => MyKategori.fromJson(e)).toList();
        return listData;
      } else {
        return throw Exception("Failed to load Kategori");
      }
    } catch (e) {
      return throw Exception(e);
    }
  }

  Future<List<SaldoTotal>> getSaldoTotal({required String idPengguna}) async {
    try {
      FormData formData = FormData.fromMap({
        "idPengguna": idPengguna,
      });

      Response response =
          await _dio.post("pakar/getTotalSaldoPakar", data: formData);
      if (response.statusCode == 200) {
        var getData = response.data as List;
        var listData = getData.map((e) => SaldoTotal.fromJSON(e)).toList();
        return listData;
      } else {
        return throw Exception("Failed to load Saldo Total");
      }
    } catch (e) {
      return throw Exception(e);
    }
  }

  Future<List<SaldoPakar>> getSaldoPakar({required String idPengguna}) async {
    try {
      FormData formData = FormData.fromMap({
        "idPengguna": idPengguna,
      });

      Response response =
          await _dio.post("pakar/getSaldoPakar", data: formData);
      if (response.statusCode == 200) {
        var getData = response.data as List;
        var listData = getData.map((e) => SaldoPakar.fromJSON(e)).toList();
        return listData;
      } else {
        return throw Exception("Failed to load Saldo Pakar");
      }
    } catch (e) {
      return throw Exception(e);
    }
  }

  Future<List<Kategori>> getKategoriById({required String idKategori}) async {
    FormData formdata = FormData.fromMap({"idKategori": idKategori});
    try {
      Response response =
          await _dio.post("pakar/getKategoriById", data: formdata);
      if (response.statusCode == 200) {
        var getData = response.data as List;
        var listData = getData.map((e) => Kategori.fromJson(e)).toList();
        return listData;
      } else {
        return throw Exception("Failed to load Kategori");
      }
    } catch (e) {
      return throw Exception(e);
    }
  }

  Future<List<Kategori>> getKategori({required int offset}) async {
    FormData formdata = FormData.fromMap({"offset": offset});
    try {
      Response response = await _dio.post("pakar/getKategori", data: formdata);
      if (response.statusCode == 200) {
        var getData = response.data as List;
        var listData = getData.map((e) => Kategori.fromJson(e)).toList();
        return listData;
      } else {
        return throw Exception("Failed to load Kategori");
      }
    } catch (e) {
      return throw Exception(e);
    }
  }

  Future<List<Kategori>> cariKategori({String? query}) async {
    FormData formData = FormData.fromMap({
      "key": query,
    });

    try {
      Response response = await _dio.post("pakar/cariKategori", data: formData);
      if (response.statusCode == 200) {
        var getData = response.data as List;
        var listData = getData.map((e) => Kategori.fromJson(e)).toList();
        return listData;
      } else {
        return throw Exception("Failed to load Kategori");
      }
    } catch (e) {
      return throw Exception(e);
    }
  }

  Future<List<Klasifikasi>> getKlasifikasiAdminById(
      {required String idKlasifikasi}) async {
    FormData formData = FormData.fromMap({
      "idKlasifikasi": idKlasifikasi,
    });

    try {
      Response response = await _dio.post(
        "pakar/getKlasifikasiAdminById",
        data: formData,
      );

      if (response.statusCode == 200) {
        var getData = response.data as List;
        var listData = getData.map((e) => Klasifikasi.fromJSON(e)).toList();
        return listData;
      } else {
        return throw Exception("Failed to load Klasifikasi");
      }
    } catch (e) {
      return throw Exception(formData);
    }
  }

  Future<List<Klasifikasi>> getKlasifikasiPakar(
      {required String idKategori, required String idPengguna}) async {
    FormData formData = FormData.fromMap({
      "idKategori": idKategori,
      "idPengguna": idPengguna,
    });

    try {
      Response response = await _dio.post(
        "pakar/getKlasifikasiPakar",
        data: formData,
      );

      if (response.statusCode == 200) {
        var getData = response.data as List;
        var listData = getData.map((e) => Klasifikasi.fromJSON(e)).toList();
        return listData;
      } else {
        return throw Exception("Failed to load Klasifikasi");
      }
    } catch (e) {
      return throw Exception(formData);
    }
  }

  Future<List<Klasifikasi>> getKlasifikasiPakarCari(
      {required String idKategori,
      required String idPengguna,
      String? query}) async {
    FormData formData = FormData.fromMap({
      "idKategori": idKategori,
      "idPengguna": idPengguna,
      "key": query,
    });

    try {
      Response response = await _dio.post(
        "pakar/getKlasifikasiPakarCari",
        data: formData,
      );

      if (response.statusCode == 200) {
        var getData = response.data as List;
        var listData = getData.map((e) => Klasifikasi.fromJSON(e)).toList();
        return listData;
      } else {
        return throw Exception("Failed to load Klasifikasi");
      }
    } catch (e) {
      return throw Exception(formData);
    }
  }

  Future<List<MemberKlasifikasi>> getSuggestionKlasifikasi(
      {required String idKategori, required String query}) async {
    try {
      FormData formData = FormData.fromMap({
        "idKategori": idKategori,
        "key": query,
      });

      Response response = await _dio.post(
        "pakar/getKlasifikasiMemberCari",
        data: formData,
      );

      if (response.statusCode == 200) {
        final List getData = response.data;

        return getData
            .map((json) => MemberKlasifikasi.fromJSON(json))
            .where((kategori) {
          final nameLower = kategori.namaKlasifikasi.toLowerCase();
          final queryLower = query.toLowerCase();

          return nameLower.contains(queryLower);
        }).toList();
      } else {
        throw Exception("Failed to load Data");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<MemberKlasifikasi>> getKlasifikasiById(
      {required String idKlasifikasi}) async {
    FormData formData = FormData.fromMap({
      "idKlasifikasi": idKlasifikasi,
    });

    try {
      Response response = await _dio.post(
        "pakar/getKlasifikasiById",
        data: formData,
      );

      if (response.statusCode == 200) {
        var getData = response.data as List;
        var listData =
            getData.map((e) => MemberKlasifikasi.fromJSON(e)).toList();
        return listData;
      } else {
        return throw Exception("Failed to load Klasifikasi Member By ID");
      }
    } catch (e) {
      return throw Exception(e);
    }
  }

  Future<List<MemberKlasifikasi>> getKlasifikasiMember(
      {required String idKategori}) async {
    FormData formData = FormData.fromMap({
      "idKategori": idKategori,
    });

    try {
      Response response = await _dio.post(
        "pakar/getKlasifikasiMember",
        data: formData,
      );

      if (response.statusCode == 200) {
        var getData = response.data as List;
        var listData =
            getData.map((e) => MemberKlasifikasi.fromJSON(e)).toList();
        return listData;
      } else {
        return throw Exception("Failed to load Klasifikasi Member");
      }
    } catch (e) {
      return throw Exception(e);
    }
  }

  Future<List<MemberKlasifikasi>> getKlasifikasiMemberCari(
      {required String idKategori, String? query}) async {
    FormData formData = FormData.fromMap({
      "idKategori": idKategori,
      "key": query,
    });

    try {
      Response response = await _dio.post(
        "pakar/getKlasifikasiMemberCari",
        data: formData,
      );

      if (response.statusCode == 200) {
        var getData = response.data as List;
        var listData =
            getData.map((e) => MemberKlasifikasi.fromJSON(e)).toList();
        return listData;
      } else {
        return throw Exception("Failed to load Klasifikasi Member");
      }
    } catch (e) {
      return throw Exception(e);
    }
  }

  Future<List<Klasifikasi>> getKlasifikasi({required String idKategori}) async {
    FormData formData = FormData.fromMap({
      "idKategori": idKategori,
    });

    try {
      Response response = await _dio.post(
        "pakar/getKlasifikasi",
        data: formData,
      );

      if (response.statusCode == 200) {
        var getData = response.data as List;
        var listData = getData.map((e) => Klasifikasi.fromJSON(e)).toList();
        return listData;
      } else {
        return throw Exception("Failed to load Klasifikasi");
      }
    } catch (e) {
      return throw Exception(formData);
    }
  }

  Future<List<Klasifikasi>> cariKlasifikasi(
      {required String idKategori, String? query}) async {
    FormData formData = FormData.fromMap({
      "idKategori": idKategori,
      "key": query,
    });

    try {
      Response response = await _dio.post(
        "pakar/cariKlasifikasi",
        data: formData,
      );

      if (response.statusCode == 200) {
        var getData = response.data as List;
        var listData = getData.map((e) => Klasifikasi.fromJSON(e)).toList();
        return listData;
      } else {
        return throw Exception("Failed to load Klasifikasi");
      }
    } catch (e) {
      return throw Exception(formData);
    }
  }

  Future<List<KlasifikasiAdmin>> getKlasifikasiAdmin(
      {required String status}) async {
    FormData formData = FormData.fromMap({
      "status": status,
    });

    try {
      Response response = await _dio.post(
        "pakar/getKlasifikasiAdmin",
        data: formData,
      );

      if (response.statusCode == 200) {
        var getData = response.data as List;
        var listData =
            getData.map((e) => KlasifikasiAdmin.fromJSON(e)).toList();
        return listData;
      } else {
        return throw Exception("Failed to load Klasifikasi Admin");
      }
    } catch (e) {
      return throw Exception(e);
    }
  }

  Future<List<KlasifikasiAdmin>> getKlasifikasiAdminCari(
      {required String status, String? query}) async {
    FormData formData = FormData.fromMap({
      "status": status,
      "key": query,
    });

    try {
      Response response = await _dio.post(
        "pakar/getKlasifikasiAdminCari",
        data: formData,
      );

      if (response.statusCode == 200) {
        var getData = response.data as List;
        var listData =
            getData.map((e) => KlasifikasiAdmin.fromJSON(e)).toList();
        return listData;
      } else {
        return throw Exception("Failed to load Klasifikasi Admin Cari");
      }
    } catch (e) {
      return throw Exception(e);
    }
  }
}
