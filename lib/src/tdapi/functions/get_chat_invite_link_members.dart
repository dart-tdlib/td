part of '../tdapi.dart';

class GetChatInviteLinkMembers extends TdFunction {
  /// Returns chat members joined a chat by an invite link. Requires administrator privileges and can_invite_users right in the chat for own links and owner privileges for other links
  GetChatInviteLinkMembers(
      {this.chatId, this.inviteLink, this.offsetMember, this.limit});

  /// [chatId] Chat identifier
  int chatId;

  /// [inviteLink] Invite link for which to return chat members
  String inviteLink;

  /// [offsetMember] A chat member from which to return next chat members; use null to get results from the beginning
  ChatInviteLinkMember offsetMember;

  /// [limit] Maximum number of chat members to return
  int limit;

  /// callback sign
  dynamic extra;

  /// Parse from a json
  GetChatInviteLinkMembers.fromJson(Map<String, dynamic> json);

  @override
  Map<String, dynamic> toJson() {
    return {
      "@type": CONSTRUCTOR,
      "chat_id": this.chatId,
      "invite_link": this.inviteLink,
      "offset_member":
          this.offsetMember == null ? null : this.offsetMember.toJson(),
      "limit": this.limit,
      "@extra": this.extra,
    };
  }

  static const CONSTRUCTOR = 'getChatInviteLinkMembers';

  @override
  String getConstructor() => CONSTRUCTOR;
}
