part of '../tdapi.dart';

class ChatInviteLinks extends TdObject {
  /// Contains a list of chat invite links
  ChatInviteLinks({this.totalCount, this.inviteLinks});

  /// [totalCount] Approximate total count of chat invite links found
  int totalCount;

  /// [inviteLinks] List of invite links
  List<ChatInviteLink> inviteLinks;

  /// callback sign
  dynamic extra;

  /// Parse from a json
  ChatInviteLinks.fromJson(Map<String, dynamic> json) {
    this.totalCount = json['total_count'];
    this.inviteLinks = List<ChatInviteLink>.from((json['invite_links'] ?? [])
        .map((item) => ChatInviteLink.fromJson(item ?? <String, dynamic>{}))
        .toList());
    this.extra = json['@extra'];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "@type": CONSTRUCTOR,
      "total_count": this.totalCount,
      "invite_links": this.inviteLinks.map((i) => i.toJson()).toList(),
    };
  }

  static const CONSTRUCTOR = 'chatInviteLinks';

  @override
  String getConstructor() => CONSTRUCTOR;
}
