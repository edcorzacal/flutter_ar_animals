import 'package:flutter/material.dart';
import '../models/developer.dart';
import '../widgets/developer_profile.dart';
import '../widgets/about_section.dart';
import '../widgets/contact_section.dart';

class TeamCreditsScreen extends StatelessWidget {
  const TeamCreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const developer = Developer(
        name: 'Edcor Zacal',
        role: 'BSIT Student',
        about:
            'This AR Animal Encyclopedia app was created as a demonstration of augmented reality capabilities in Flutter. The app allows users to explore various animals in AR, providing an interactive and educational experience.',
        email: 'edcorzacaliii@gmail.co ',
        github: 'github.com/edcorzacal',
        facebook: 'facebook.com/edcor.zacal.980',
        instagram: 'instagram.com/zacal_edcor');

    return Scaffold(
      appBar: AppBar(
        title: const Text('About Developer'),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(height: 24),
            const DeveloperProfile(developer: developer),
            const SizedBox(height: 32),
            AboutSection(about: developer.about),
            const SizedBox(height: 32),
            ContactSection(
              email: developer.email,
              github: developer.github,
              facebook: developer.facebook,
              instagram: developer.instagram,
            ),
          ],
        ),
      ),
    );
  }
}
