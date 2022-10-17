class HTTPException implements Exception {
  final String message;
  HTTPException(this.message);
}

class Forbidden extends HTTPException {
  Forbidden(String message) : super(message);
}

class NotFound extends HTTPException {
  NotFound(String message) : super(message);
}

class InternalServerError extends HTTPException {
  InternalServerError(String message) : super(message);
}

class BadRequest extends HTTPException {
  BadRequest(String message) : super(message);
}

class Unauthorized extends HTTPException {
  Unauthorized(String message) : super(message);
}

class TooManyRequests extends HTTPException {
  TooManyRequests(String message) : super(message);
}

class RuntimeError extends HTTPException {
  RuntimeError(String message) : super(message);
}
