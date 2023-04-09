typedef FormFieldValidator<T> = String? Function(T? value);

abstract class FieldValidator<T> {
  final String errorText;

  FieldValidator(this.errorText);

  bool isValid(T value);

  String? call(T value) {
    return isValid(value) ? null : errorText;
  }
}

abstract class TextFieldValidator extends FieldValidator<String?> {
  TextFieldValidator(String errorText) : super(errorText);

  bool get ignoreEmptyValues => true;

  @override
  String? call(String? value) {
    return (ignoreEmptyValues && value!.isEmpty) ? null : super.call(value);
  }

  bool hasMatch(String pattern, String input, {bool caseSensitive = true}) =>
      RegExp(pattern, caseSensitive: caseSensitive).hasMatch(input);
}

class UrlFileValidator extends TextFieldValidator {
  final String fileExtension;
  UrlFileValidator(super.errorText, this.fileExtension);

  @override
  bool isValid(String? value) {
    if (value == null) {
      return false;
    }
    if (value.isEmpty) {
      return false;
    }
    if (!value.contains('http')) {
      return false;
    }
    if (!value.contains('://')) {
      return false;
    }
    if (value.split('/').length < 3) {
      return false;
    }
    if (!value.split('/').elementAt(2).contains('.')) {
      return false;
    }
    if (!value.split('/').last.toLowerCase().contains('.${fileExtension.toLowerCase()}')) {
      return false;
    }
    return true;
  }
}