part of '../tdapi.dart';

class DeleteRevokedChatInviteLink extends TdFunction {
  /// Deletes revoked chat invite links. Requires administrator privileges and can_invite_users right in the chat for own links and owner privileges for other links
  DeleteRevokedChatInviteLink({this.chatId, this.inviteLink});

  /// [chatId] Chat identifier
  int chatId;

  /// [inviteLink] Invite link to revoke
  String inviteLink;

  /// callback sign
  dynamic extra;

  /// Parse from a json
  DeleteRevokedChatInviteLink.fromJson(Map<String, dynamic> json);

  @override
  Map<String, dynamic> toJson() {
    return {
      "@type": CONSTRUCTOR,
      "chat_id": this.chatId,
      "invite_link": this.inviteLink,
      "@extra": this.extra,
    };
  }

  static const CONSTRUCTOR = 'deleteRevokedChatInviteLink';

  @override
  String getConstructor() => CONSTRUCTOR;
}
