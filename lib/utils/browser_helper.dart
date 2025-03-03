import 'dart:js_interop';

@JS('eval')
external void eval(String code);

void browserHistoryBack() {
  eval("history.back();");
}

void blockBrowserBackButton() {
  eval("""
    history.pushState(null, '', document.URL);
    window.addEventListener('popstate', function(event) {
      history.pushState(null, '', document.URL);
    });
  """);
}
