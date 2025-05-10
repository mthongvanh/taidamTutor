// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Character _$CharacterFromJson(Map<String, dynamic> json) => Character(
      characterId: (json['characterId'] as num).toInt(),
      character: json['character'] as String,
      audioFile: json['audioFile'] as String,
      sound: json['sound'] as String,
      characterType: (json['characterType'] as num).toInt(),
      imageFile: json['svg'] as String,
      highLow: json['highLow'] as String?,
      prePost: json['prePost'] as String?,
    );

Map<String, dynamic> _$CharacterToJson(Character instance) => <String, dynamic>{
      'characterId': instance.characterId,
      'character': instance.character,
      'audioFile': instance.audioFile,
      'svg': instance.imageFile,
      'sound': instance.sound,
      'characterType': instance.characterType,
      'highLow': instance.highLow,
      'prePost': instance.prePost,
    };
