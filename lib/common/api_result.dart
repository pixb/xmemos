abstract class ApiResult<T> {
  void onSuccess(Function(T data) action);
  void onError(Function(String message) action);
}

class ApiSuccess<T> extends ApiResult<T> {
  final T data;
  ApiSuccess(this.data);

  @override
  void onSuccess(Function(T data) action) => action(data);
  @override
  void onError(Function(String message) action) {} // Do nothing
}

class ApiError<T> extends ApiResult<T> {
  final String message;
  ApiError(this.message);

  @override
  void onSuccess(Function(T data) action) {} // Do nothing
  @override
  void onError(Function(String message) action) => action(message);
}