part of '../tdapi.dart';

class ImportMessages extends TdFunction {
  /// Imports messages exported from another app
  ImportMessages({this.chatId, this.messageFile, this.attachedFiles});

  /// [chatId] Identifier of a chat to which the messages will be imported. It must be an identifier of a private chat with a mutual contact or an identifier of a supergroup chat with can_change_info administrator right
  int chatId;

  /// [messageFile] File with messages to import. Only inputFileLocal and inputFileGenerated are supported. The file must not be previously uploaded
  InputFile messageFile;

  /// [attachedFiles] Files used in the imported messages. Only inputFileLocal and inputFileGenerated are supported. The files must not be previously uploaded
  List<InputFile> attachedFiles;

  /// callback sign
  dynamic extra;

  /// Parse from a json
  ImportMessages.fromJson(Map<String, dynamic> json);

  @override
  Map<String, dynamic> toJson() {
    return {
      "@type": CONSTRUCTOR,
      "chat_id": this.chatId,
      "message_file":
          this.messageFile == null ? null : this.messageFile.toJson(),
      "attached_files": this.attachedFiles.map((i) => i.toJson()).toList(),
      "@extra": this.extra,
    };
  }

  static const CONSTRUCTOR = 'importMessages';

  @override
  String getConstructor() => CONSTRUCTOR;
}
