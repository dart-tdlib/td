part of '../tdapi.dart';

class JoinChatByInviteLink extends TdFunction {
  /// Uses an invite link to add the current user to the chat if possible
  JoinChatByInviteLink({this.inviteLink});

  /// [inviteLink] Invite link to import; must have URL "t.me", "telegram.me", or "telegram.dog" and query beginning with "/joinchat/" or "/+"
  String inviteLink;

  /// callback sign
  dynamic extra;

  /// Parse from a json
  JoinChatByInviteLink.fromJson(Map<String, dynamic> json);

  @override
  Map<String, dynamic> toJson() {
    return {
      "@type": CONSTRUCTOR,
      "invite_link": this.inviteLink,
      "@extra": this.extra,
    };
  }

  static const CONSTRUCTOR = 'joinChatByInviteLink';

  @override
  String getConstructor() => CONSTRUCTOR;
}
