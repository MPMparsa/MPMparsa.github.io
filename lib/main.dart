import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'games.dart'; // Import the new games page

// --- App Theme and Colors ---
class AppColors {
  static const Color background = Color(0xFF0A192F);
  static const Color primary = Color(0xFF003B8E);
  static const Color secondary = Color(0xFF64FFDA); // A more vibrant, techy accent
  static const Color backgroundEnd = Color(0xFF112240);
  static const Color cardColor = Color(0xFF112240);
  static const Color textHeader = Color(0xFFCCD6F6);
  static const Color textBody = Color(0xFF8892B0);
}

// --- Main App ---
void main() => runApp(const PortfolioApp());

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mohammad Parsa Malek Portfolio',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: AppColors.textBody,
          displayColor: AppColors.textHeader,
        ),
      ),
      home: const ResumePage(),
    );
  }
}

class ResumePage extends StatefulWidget {
  const ResumePage({super.key});

  @override
  State<ResumePage> createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> {
  // Keys for scrolling to sections
  final aboutKey = GlobalKey();
  final experienceKey = GlobalKey();
  final skillsKey = GlobalKey();
  final projectsKey = GlobalKey();
  final contactKey = GlobalKey();
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollTo(GlobalKey key) {
    Scrollable.ensureVisible(key.currentContext!,
        duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background.withAlpha(220),
        title: const Text('Mohammad Parsa Malek',
            style: TextStyle(
                fontFamily: 'Parisienne',
                fontWeight: FontWeight.bold,
                color: AppColors.textHeader,
                fontSize: 26)),
        actions: [
          TextButton(
              onPressed: () => _scrollTo(aboutKey), child: const Text('About')),
          TextButton(
              onPressed: () => _scrollTo(experienceKey),
              child: const Text('Experience')),
          TextButton(
              onPressed: () => _scrollTo(projectsKey),
              child: const Text('Projects')),
          TextButton(
              onPressed: () => _scrollTo(skillsKey),
              child: const Text('Skills')),
          TextButton(
              onPressed: () => _scrollTo(contactKey),
              child: const Text('Contact')),
          const SizedBox(width: 20),
        ],
      ),
      body: Stack(
        children: [
          const AnimatedAuroraBackground(),
          Center(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1000),
                padding:
                const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeroSection(),
                    const SizedBox(height: 100),
                    SectionTitle(key: aboutKey, title: 'About Me'),
                    const AboutSection(),
                    const SizedBox(height: 80),
                    SectionTitle(
                        key: experienceKey, title: 'Experience & Education'),
                    const ExperienceSection(),
                    const SizedBox(height: 80),
                    SectionTitle(key: projectsKey, title: 'Projects'),
                    const ProjectsSection(),
                    const SizedBox(height: 80),
                    SectionTitle(key: skillsKey, title: 'Technical Skills'),
                    const SkillsSection(),
                    const SizedBox(height: 80),
                    FooterSection(key: contactKey),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- SECTIONS ---

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Responsive font sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final double titleSize = screenWidth < 600 ? 52 : 82;
    final double subtitleSize = screenWidth < 600 ? 22 : 28;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mohammad Parsa Malek',
            style: TextStyle(
                fontFamily: 'Parisienne',
                fontSize: titleSize,
                fontWeight: FontWeight.bold,
                color: AppColors.textHeader),
          ).animate().fadeIn(delay: 300.ms, duration: 500.ms).slideX(begin: -0.2),
          const SizedBox(height: 8),
          Text(
            'Bioelectric Engineer | AI Expert | Software&EmbeddedSystem Developer',
            style: TextStyle(
                fontSize: subtitleSize,
                color: AppColors.secondary,
                fontWeight: FontWeight.w500),
          ).animate().fadeIn(delay: 400.ms, duration: 500.ms).slideX(begin: -0.2),
          const SizedBox(height: 24),
          const Text(
            "A dedicated and innovative bioelectric engineer and AI expert with a passion for developing elegant software solutions. Proficient in deploying ML models and bridging the gap between hardware and software with embedded systems and Flutter.",
            style:
            TextStyle(fontSize: 16, color: AppColors.textBody, height: 1.6),
          ).animate().fadeIn(delay: 500.ms, duration: 500.ms).slideX(begin: -0.2),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () =>
                _launchURL(context, 'mailto:mohamadparsamalek.30@gmail.com'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: AppColors.background,
              padding:
              const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Get In Touch',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ).animate().fadeIn(delay: 600.ms, duration: 500.ms),
        ],
      ),
    );
  }
}

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardColor.withAlpha(128),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Personal Information",
                style: TextStyle(
                    fontFamily: 'Parisienne',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textHeader)),
            const SizedBox(height: 16),
            const InfoRow(label: "Age", value: "21 Years"),
            const InfoRow(label: "Location", value: "Tehran, Tehran"),
            const InfoRow(label: "Phone", value: "+98 990 010 0336"),
            const InfoRow(
                label: "Email", value: "mohamadparsamalek.30@gmail.com"),
            const Divider(color: AppColors.textBody, height: 32),
            const Text("Core Competencies",
                style: TextStyle(
                    fontFamily: 'Parisienne',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textHeader)),
            const SizedBox(height: 16),
            const SkillBullet(text: "Embedded system designer"),
            const SkillBullet(text: "Circuit designer using Altuim designer"),
            const SkillBullet(
                text:
                "Machine Learning algorithm implementation in MATLAB, Python, and on embedded systems"),
            const SkillBullet(text: "Programming of ARM microcontrollers"),
          ],
        ),
      ),
    )
        .animate(
        onPlay: (controller) => controller.repeat(reverse: true))
        .shimmer(
        delay: 2000.ms,
        duration: 1000.ms,
        color: AppColors.secondary.withAlpha(50))
        .animate()
        .fadeIn(duration: 800.ms)
        .slideY(begin: 0.3, duration: 600.ms);
  }
}

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ExperienceTile(
          isFirst: true,
          company: 'Parsiss (Navigation in Surgical System) Co.',
          title: 'Image Processing on DICOM Images',
          period: '15 June 2025 - 10 Oct 2025',
          description:
          'Focused on surface detection and registration of medical DICOM images for use in surgical navigation systems.',
          companyUrl: 'http://www.parsiss.com/',
        ),
        const ExperienceTile(
          company: 'Sharif University',
          title: 'LLM Job Agent Hackathon (14th Place)',
          period: '5 May 2025',
          description:
          'Participated in a competitive hackathon focused on creating and deploying Large Language Model agents for job-related tasks, achieving a top 15 rank.',
        ),
        const ExperienceTile(
          company: 'atieh sazan',
          title: 'UI/UX developer',
          period: '07/2024 - 12/2024',
          description:
          'Contributed to the user interface and experience design for various software applications, focusing on creating intuitive and user-friendly products.',
        ),
        const ExperienceTile(
          isLast: true,
          company: 'Sharif university of technology',
          title: 'Bachelor: Biomedical Engineering- Bioelectric',
          period: '2022 - Present',
          description:
          'Pursuing a rigorous curriculum focused on the intersection of electrical engineering and biological systems, with projects in signal processing and embedded systems.',
        ),
      ],
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.3, duration: 600.ms);
  }
}

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardColor.withAlpha(128),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Select Projects",
                style: TextStyle(
                    fontFamily: 'Parisienne',
                    fontSize: 28,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const ProjectTile(
              title: "Project Portfolio",
              description:
              "A collection of my volunteer and course projects, including 'My Reward' and AI implementations.",
              link:
              "https://drive.google.com/drive/folders/1SHjofwtOaYAAcyYHiYoLjGvaeAMnc3c0",
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.3, duration: 600.ms);
  }
}

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: const [
        // This is now a const list, which improves performance.
        SkillCard(name: 'Flutter', icon: FontAwesomeIcons.mobileScreen),
        SkillCard(name: 'Python', icon: FontAwesomeIcons.python),
        SkillCard(name: 'Linux', icon: FontAwesomeIcons.linux),
        SkillCard(name: 'C++', icon: FontAwesomeIcons.c),
        SkillCard(name: 'JavaScript', icon: FontAwesomeIcons.js),
        SkillCard(name: 'Embedded C', icon: FontAwesomeIcons.microchip),
        SkillCard(name: 'OpenCV', icon: FontAwesomeIcons.cameraRetro),
        SkillCard(name: 'VHDL', icon: FontAwesomeIcons.code),
        SkillCard(name: '.NET', icon: FontAwesomeIcons.windows),
        SkillCard(name: 'Altium', icon: FontAwesomeIcons.rulerCombined),
        SkillCard(name: 'Proteus', icon: FontAwesomeIcons.sitemap),
        SkillCard(name: 'LaTex', icon: FontAwesomeIcons.fileLines),
        SkillCard(name: 'Word', icon: FontAwesomeIcons.fileWord),
        SkillCard(name: 'Dart', icon: FontAwesomeIcons.code),
        SkillCard(name: 'C', icon: FontAwesomeIcons.c),
        SkillCard(name: 'Java', icon: FontAwesomeIcons.java),
        SkillCard(name: 'C#', icon: FontAwesomeIcons.c),
        SkillCard(name: 'MATLAB', icon: FontAwesomeIcons.squareRootVariable),
        SkillCard(name: 'Kotlin', icon: FontAwesomeIcons.code),
        SkillCard(name: 'Assembly', icon: FontAwesomeIcons.microchip),
        SkillCard(name: 'Verilog', icon: FontAwesomeIcons.code),
        SkillCard(name: 'Git', icon: FontAwesomeIcons.gitAlt),
        SkillCard(name: 'ASP.NET', icon: FontAwesomeIcons.code),
        SkillCard(name: 'JQuery', icon: FontAwesomeIcons.js),
        SkillCard(name: 'Wireshark', icon: FontAwesomeIcons.networkWired),
        SkillCard(name: 'VMware', icon: FontAwesomeIcons.server),
        SkillCard(name: 'LabVIEW', icon: FontAwesomeIcons.chartBar),
        SkillCard(name: 'Pspice', icon: FontAwesomeIcons.waveSquare),
        SkillCard(name: 'CodeVision', icon: FontAwesomeIcons.microchip),
        SkillCard(name: 'LOGO!', icon: FontAwesomeIcons.lightbulb),
      ]
          .animate(interval: 50.ms)
          .fadeIn(duration: 800.ms)
          .slideY(begin: 0.3, duration: 600.ms),
    );
  }
}

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Let's Connect",
          style: TextStyle(
              fontFamily: 'Parisienne',
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: AppColors.textHeader),
        ),
        const SizedBox(height: 20),
        const Text(
          "Feel free to reach out for collaborations or just a friendly hello!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: AppColors.textBody),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(FontAwesomeIcons.linkedin,
                  color: AppColors.textBody),
              onPressed: () => _launchURL(context,
                  'https://www.linkedin.com/in/mohamadparsa-malek-0214322a2'),
              iconSize: 30,
              tooltip: 'LinkedIn',
            ),
            const SizedBox(width: 20),
            IconButton(
              icon: const Icon(FontAwesomeIcons.telegram,
                  color: AppColors.textBody),
              onPressed: () => _launchURL(context, 'https://t.me/TheLordMpM'),
              iconSize: 30,
              tooltip: 'Telegram',
            ),
          ],
        ),
        const SizedBox(height: 40),
        OutlinedButton(
          onPressed: () {
            _launchURL(context, 'assets/Mohammad-Parsa-Malek-Resume.pdf');
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.secondary,
            side: const BorderSide(color: AppColors.secondary),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Download Full CV'),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const GamesPage()));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.cardColor,
            foregroundColor: AppColors.secondary,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text("Boring...?, try this",
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 50),
        const Text(
          'Designed & Built by Mohammad Parsa Malek.',
          style: TextStyle(fontSize: 12),
        ),
      ],
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.3, duration: 600.ms);
  }
}

