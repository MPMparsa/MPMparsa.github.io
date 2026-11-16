import 'dart:ui';
import 'package:web/web.dart' as web;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:url_launcher/url_launcher.dart';

import 'games.dart' deferred as games;

// -----------------------------------------------------------------------------
// Portfolio theme
// -----------------------------------------------------------------------------
class AppColors {
  static const Color background = Color(0xFF0A192F);
  static const Color primary = Color(0xFF003B8E);
  static const Color secondary = Color(0xFF64FFDA);
  static const Color backgroundEnd = Color(0xFF112240);
  static const Color cardColor = Color(0xFF112240);
  static const Color textHeader = Color(0xFFCCD6F6);
  static const Color textBody = Color(0xFFB0BAD2);
  static const Color readableText = Color(0xFFE2E8F0);
}

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mohammad Parsa Malek | Bioelectric Engineer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.secondary,
          brightness: Brightness.dark,
          surface: AppColors.cardColor,
        ),
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: AppColors.textBody,
          displayColor: AppColors.textHeader,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textHeader,
        ),
      ),
      home: const ResumePage(),
    );
  }
}

// -----------------------------------------------------------------------------
// Main page and navigation
// -----------------------------------------------------------------------------
class ResumePage extends StatefulWidget {
  const ResumePage({super.key});

  @override
  State<ResumePage> createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> {
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _educationKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _certificatesKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  bool _heroImageLoaded = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() => _heroImageLoaded = true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollTo(GlobalKey key) {
    final BuildContext? targetContext = key.currentContext;
    if (targetContext == null) return;

    Scrollable.ensureVisible(
      targetContext,
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeInOutCubic,
      alignment: 0.04,
    );
  }

  void _navigateTo(String destination) {
    switch (destination) {
      case 'about':
        _scrollTo(_aboutKey);
        break;
      case 'experience':
        _scrollTo(_experienceKey);
        break;
      case 'education':
        _scrollTo(_educationKey);
        break;
      case 'projects':
        _scrollTo(_projectsKey);
        break;
      case 'skills':
        _scrollTo(_skillsKey);
        break;
      case 'certificates':
        _scrollTo(_certificatesKey);
        break;
      case 'contact':
        _scrollTo(_contactKey);
        break;
    }
  }

  Widget _navigationButton(String label, String destination) {
    return TextButton(
      onPressed: () => _navigateTo(destination),
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool compactNavigation = MediaQuery.of(context).size.width < 980;

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: AppColors.background.withAlpha(238),
        title: const Text(
          'Mohammad Parsa Malek',
          style: TextStyle(
            fontFamily: 'Parisienne',
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: AppColors.textHeader,
          ),
        ),
        actions: compactNavigation
            ? [
          PopupMenuButton<String>(
            tooltip: 'Navigate to section',
            icon: const Icon(Icons.menu, color: AppColors.secondary),
            onSelected: _navigateTo,
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'about', child: Text('About')),
              PopupMenuItem(
                  value: 'experience', child: Text('Experience')),
              PopupMenuItem(value: 'education', child: Text('Education')),
              PopupMenuItem(value: 'projects', child: Text('Projects')),
              PopupMenuItem(value: 'skills', child: Text('Skills')),
              PopupMenuItem(
                  value: 'certificates', child: Text('Certificates')),
              PopupMenuItem(value: 'contact', child: Text('Contact')),
            ],
          ),
          const SizedBox(width: 12),
        ]
            : [
          _navigationButton('About', 'about'),
          _navigationButton('Experience', 'experience'),
          _navigationButton('Education', 'education'),
          _navigationButton('Projects', 'projects'),
          _navigationButton('Skills', 'skills'),
          _navigationButton('Certificates', 'certificates'),
          _navigationButton('Contact', 'contact'),
          const SizedBox(width: 12),
        ],
      ),
      body: Stack(
        children: [
          const SiteWideImageBackground(),
          Center(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    HeaderWithDynamicBackground(
                      isImageLoaded: _heroImageLoaded,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal:
                        MediaQuery.of(context).size.width < 600 ? 20 : 40,
                        vertical: 58,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _section(
                            key: _aboutKey,
                            title: 'About Me',
                            child: const AboutSection(),
                          ),
                          const SizedBox(height: 76),
                          _section(
                            key: _experienceKey,
                            title: 'Work Experience',
                            child: const ExperienceSection(),
                          ),
                          const SizedBox(height: 76),
                          _section(
                            key: _educationKey,
                            title: 'Education',
                            child: const EducationSection(),
                          ),
                          const SizedBox(height: 76),
                          _section(
                            key: _projectsKey,
                            title: 'Selected Projects',
                            child: const ProjectsSection(),
                          ),
                          const SizedBox(height: 76),
                          _section(
                            key: _skillsKey,
                            title: 'Technical Skills',
                            child: const SkillsSection(),
                          ),
                          const SizedBox(height: 76),
                          _section(
                            key: _certificatesKey,
                            title: 'Certificates',
                            child: const CertificatesSection(),
                          ),
                          const SizedBox(height: 76),
                          _section(
                            key: _contactKey,
                            title: '',
                            child: const FooterSection(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _section({
    required GlobalKey key,
    required String title,
    required Widget child,
  }) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) SectionTitle(title: title),
        child,
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Background and hero
// -----------------------------------------------------------------------------
class SiteWideImageBackground extends StatelessWidget {
  const SiteWideImageBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/profile_background.jpg',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              Container(color: AppColors.background),
        ),
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(color: Colors.black.withAlpha(90)),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0.5, 0.35),
              radius: 0.95,
              colors: [
                Colors.transparent,
                Colors.black.withAlpha(190),
              ],
              stops: const [0.25, 1.0],
            ),
          ),
        ),
      ],
    );
  }
}

