import 'dart:html' as html;

class ImportJsLibrary {

  void importJsLibrary({required String url, String? flutterPluginName}) {
    if (flutterPluginName == null) {
      _importJSLibraries([url]);
    } else {
      _importJSLibraries([_libraryUrl(url, flutterPluginName)]);
    }
  }
  /// Injects the library by its [url]
  void import(String content, String id) {
    if (!_isLoaded(id)) {
      final scriptTag = _createScriptTag(content, id);
      head.children.add(scriptTag);
    }
  }

  html.Element get head {
    html.Element? head = html.document.head;
    if (head == null) {
      head = html.document.createElement("head");
      html.document.append(head);
    }
    return head;
  }

  String _libraryUrl(String url, String pluginName) {
    if (url.startsWith('./')) {
      url = url.replaceFirst('./', '');
      return './assets/packages/$pluginName/$url';
    }
    if (url.startsWith('assets/')) {
      return './assets/packages/$pluginName/$url';
    } else {
      return url;
    }
  }

  html.ScriptElement _createJSScriptTag(String library) {
    final script = html.ScriptElement()
      ..type = 'text/javascript'
      ..charset = 'utf-8'
      ..async = true
      ..src = library;
    return script;
  }

  html.ScriptElement _createScriptTag(String content, String id) {
    final html.ScriptElement script = html.ScriptElement()
      ..type = "text/javascript"
      ..charset = "utf-8"
      ..id = id
      ..innerHtml = content;
    return script;
  }

  bool _isLoaded(String id) {
    for (var element in head.children) {
      if (element is html.ScriptElement) {
        if (element.id == id) {
          return true;
        }
      }
    }
    return false;
  }

  /// Injects a bunch of libraries in the <head> and returns a
  /// Future that resolves when all load.
  Future<void> _importJSLibraries(List<String> libraries) {
    final loading = <Future<void>>[];
    final head = html.querySelector('head');

    for (final library in libraries) {
      if (!_isImported(library)) {
        final scriptTag = _createJSScriptTag(library);
        head!.children.add(scriptTag);
        loading.add(scriptTag.onLoad.first);
      }
    }

    return Future.wait(loading);
  }

  bool _isImported(String url) {
    final head = html.querySelector('head')!;
    return _isLoadedScript(head, url);
  }

  bool _isLoadedScript(html.Element head, String url) {
    if (url.startsWith('./')) {
      url = url.replaceFirst('./', '');
    }
    for (var element in head.children) {
      if (element is html.ScriptElement) {
        if (element.src.endsWith(url)) {
          return true;
        }
      }
    }
    return false;
  }

}
