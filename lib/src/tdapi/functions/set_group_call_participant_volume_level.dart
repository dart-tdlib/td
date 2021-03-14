part of '../tdapi.dart';

class SetGroupCallParticipantVolumeLevel extends TdFunction {
  /// Changes a group call participant's volume level. If the current user can manage the group call, then the participant's volume level will be changed for all users with default volume level
  SetGroupCallParticipantVolumeLevel(
      {this.groupCallId, this.userId, this.volumeLevel});

  /// [groupCallId] Group call identifier
  int groupCallId;

  /// [userId] User identifier
  int userId;

  /// [volumeLevel] New participant's volume level; 1-20000 in hundreds of percents
  int volumeLevel;

  /// callback sign
  dynamic extra;

  /// Parse from a json
  SetGroupCallParticipantVolumeLevel.fromJson(Map<String, dynamic> json);

  @override
  Map<String, dynamic> toJson() {
    return {
      "@type": CONSTRUCTOR,
      "group_call_id": this.groupCallId,
      "user_id": this.userId,
      "volume_level": this.volumeLevel,
      "@extra": this.extra,
    };
  }

  static const CONSTRUCTOR = 'setGroupCallParticipantVolumeLevel';

  @override
  String getConstructor() => CONSTRUCTOR;
}