class HeaderWithDynamicBackground extends StatelessWidget {
  final bool isImageLoaded;

  const HeaderWithDynamicBackground({
    super.key,
    required this.isImageLoaded,
  });

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double heroHeight = screenWidth < 600
        ? 700
        : (screenHeight * 0.84 < 620 ? 620 : screenHeight * 0.84);

    return SizedBox(
      height: heroHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (isImageLoaded)
            Image.asset(
              'assets/images/profile_photo.jpg',
              fit: BoxFit.cover,
              alignment: const Alignment(0, -0.45),
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: AppColors.background),
            ).animate().fadeIn(duration: 1100.ms, curve: Curves.easeInOut)
          else
            Container(color: AppColors.background),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black87],
                stops: [0.35, 1],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth < 600 ? 24 : 48,
              vertical: 28,
            ),
            child: const HeroSection(),
          ),
        ],
      ),
    );
  }
}

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double titleSize = screenWidth < 600 ? 43 : 76;
    final double subtitleSize = screenWidth < 600 ? 19 : 27;

    return Align(
      alignment: Alignment.bottomLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 820),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 44),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mohammad Parsa Malek',
                style: TextStyle(
                  fontFamily: 'Parisienne',
                  fontSize: titleSize,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textHeader,
                  height: 1.12,
                ),
              ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.12),
              const SizedBox(height: 12),
              Text(
                'Bioelectric Engineer',
                style: TextStyle(
                  fontSize: subtitleSize,
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.12),
              const SizedBox(height: 18),
              const Text(
                'Biomedical engineering, embedded systems, biomedical machine learning, and circuit design.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.readableText,
                  fontWeight: FontWeight.w500,
                  height: 1.65,
                ),
              ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.12),
              const SizedBox(height: 28),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _launchUrl(
                      context,
                      'mailto:mohamadparsamalek.30@gmail.com',
                    ),
                    icon: const Icon(Icons.mail_outline),
                    label: const Text('Get in touch'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: AppColors.background,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 17,
                      ),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => _viewResume(context),
                    icon: const Icon(Icons.picture_as_pdf_outlined),
                    label: const Text('View CV'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textHeader,
                      side: const BorderSide(color: AppColors.secondary),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 17,
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 500.ms),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// About
// -----------------------------------------------------------------------------
class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardColor.withAlpha(225),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(
          MediaQuery.of(context).size.width < 600 ? 18 : 28,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bioelectric engineering student with interests in biomedical applications, biomedical signal processing, embedded-system design, and machine learning on embedded devices.',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.readableText,
                height: 1.7,
              ),
            )
                .animate()
                .fadeIn(delay: 100.ms, duration: 700.ms)
                .slideY(begin: 0.07, duration: 700.ms),
            const SizedBox(height: 24),
            const Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: AppColors.textHeader,
              ),
            )
                .animate()
                .fadeIn(delay: 220.ms, duration: 550.ms)
                .slideX(begin: -0.07, duration: 550.ms),
            const SizedBox(height: 12),
            const InfoRow(label: 'Location', value: 'Narmak, Tehran, Iran')
                .animate()
                .fadeIn(delay: 300.ms, duration: 480.ms)
                .slideX(begin: -0.04, duration: 480.ms),
            const InfoRow(label: 'Born', value: '2004, Tehran')
                .animate()
                .fadeIn(delay: 370.ms, duration: 480.ms)
                .slideX(begin: -0.04, duration: 480.ms),
            const InfoRow(label: 'Phone', value: '09900100336')
                .animate()
                .fadeIn(delay: 440.ms, duration: 480.ms)
                .slideX(begin: -0.04, duration: 480.ms),
            const InfoRow(
              label: 'Email',
              value: 'mohamadparsamalek.30@gmail.com',
            )
                .animate()
                .fadeIn(delay: 510.ms, duration: 480.ms)
                .slideX(begin: -0.04, duration: 480.ms),
            const InfoRow(
              label: 'Language',
              value: 'English — Upper Intermediate',
            )
                .animate()
                .fadeIn(delay: 580.ms, duration: 480.ms)
                .slideX(begin: -0.04, duration: 480.ms),
            const Divider(color: AppColors.textBody, height: 30),
            const Text(
              'Core Competencies',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: AppColors.textHeader,
              ),
            )
                .animate()
                .fadeIn(delay: 660.ms, duration: 550.ms)
                .slideX(begin: -0.07, duration: 550.ms),
            const SizedBox(height: 12),
            const SkillBullet(
              text: 'Embedded-system design and ARM microcontroller programming',
            )
                .animate()
                .fadeIn(delay: 740.ms, duration: 480.ms)
                .slideY(begin: 0.06, duration: 480.ms),
            const SkillBullet(
              text: 'PCB and analog-circuit design using Altium Designer',
            )
                .animate()
                .fadeIn(delay: 810.ms, duration: 480.ms)
                .slideY(begin: 0.06, duration: 480.ms),
            const SkillBullet(
              text: 'Machine-learning implementation using MATLAB and Python',
            )
                .animate()
                .fadeIn(delay: 880.ms, duration: 480.ms)
                .slideY(begin: 0.06, duration: 480.ms),
            const SkillBullet(
              text: 'Deployment of machine-learning algorithms on embedded systems',
            )
                .animate()
                .fadeIn(delay: 950.ms, duration: 480.ms)
                .slideY(begin: 0.06, duration: 480.ms),
            const SkillBullet(
              text: '3D surface reconstruction and biomedical signal processing',
            )
                .animate()
                .fadeIn(delay: 1020.ms, duration: 480.ms)
                .slideY(begin: 0.06, duration: 480.ms),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 650.ms).slideY(begin: 0.05);
  }
}

