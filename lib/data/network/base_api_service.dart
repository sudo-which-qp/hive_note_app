abstract class BaseApiService {

  Future<dynamic> getApi({String? requestEnd, Map<String, dynamic>? queryParams});

  Future<dynamic> postApi({String requestEnd, Map<String?, String?>? params});

  Future<dynamic> deleteApi(String url);

}