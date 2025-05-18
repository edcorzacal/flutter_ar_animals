import 'package:flutter/material.dart';

class Developer {
  final String name;
  final String role;
  final String about;
  final String email;
  final String github;
  final String facebook;
  final String instagram;
  final Color color;

  const Developer({
    required this.name,
    required this.role,
    required this.about,
    required this.email,
    required this.github,
    required this.facebook, 
    required this.instagram,
    this.color = const Color(0xFF2C3E50),
  });
}