// -----------------------------------------------------------------------------
// Work experience
// -----------------------------------------------------------------------------
class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ExperienceTile(
          isFirst: true,
          company: 'SERL Lab — Dr. Mehdi Fardmanesh',
          title: 'Laboratory Work and Experimental Systems',
          period: 'October 2025 – Present | Tehran, Iran',
          description:
          'Working with PT100 temperature sensors, building and using microfluidic chips, and using a four-probe setup to measure unknown resistance precisely. Also working with CNC equipment for PCB fabrication.',
        )
            .animate()
            .fadeIn(delay: 80.ms, duration: 650.ms)
            .slideX(begin: -0.06, duration: 650.ms),
        const ExperienceTile(
          company: 'Parsiss — Navigation in Surgical Systems',
          title: 'Image Processing on 3D DICOM Images',
          period: 'June 2025 – October 2025 | Tehran, Iran',
          description:
          'Performed surface extraction on 3D DICOM images for surface registration in surgical navigation systems.',
          companyUrl: 'https://www.parsiss.com/',
        )
            .animate()
            .fadeIn(delay: 240.ms, duration: 650.ms)
            .slideX(begin: 0.06, duration: 650.ms),
        const ExperienceTile(
          isLast: true,
          company: 'Atieh Sazan',
          title: 'UI/UX Developer',
          period: 'July 2024 – December 2024 | Tehran, Iran',
          description: 'Five-month UI/UX development role.',
        )
            .animate()
            .fadeIn(delay: 400.ms, duration: 650.ms)
            .slideX(begin: -0.06, duration: 650.ms),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Education
