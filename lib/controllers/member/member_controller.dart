import 'package:dio/dio.dart';
import 'package:tanyapakar/api/apiutils.dart';
import 'package:tanyapakar/model/klasifikasi/member_klasifikasi_model.dart';

class MemberController {
  ApiUtils apiUtils = ApiUtils();

  Future<List<MemberKlasifikasi>> getKlasifikasiMember(
      {required String idKategori}) async {
    FormData formData = FormData.fromMap({
      "idKategori": idKategori,
    });

    try {
      Response response = await apiUtils.getDataService().post(
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
}
