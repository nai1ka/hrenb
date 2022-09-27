import 'package:flutter/material.dart';

class Pattern{
  String name;
  IconData icon;
  Patterns id;
  Pattern(this.id,this.name, this.icon);
}
enum Patterns{
  CIRCLE,HEART
}