// -----------------------------------------------------------------------------
class EducationSection extends StatelessWidget {
  const EducationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        EducationCard(
          degree: 'M.Sc. Biomedical Engineering — Bioelectric',
          institution: 'University of Tehran',
          period: 'October 2026 – Present | Tehran, Iran',
        ),
        SizedBox(height: 16),
        EducationCard(
          degree: 'B.Sc. Biomedical Engineering — Bioelectric',
          institution: 'Sharif University of Technology',
          period: '2022 – June 2026 | Tehran, Iran',
        ),
      ],
    ).animate().fadeIn(duration: 700.ms).slideY(begin: 0.12);
  }
}

// -----------------------------------------------------------------------------
// Projects
// -----------------------------------------------------------------------------
class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardColor.withAlpha(225),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width < 600 ? 14 : 24),
        child: Column(
          children: [
            const ProjectTile(
              icon: Icons.memory,
              title: 'Altium Designer Projects — PCB Design',
              description:
              'Design and implementation of microcontroller boards and analog circuits.',
            ).animate().fadeIn(delay: 0.ms, duration: 450.ms).slideX(begin: -0.04, delay: 0.ms, duration: 450.ms),
            const ProjectTile(
              icon: Icons.sports_esports_outlined,
              title: 'C++ Game for the University BP',
              description:
              'A marble/jungle-style game developed using C++ and SDK tools.',
            ).animate().fadeIn(delay: 70.ms, duration: 450.ms).slideX(begin: -0.04, delay: 70.ms, duration: 450.ms),
            const ProjectTile(
              icon: Icons.electrical_services,
              title: 'Circuit Theory — Impedance Conversion',
              description:
              'Designed a two-op-amp circuit to convert capacitive impedance behavior to inductive behavior.',
            ).animate().fadeIn(delay: 140.ms, duration: 450.ms).slideX(begin: -0.04, delay: 140.ms, duration: 450.ms),
            const ProjectTile(
              icon: Icons.calculate_outlined,
              title: 'Circuit1 — Circuit Parameter Calculator',
              description:
              'Developed a Java application to model circuit parameters and calculate quantities such as current and equivalent resistance, with a PSpice-like approach.',
            ).animate().fadeIn(delay: 210.ms, duration: 450.ms).slideX(begin: -0.04, delay: 210.ms, duration: 450.ms),
            const ProjectTile(
              icon: Icons.account_tree_outlined,
              title: 'Three Logic-Circuit Projects',
              description:
              'Implemented logic functions using standard logic ICs such as AND and OR gates, and designed PCBs for the circuits.',
            ).animate().fadeIn(delay: 280.ms, duration: 450.ms).slideX(begin: -0.04, delay: 280.ms, duration: 450.ms),
            const ProjectTile(
              icon: Icons.wifi_tethering,
              title: 'Signals and Systems — Linear Antenna',
              description: 'A linear-antenna project completed for the Signals and Systems course.',
            ).animate().fadeIn(delay: 350.ms, duration: 450.ms).slideX(begin: -0.04, delay: 350.ms, duration: 450.ms),
            const ProjectTile(
              icon: Icons.psychology_outlined,
              title: 'Two Machine-Learning Projects — Voice and Image',
              description:
              'Applied Edge Impulse, K-nearest neighbors (KNN), and convolutional neural networks (CNNs) on embedded devices.',
            ).animate().fadeIn(delay: 420.ms, duration: 450.ms).slideX(begin: -0.04, delay: 420.ms, duration: 450.ms),
            const ProjectTile(
              icon: Icons.developer_board,
              title: 'Five Embedded-Systems Projects',
              description:
              'Five major projects completed as part of the embedded-systems course.',
            ).animate().fadeIn(delay: 490.ms, duration: 450.ms).slideX(begin: -0.04, delay: 490.ms, duration: 450.ms),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: () => _launchUrl(
                  context,
                  'https://drive.google.com/drive/folders/1SHjofwtOaYAAcyYHiYoLjGvaeAMnc3cO',
                ),
                icon: const Icon(Icons.folder_open),
                label: const Text('More projects and portfolio files'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.secondary,
                  side: const BorderSide(color: AppColors.secondary),
                ),
              ).animate().fadeIn(delay: 560.ms, duration: 450.ms),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 700.ms).slideY(begin: 0.12);
  }
}

