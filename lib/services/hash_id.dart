import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

Future<String> getHashedUserId() async{
  final prefs=await SharedPreferences.getInstance();

  String? existingId=prefs.getString('hashed_user');
  if(existingId != null) return existingId;
  final rawId=DateTime.now().millisecondsSinceEpoch.toString()+UniqueKey().toString();
  final bytes=utf8.encode(rawId);
  final hash=sha256.convert(bytes).toString();

  await prefs.setString('hashed_user',hash);
  return hash;
  
}