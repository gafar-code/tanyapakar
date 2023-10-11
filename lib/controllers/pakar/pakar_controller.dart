import 'package:dio/dio.dart';
import 'package:tanyapakar/api/apiutils.dart';
import 'package:tanyapakar/model/klasifikasi/klasifikasi_model.dart';
import 'package:tanyapakar/model/pakar/kategori_pakar_model.dart';

class PakarController {
  ApiUtils apiUtils = ApiUtils();

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
      Response response = await apiUtils.getDataService().post(
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

  Future<List<MyKategori>> getMyKategori({required String idPengguna}) async {
    try {
      FormData formData = FormData.fromMap({
        "idPengguna": idPengguna,
      });

      Response response = await apiUtils
          .getDataService()
          .post("pakar/myKategori", data: formData);
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

  Future<List<MyKategori>> getMyKategoriCari(
      {required String idPengguna, String? query}) async {
    try {
      FormData formData = FormData.fromMap({
        "idPengguna": idPengguna,
        "key": query,
      });

      Response response = await apiUtils
          .getDataService()
          .post("pakar/cariMyKategori", data: formData);
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
}