// -----------------------------------------------------------------------------
// Skills
// -----------------------------------------------------------------------------
class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  static const List<SkillEntry> _expert = [
    SkillEntry('ESP-IDF', 'Expert'),
  ];

  static const List<SkillEntry> _advanced = [
    SkillEntry('Altium Designer', 'Advanced'),
    SkillEntry('Proteus', 'Advanced'),
    SkillEntry('OpenCV', 'Advanced'),
    SkillEntry('VHDL', 'Advanced'),
    SkillEntry('LaTeX', 'Advanced'),
    SkillEntry('Linux', 'Advanced'),
    SkillEntry('Microsoft Word', 'Advanced'),
    SkillEntry('JavaScript', 'Advanced'),
    SkillEntry('Embedded C', 'Advanced'),
    SkillEntry('C++', 'Advanced'),
    SkillEntry('Flutter', 'Advanced'),
    SkillEntry('Python', 'Advanced'),
    SkillEntry('.NET Core / .NET', 'Advanced'),
    SkillEntry('IoT', 'Advanced'),
  ];

  static const List<SkillEntry> _intermediate = [
    SkillEntry('Dart', 'Intermediate'),
    SkillEntry('Wireshark', 'Intermediate'),
    SkillEntry('C', 'Intermediate'),
    SkillEntry('Kotlin', 'Intermediate'),
    SkillEntry('Git', 'Intermediate'),
    SkillEntry('PSpice', 'Intermediate'),
    SkillEntry('CodeVision', 'Intermediate'),
    SkillEntry('LOGO! Soft', 'Intermediate'),
    SkillEntry('Java', 'Intermediate'),
    SkillEntry('COMSOL', 'Intermediate'),
    SkillEntry('Stimulsoft Report', 'Intermediate'),
    SkillEntry('Verilog', 'Intermediate'),
    SkillEntry('MATLAB', 'Intermediate'),
    SkillEntry('Server Virtualization (ESX / VMware)', 'Intermediate'),
    SkillEntry('ASP.NET', 'Intermediate'),
    SkillEntry('LabVIEW', 'Intermediate'),
    SkillEntry('Logo', 'Intermediate'),
    SkillEntry('Assembly', 'Intermediate'),
    SkillEntry('C#', 'Intermediate'),
  ];

  static const List<String> _focusAreas = [
    '3D Surface Reconstruction',
    'Biomedical Signal Processing',
    'Machine Learning in Biomedical Applications',
    'Edge Impulse for Embedded AI',
    'ARM Microcontroller Programming',
    'Analog-Circuit and PCB Design',
    'Microfluidic Systems',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SkillGroup(title: 'Expert', skills: _expert),
        const SizedBox(height: 22),
        const SkillGroup(title: 'Advanced', skills: _advanced),
        const SizedBox(height: 22),
        const SkillGroup(title: 'Intermediate', skills: _intermediate),
        const SizedBox(height: 22),
        Card(
          color: AppColors.cardColor.withAlpha(220),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Technical Focus Areas',
                  style: TextStyle(
                    color: AppColors.textHeader,
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _focusAreas.asMap().entries.map((entry) {
                    final int index = entry.key;
                    final String item = entry.value;

                    return FocusChip(label: item)
                        .animate()
                        .fadeIn(
                      delay: Duration(milliseconds: index * 70),
                      duration: 450.ms,
                      curve: Curves.easeOutCubic,
                    )
                        .slideY(
                      begin: 0.12,
                      delay: Duration(milliseconds: index * 70),
                      duration: 450.ms,
                      curve: Curves.easeOutCubic,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 650.ms).slideY(begin: 0.08);
  }
}

class SkillEntry {
  final String name;
  final String level;

  const SkillEntry(this.name, this.level);
}

class SkillGroup extends StatelessWidget {
  final String title;
  final List<SkillEntry> skills;

  const SkillGroup({
    super.key,
    required this.title,
    required this.skills,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardColor.withAlpha(220),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textHeader,
                fontWeight: FontWeight.bold,
                fontSize: 19,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: skills.asMap().entries.map((entry) {
                final int index = entry.key;
                final SkillEntry skill = entry.value;

                return SkillChip(
                  key: ValueKey<String>(skill.name),
                  name: skill.name,
                  level: skill.level,
                )
                    .animate()
                    .fadeIn(
                  delay: Duration(milliseconds: index * 45),
                  duration: 420.ms,
                  curve: Curves.easeOutCubic,
                )
                    .slideY(
                  begin: 0.14,
                  delay: Duration(milliseconds: index * 45),
                  duration: 420.ms,
                  curve: Curves.easeOutCubic,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class SkillChip extends StatelessWidget {
  final String name;
  final String level;

  const SkillChip({
    super.key,
    required this.name,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.background.withAlpha(190),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.secondary.withAlpha(70)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: AppColors.textHeader,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            level,
            style: const TextStyle(
              color: AppColors.secondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class FocusChip extends StatelessWidget {
  final String label;

  const FocusChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.background.withAlpha(190),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.secondary.withAlpha(70)),
      ),
      child: Text(
        label,
        style: const TextStyle(color: AppColors.readableText, fontSize: 13),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Certificates
// -----------------------------------------------------------------------------
class CertificatesSection extends StatelessWidget {
  const CertificatesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      color: AppColors.cardColor,
      child: Padding(
        padding: EdgeInsets.all(22),
        child: Column(
          children: [
            CertificateTile(
              title: 'Internal Electric System',
              issuer:
              'Technical and Vocational Training Institute — Tehran, Center No. 9 Moshiriye',
            ),
            Divider(color: AppColors.textBody),
            CertificateTile(
              title: 'Logic Circuit Architecture',
              issuer:
              'Technical and Vocational Training Institute — Tehran, Center No. 2 Shahid Sohi',
            ),
            Divider(color: AppColors.textBody),
            CertificateTile(
              title: 'ARM Microcontrollers',
              issuer:
              'Technical and Vocational Training Institute — Tehran, Center No. 9 Moshiriye; with Master Beigy',
            ),
            Divider(color: AppColors.textBody),
            CertificateTile(
              title: 'Altium Designer (PCB)',
              issuer: 'PCB design using Altium Designer',
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 700.ms).slideY(begin: 0.12);
  }
}

// -----------------------------------------------------------------------------
// Contact / footer
// -----------------------------------------------------------------------------
class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Let's Connect",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Parisienne',
                    fontSize: 44,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textHeader,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 100.ms, duration: 650.ms)
                    .slideY(begin: -0.08, duration: 650.ms),
                const SizedBox(height: 16),
                const Text(
                  'For collaboration, research, or project inquiries, feel free to contact me.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textBody,
                    height: 1.6,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 240.ms, duration: 650.ms)
                    .slideY(begin: 0.10, duration: 650.ms),
                const SizedBox(height: 24),
                Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    IconButton(
                      icon: const Icon(FontAwesomeIcons.linkedin),
                      color: AppColors.secondary,
                      iconSize: 29,
                      tooltip: 'LinkedIn',
                      onPressed: () => _launchUrl(
                        context,
                        'https://www.linkedin.com/in/mohamadparsa-malek-0214322a2',
                      ),
                    ),
                    IconButton(
                      icon: const Icon(FontAwesomeIcons.telegram),
                      color: AppColors.secondary,
                      iconSize: 29,
                      tooltip: 'Telegram',
                      onPressed: () =>
                          _launchUrl(context, 'https://t.me/TheLordMpM'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.email_outlined),
                      color: AppColors.secondary,
                      iconSize: 29,
                      tooltip: 'Email',
                      onPressed: () => _launchUrl(
                        context,
                        'mailto:mohamadparsamalek.30@gmail.com',
                      ),
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(delay: 380.ms, duration: 650.ms)
                    .slideY(begin: 0.10, duration: 650.ms),
                const SizedBox(height: 22),
                Center(
                  child: OutlinedButton.icon(
                    onPressed: () => _downloadResume(context),
                    icon: const Icon(Icons.download),
                    label: const Text('Download Full CV'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.secondary,
                      side: const BorderSide(color: AppColors.secondary),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 17,
                      ),
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 500.ms, duration: 650.ms)
                    .scale(begin: const Offset(0.94, 0.94), duration: 650.ms),
                const SizedBox(height: 28),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Loading games...'),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                      try {
                        await games.loadLibrary();
                        if (!context.mounted) return;
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (context) => games.GamesPage(),
                          ),
                        );
                      } catch (error) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Could not load games: $error')),
                        );
                      }
                    },
                    icon: const Icon(Icons.sports_esports_outlined),
                    label: const Text('Bored? Try a game'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cardColor,
                      foregroundColor: AppColors.secondary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 17,
                      ),
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 640.ms, duration: 650.ms)
                    .scale(begin: const Offset(0.94, 0.94), duration: 650.ms),
                const SizedBox(height: 48),
                const Text(
                  'Designed & built by Mohammad Parsa Malek',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: AppColors.textBody),
                )
                    .animate()
                    .fadeIn(delay: 780.ms, duration: 650.ms)
                    .slideY(begin: 0.04, duration: 650.ms),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 700.ms).slideY(begin: 0.06);
  }
}

// -----------------------------------------------------------------------------
// Reusable widgets
// -----------------------------------------------------------------------------
class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Parisienne',
          fontSize: 42,
          fontWeight: FontWeight.bold,
          color: AppColors.textHeader,
        ),
      )
          .animate()
          .fadeIn(duration: 650.ms, curve: Curves.easeOutCubic)
          .slideX(begin: -0.055, duration: 650.ms, curve: Curves.easeOutCubic)
          .shimmer(
        delay: 700.ms,
        duration: 1100.ms,
        color: AppColors.secondary.withAlpha(30),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width < 600 ? 88 : 112,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: AppColors.textHeader,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: const TextStyle(color: AppColors.textBody, height: 1.45),
            ),
          ),
        ],
      ),
    );
  }
}