// --- REUSABLE WIDGETS ---

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Text(title,
          style: const TextStyle(
              fontFamily: 'Parisienne',
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: AppColors.textHeader)),
    );
  }
}

class SkillCard extends StatefulWidget {
  final String name;
  final IconData icon;

  const SkillCard({super.key, required this.name, required this.icon});

  @override
  State<SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<SkillCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 150,
        height: 120,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _isHovered
              ? AppColors.primary
              : AppColors.cardColor.withAlpha(128),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.secondary.withAlpha(51)),
          boxShadow: [
            if (_isHovered)
              BoxShadow(
                color: AppColors.secondary.withAlpha(26),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon,
                size: 40,
                color: _isHovered ? Colors.white : AppColors.secondary),
            const SizedBox(height: 12),
            Text(widget.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: _isHovered ? Colors.white : AppColors.textHeader,
                    fontWeight: FontWeight.w600)),
          ],
        ),
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
    return TimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      beforeLineStyle:
      const LineStyle(color: AppColors.secondary, thickness: 2),
      indicatorStyle: IndicatorStyle(
        width: 20,
        color: AppColors.secondary,
        padding: const EdgeInsets.all(4),
        iconStyle: IconStyle(
            iconData: Icons.circle, color: Colors.white, fontSize: 12),
      ),
      endChild: Padding(
        padding: const EdgeInsets.only(left: 24, top: 8, bottom: 24, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(period,
                style:
                const TextStyle(fontSize: 14, color: AppColors.textBody)),
            const SizedBox(height: 4),
            Text(title,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textHeader)),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.secondary,
                    fontFamily:
                    Theme.of(context).textTheme.bodyLarge?.fontFamily),
                children: [
                  TextSpan(
                    text: company,
                    recognizer: companyUrl != null
                        ? (TapGestureRecognizer()
                      ..onTap = () => _launchURL(context, companyUrl!))
                        : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(description,
                style: const TextStyle(
                    fontSize: 14, color: AppColors.textBody, height: 1.5)),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text("$label: ",
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.textHeader)),
          Expanded(
            child:
            Text(value, style: const TextStyle(color: AppColors.textBody)),
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
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.arrow_right, color: AppColors.secondary, size: 20),
          const SizedBox(width: 8),
          Expanded(
              child:
              Text(text, style: const TextStyle(color: AppColors.textBody))),
        ],
      ),
    );
  }
}

