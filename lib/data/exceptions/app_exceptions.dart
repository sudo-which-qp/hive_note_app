/// Base class for custom application exceptions.
class AppExceptions implements Exception {
  final _message; // Message associated with the exception
  final _prefix; // Prefix for the exception

  /// Constructor for creating a [NoInternAppExceptionsetException] instance.
  ///
  /// the [message] parameter represents the message associated with the exception.
  /// the [prefix] parameter represents the prefix for the exception.
  AppExceptions([this._message, this._prefix]);

  @override
  String toString() {
    return _message?.toString() ?? _prefix;
  }
}

/// Exception class representing a no internet connection error.
class NoInternetException extends AppExceptions {
  /// Constructor for creating a [NoInternetException] instance.
  ///
  /// the [message] parameter represents the error message.
  NoInternetException([String? message])
      : super(message, 'No Internet Connection.');
}

/// Exception class representing a n unauthorized access error.
class UnauthorisedException extends AppExceptions {
  /// Constructor for creating a [UnauthorisedException] instance.
  ///
  /// the [message] parameter represents the error message.
  UnauthorisedException([String? message])
      : super(message, 'You do not have access to this.');
}

/// Exception class representing network request timing out error.
class RequestTimeOutException extends AppExceptions {
  /// Constructor for creating a [RequestTimeOutException] instance.
  ///
  /// the [message] parameter represents the error message.
  RequestTimeOutException([String? message])
      : super(message, 'Request Time Out.');
}

/// Exception class representing a data fetching error during communication.
class FetchDataException extends AppExceptions {
  /// Constructor for creating a [FetchDataException] instance.
  ///
  /// the [message] parameter represents the error message.
  FetchDataException([String? message]) : super(message, '');
}

/// Exception class representing an Invalid input error.
class InvalidInputException extends AppExceptions {
  /// Constructor for creating a [InvalidInputException] instance.
  ///
  /// the [message] parameter represents the error message.
  InvalidInputException([String? message]) : super(message, 'Invalid Input');
}

/// Exception class representing a bad request error.
class BadRequestException extends AppExceptions {
  /// Constructor for creating a [BadRequestException] instance.
  ///
  /// the [message] parameter represents the error message.
  BadRequestException([String? message]) : super(message, 'Invalid Request');
}