class SkillBullet extends StatelessWidget {
  final String text;

  const SkillBullet({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.arrow_right, color: AppColors.secondary, size: 21),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: AppColors.textBody, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class ExperienceTile extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final String company;
  final String title;
  final String period;
  final String description;
  final String? companyUrl;

  const ExperienceTile({
    super.key,
    this.isFirst = false,
    this.isLast = false,
    required this.company,
    required this.title,
    required this.period,
    required this.description,
    this.companyUrl,
  });

  @override
  Widget build(BuildContext context) {
    Widget companyName = Text(
      company,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.secondary,
      ),
    );

    if (companyUrl != null) {
      companyName = InkWell(
        onTap: () => _launchUrl(context, companyUrl!),
        child: companyName,
      );
    }

    return TimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      beforeLineStyle: const LineStyle(
        color: AppColors.secondary,
        thickness: 2,
      ),
      indicatorStyle: const IndicatorStyle(
        width: 18,
        color: AppColors.secondary,
        padding: EdgeInsets.all(3),
      ),
      endChild: Padding(
        padding: const EdgeInsets.only(left: 22, top: 4, bottom: 25, right: 4),
        child: Card(
          color: AppColors.cardColor.withAlpha(225),
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  period,
                  style: const TextStyle(
                    color: AppColors.secondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 90.ms, duration: 450.ms)
                    .slideX(begin: -0.04, duration: 450.ms),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textHeader,
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 190.ms, duration: 500.ms)
                    .slideX(begin: -0.035, duration: 500.ms),
                const SizedBox(height: 6),
                companyName
                    .animate()
                    .fadeIn(delay: 280.ms, duration: 450.ms)
                    .slideX(begin: 0.04, duration: 450.ms),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.textBody,
                    fontSize: 14,
                    height: 1.6,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 390.ms, duration: 600.ms)
                    .slideY(begin: 0.045, duration: 600.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EducationCard extends StatelessWidget {
  final String degree;
  final String institution;
  final String period;

  const EducationCard({
    super.key,
    required this.degree,
    required this.institution,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardColor.withAlpha(225),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.school_outlined,
                color: AppColors.secondary, size: 30),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    degree,
                    style: const TextStyle(
                      color: AppColors.textHeader,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 100.ms, duration: 550.ms)
                      .slideX(begin: -0.05, duration: 550.ms),
                  const SizedBox(height: 7),
                  Text(
                    institution,
                    style: const TextStyle(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 220.ms, duration: 550.ms)
                      .slideX(begin: 0.04, duration: 550.ms),
                  const SizedBox(height: 6),
                  Text(
                    period,
                    style: const TextStyle(
                      color: AppColors.textBody,
                      fontSize: 13,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 340.ms, duration: 550.ms)
                      .slideY(begin: 0.05, duration: 550.ms),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const ProjectTile({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.secondary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textHeader,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 420.ms)
                    .slideX(begin: -0.035, duration: 420.ms),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.textBody,
                    height: 1.5,
                    fontSize: 13,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 110.ms, duration: 500.ms)
                    .slideY(begin: 0.045, duration: 500.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CertificateTile extends StatelessWidget {
  final String title;
  final String issuer;

  const CertificateTile({
    super.key,
    required this.title,
    required this.issuer,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.workspace_premium_outlined,
              color: AppColors.secondary, size: 25),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textHeader,
                    fontWeight: FontWeight.bold,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 450.ms)
                    .slideX(begin: -0.04, duration: 450.ms),
                const SizedBox(height: 5),
                Text(
                  issuer,
                  style: const TextStyle(
                    color: AppColors.textBody,
                    height: 1.5,
                    fontSize: 13,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 130.ms, duration: 520.ms)
                    .slideY(begin: 0.04, duration: 520.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// URL helpers
// -----------------------------------------------------------------------------
Future<void> _launchUrl(BuildContext context, String target) async {
  final Uri uri = Uri.parse(target);
  try {
    final bool launched = await launchUrl(
      uri,
      webOnlyWindowName: '_blank',
    );
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open: $target')),
      );
    }
  } catch (error) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open the link: $error')),
      );
    }
  }
}

Uri _resumeUri() {
  return Uri.base.resolve('assets/assets/Mohammad_Parsa_Malek_Resume.pdf');
}

Future<void> _viewResume(BuildContext context) async {
  final Uri uri = _resumeUri();
  try {
    final bool opened = await launchUrl(
      uri,
      webOnlyWindowName: '_blank',
    );
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the resume PDF.')),
      );
    }
  } catch (error) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open the resume: $error')),
      );
    }
  }
}

void _downloadResume(BuildContext context) {
  final Uri uri = _resumeUri();

  final web.HTMLAnchorElement downloadLink =
  web.HTMLAnchorElement()
    ..href = uri.toString()
    ..download = 'Mohammad-Parsa-Malek-Resume.pdf'
    ..style.display = 'none';

  final body = web.document.body;

  if (body == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('The browser could not start the download.'),
      ),
    );
    return;
  }

  try {
    body.append(downloadLink);
    downloadLink.click();
    downloadLink.remove();
  } catch (error) {
    downloadLink.remove();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Download failed: $error'),
        ),
      );
    }
  }
}
