import 'package:flutter/material.dart';

class Animal {
  final String name;
  final String letter;
  final String habitat;
  final String description;
  final String diet;
  final String modelUri;
  final Color color;

  const Animal({
    required this.name,
    required this.letter,
    required this.habitat,
    required this.description,
    required this.diet,
    required this.modelUri,
    required this.color,
  });
}
