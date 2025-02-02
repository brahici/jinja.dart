/// Baseclass for all template errors.
abstract class TemplateError implements Exception {
  const TemplateError([this.message]);

  final String? message;

  @override
  String toString() {
    if (message == null) {
      return '$runtimeType';
    }

    return '$runtimeType: $message';
  }
}

/// Raised if a template does not exist.
class TemplateNotFound extends TemplateError {
  const TemplateNotFound({String? template, String? message})
      : super(message ?? template);
}

/// Like [TemplateNotFound] but raised if multiple templates are selected.
class TemplatesNotFound extends TemplateNotFound {
  TemplatesNotFound({List<Object?>? names, String? message})
      : super(message: message);
}

/// Raised to tell the user that there is a problem with the template.
class TemplateSyntaxError extends TemplateError {
  const TemplateSyntaxError(String message, {this.line, this.path})
      : super(message);

  final int? line;

  final String? path;

  @override
  String toString() {
    var result = runtimeType.toString();

    if (path != null) {
      if (result.contains(',')) {
        result += ', file: $path';
      }

      result += ' file: $path';
    }

    if (line != null) {
      if (result.contains(',')) {
        result += ', line: $line';
      } else {
        result += ' line: $line';
      }
    }

    return '$result: $message';
  }
}

/// Like a template syntax error, but covers cases where something in the
/// template caused an error at compile time that wasn't necessarily caused
/// by a syntax error.
///
/// However it's a direct subclass of [TemplateSyntaxError] and has the same
/// attributes.
class TemplateAssertionError extends TemplateError {
  const TemplateAssertionError([String? message]) : super(message);
}

/// A generic runtime error in the template engine.
///
/// Under some situations Jinja may raise this exception.
class TemplateRuntimeError extends TemplateError {
  const TemplateRuntimeError([String? message]) : super(message);
}

/// This error is raised if a filter was called with inappropriate arguments.
class FilterArgumentError extends TemplateRuntimeError {
  const FilterArgumentError([String? message]) : super(message);
}