class ProjectTile extends StatelessWidget {
  final String title;
  final String description;
  final String link;
  const ProjectTile(
      {super.key,
        required this.title,
        required this.description,
        required this.link});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(FontAwesomeIcons.diagramProject,
          color: AppColors.secondary),
      title: Text(title,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: AppColors.textHeader)),
      subtitle:
      Text(description, style: const TextStyle(color: AppColors.textBody)),
      onTap: () => _launchURL(context, link),
      contentPadding: EdgeInsets.zero,
    );
  }
}

// --- HELPER FUNCTIONS ---

void _launchURL(BuildContext context, String url) async {
  final Uri uri = Uri.parse(url);
  try {
    // The canLaunch check is unreliable for web assets, so we launch directly.
    // The catch block will handle failures.
    await launchUrl(uri, webOnlyWindowName: '_self');
  } catch (e) {
    // A check to prevent showing a SnackBar if the widget is no longer in the tree.
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Error: Could not open the link. Target URL: $url. Please ensure the file is in the `assets` folder and `pubspec.yaml` is correct.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

// --- ANIMATED BACKGROUND WIDGET ---
class AnimatedAuroraBackground extends StatefulWidget {
  const AnimatedAuroraBackground({super.key});

  @override
  State<AnimatedAuroraBackground> createState() =>
      _AnimatedAuroraBackgroundState();
}

class _AnimatedAuroraBackgroundState extends State<AnimatedAuroraBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 20));
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              transform: GradientRotation(_animation.value * 2 * 3.14159),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.background,
                AppColors.primary.withAlpha(128),
                AppColors.backgroundEnd,
                AppColors.secondary.withAlpha(77),
              ],
              stops: const [0.1, 0.4, 0.8, 1.0],
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
            child: Container(color: Colors.black.withOpacity(0.2)),
          ),
        );
      },
    );
  }
}