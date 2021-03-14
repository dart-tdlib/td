part of '../tdapi.dart';

class GroupCallParticipant extends TdObject {
  /// Represents a group call participant
  GroupCallParticipant(
      {this.userId,
      this.source,
      this.isSpeaking,
      this.canBeMutedForAllUsers,
      this.canBeUnmutedForAllUsers,
      this.canBeMutedForCurrentUser,
      this.canBeUnmutedForCurrentUser,
      this.isMutedForAllUsers,
      this.isMutedForCurrentUser,
      this.canUnmuteSelf,
      this.volumeLevel,
      this.order});

  /// [userId] Identifier of the user
  int userId;

  /// [source] User's synchronization source
  int source;

  /// [isSpeaking] True, if the participant is speaking as set by setGroupCallParticipantIsSpeaking
  bool isSpeaking;

  /// [canBeMutedForAllUsers] True, if the current user can mute the participant for all other group call participants
  bool canBeMutedForAllUsers;

  /// [canBeUnmutedForAllUsers] True, if the current user can allow the participant to unmute themself or unmute the participant (if the participant is the current user)
  bool canBeUnmutedForAllUsers;

  /// [canBeMutedForCurrentUser] True, if the current user can mute the participant only for self
  bool canBeMutedForCurrentUser;

  /// [canBeUnmutedForCurrentUser] True, if the current user can unmute the participant for self
  bool canBeUnmutedForCurrentUser;

  /// [isMutedForAllUsers] True, if the participant is muted for all users
  bool isMutedForAllUsers;

  /// [isMutedForCurrentUser] True, if the participant is muted for the current user
  bool isMutedForCurrentUser;

  /// [canUnmuteSelf] True, if the participant is muted for all users, but can unmute themself
  bool canUnmuteSelf;

  /// [volumeLevel] Participant's volume level; 1-20000 in hundreds of percents
  int volumeLevel;

  /// [order] User's order in the group call participant list. The bigger is order, the higher is user in the list. If order is 0, the user must be removed from the participant list
  int order;

  /// Parse from a json
  GroupCallParticipant.fromJson(Map<String, dynamic> json) {
    this.userId = json['user_id'];
    this.source = json['source'];
    this.isSpeaking = json['is_speaking'];
    this.canBeMutedForAllUsers = json['can_be_muted_for_all_users'];
    this.canBeUnmutedForAllUsers = json['can_be_unmuted_for_all_users'];
    this.canBeMutedForCurrentUser = json['can_be_muted_for_current_user'];
    this.canBeUnmutedForCurrentUser = json['can_be_unmuted_for_current_user'];
    this.isMutedForAllUsers = json['is_muted_for_all_users'];
    this.isMutedForCurrentUser = json['is_muted_for_current_user'];
    this.canUnmuteSelf = json['can_unmute_self'];
    this.volumeLevel = json['volume_level'];
    this.order = int.tryParse(json['order'] ?? "");
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "@type": CONSTRUCTOR,
      "user_id": this.userId,
      "source": this.source,
      "is_speaking": this.isSpeaking,
      "can_be_muted_for_all_users": this.canBeMutedForAllUsers,
      "can_be_unmuted_for_all_users": this.canBeUnmutedForAllUsers,
      "can_be_muted_for_current_user": this.canBeMutedForCurrentUser,
      "can_be_unmuted_for_current_user": this.canBeUnmutedForCurrentUser,
      "is_muted_for_all_users": this.isMutedForAllUsers,
      "is_muted_for_current_user": this.isMutedForCurrentUser,
      "can_unmute_self": this.canUnmuteSelf,
      "volume_level": this.volumeLevel,
      "order": this.order,
    };
  }

  static const CONSTRUCTOR = 'groupCallParticipant';

  @override
  String getConstructor() => CONSTRUCTOR;
}
