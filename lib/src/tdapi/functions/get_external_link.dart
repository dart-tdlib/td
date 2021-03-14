part of '../tdapi.dart';

class GetExternalLink extends TdFunction {
  /// Returns an HTTP URL to open when user clicks on a given HTTP link. This method can be used to automatically login user on a Telegram site
  GetExternalLink({this.link});

  /// [link] The HTTP link
  String link;

  /// callback sign
  dynamic extra;

  /// Parse from a json
  GetExternalLink.fromJson(Map<String, dynamic> json);

  @override
  Map<String, dynamic> toJson() {
    return {
      "@type": CONSTRUCTOR,
      "link": this.link,
      "@extra": this.extra,
    };
  }

  static const CONSTRUCTOR = 'getExternalLink';

  @override
  String getConstructor() => CONSTRUCTOR;
}
