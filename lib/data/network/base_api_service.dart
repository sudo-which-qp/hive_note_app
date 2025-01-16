abstract class BaseApiService {
  Future<dynamic> getApi({
    String? requestEnd,
    Map<String, dynamic>? queryParams,
    String? bearer,
  });

  Future<dynamic> postApi({
    String requestEnd,
    Map<String?, String?>? params,
    String? bearer,
  });

  Future<dynamic> deleteApi(
    String url,
    String? bearer,
  );
}
