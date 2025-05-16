// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Character _$CharacterFromJson(Map<String, dynamic> json) => Character(
      characterId: (json['characterId'] as num).toInt(),
      character: json['character'] as String,
      audio: json['audio'] as String,
      sound: json['sound'] as String,
      characterType: (json['characterType'] as num).toInt(),
      image: json['image'] as String,
      characterClass: json['characterClass'] as String,
      highLow: json['highLow'] as String?,
      prePost: json['prePost'] as String?,
      regEx: json['regEx'] as String?,
    );

Map<String, dynamic> _$CharacterToJson(Character instance) => <String, dynamic>{
      'characterId': instance.characterId,
      'character': instance.character,
      'audio': instance.audio,
      'image': instance.image,
      'sound': instance.sound,
      'characterType': instance.characterType,
      'highLow': instance.highLow,
      'prePost': instance.prePost,
      'characterClass': instance.characterClass,
      'regEx': instance.regEx,
    };
