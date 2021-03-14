part of '../tdapi.dart';

class ChatInviteLink extends TdObject {
  /// Contains a chat invite link
  ChatInviteLink(
      {this.inviteLink,
      this.creatorUserId,
      this.date,
      this.editDate,
      this.expireDate,
      this.memberLimit,
      this.memberCount,
      this.isPrimary,
      this.isRevoked});

  /// [inviteLink] Chat invite link
  String inviteLink;

  /// [creatorUserId] User identifier of an administrator created the link
  int creatorUserId;

  /// [date] Point in time (Unix timestamp) when the link was created
  int date;

  /// [editDate] Point in time (Unix timestamp) when the link was last edited; 0 if never or unknown
  int editDate;

  /// [expireDate] Point in time (Unix timestamp) when the link will expire; 0 if never
  int expireDate;

  /// [memberLimit] Maximum number of members, which can join the chat using the link simultaneously; 0 if not limited
  int memberLimit;

  /// [memberCount] Number of chat members, which joined the chat using the link
  int memberCount;

  /// [isPrimary] True, if the link is primary. Primary invite link can't have expire date or usage limit. There is exactly one primary invite link for each administrator with can_invite_users right at a given time
  bool isPrimary;

  /// [isRevoked] True, if the link was revoked
  bool isRevoked;

  /// callback sign
  dynamic extra;

  /// Parse from a json
  ChatInviteLink.fromJson(Map<String, dynamic> json) {
    this.inviteLink = json['invite_link'];
    this.creatorUserId = json['creator_user_id'];
    this.date = json['date'];
    this.editDate = json['edit_date'];
    this.expireDate = json['expire_date'];
    this.memberLimit = json['member_limit'];
    this.memberCount = json['member_count'];
    this.isPrimary = json['is_primary'];
    this.isRevoked = json['is_revoked'];
    this.extra = json['@extra'];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "@type": CONSTRUCTOR,
      "invite_link": this.inviteLink,
      "creator_user_id": this.creatorUserId,
      "date": this.date,
      "edit_date": this.editDate,
      "expire_date": this.expireDate,
      "member_limit": this.memberLimit,
      "member_count": this.memberCount,
      "is_primary": this.isPrimary,
      "is_revoked": this.isRevoked,
    };
  }

  static const CONSTRUCTOR = 'chatInviteLink';

  @override
  String getConstructor() => CONSTRUCTOR;
}
