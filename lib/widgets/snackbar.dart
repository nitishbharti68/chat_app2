import 'package:flutter/material.dart';

showSnackBar(BuildContext context, String text){
  return ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text(' User not found'))
  );
}