part of '../tdapi.dart';

class ChatInviteLinkCount extends TdObject {
  /// Describes a chat administrator with a number of active and revoked chat invite links
  ChatInviteLinkCount(
      {this.userId, this.inviteLinkCount, this.revokedInviteLinkCount});

  /// [userId] Administrator's user identifier
  int userId;

  /// [inviteLinkCount] Number of active invite links
  int inviteLinkCount;

  /// [revokedInviteLinkCount] Number of revoked invite links
  int revokedInviteLinkCount;

  /// Parse from a json
  ChatInviteLinkCount.fromJson(Map<String, dynamic> json) {
    this.userId = json['user_id'];
    this.inviteLinkCount = json['invite_link_count'];
    this.revokedInviteLinkCount = json['revoked_invite_link_count'];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "@type": CONSTRUCTOR,
      "user_id": this.userId,
      "invite_link_count": this.inviteLinkCount,
      "revoked_invite_link_count": this.revokedInviteLinkCount,
    };
  }

  static const CONSTRUCTOR = 'chatInviteLinkCount';

  @override
  String getConstructor() => CONSTRUCTOR;
}
