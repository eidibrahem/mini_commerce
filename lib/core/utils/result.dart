import '../error/failures.dart';

abstract class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure;

  T? get data => isSuccess ? (this as Success<T>).data : null;
  Failure? get failure => isFailure ? (this as Failure) : null;

  Result<R> map<R>(R Function(T data) transform) {
    if (isSuccess) {
      return Success(transform(data as T));
    } else {
      return failure! as Result<R>;
    }
  }

  Result<R> flatMap<R>(Result<R> Function(T data) transform) {
    if (isSuccess) {
      return transform(data as T);
    } else {
      return failure! as Result<R>;
    }
  }

  T getOrElse(T Function() defaultValue) {
    if (isSuccess) {
      return data!;
    } else {
      return defaultValue();
    }
  }

  void when({
    required void Function(T data) success,
    required void Function(Failure failure) failure,
  }) {
    if (isSuccess) {
      success(data as T);
    } else {
      failure(this.failure!);
    }
  }
}

class Success<T> extends Result<T> {
  @override
  final T data;
  const Success(this.data);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T> &&
          runtimeType == other.runtimeType &&
          data == other.data;

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => 'Success($data)';
}

class FailureResult<T> extends Result<T> {
  @override
  final Failure failure;
  const FailureResult(this.failure);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FailureResult<T> &&
          runtimeType == other.runtimeType &&
          failure == other.failure;

  @override
  int get hashCode => failure.hashCode;

  @override
  String toString() => 'FailureResult($failure)';
}
