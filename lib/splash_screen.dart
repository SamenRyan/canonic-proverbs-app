import 'package:flutter/material.dart';
import 'dart:async';
import 'q_home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize video player controller
    _controller = VideoPlayerController.asset('assests/Quote.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });

    // Delay navigation and trigger transition after 3 seconds
    _myBoolCheckerforNav().then((_) => _navigateToHome());

    // Animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();
  }

  Future<bool> _myBoolCheckerforNav() async {
    await Future.delayed(const Duration(seconds: 5));
    return true;
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const QHomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff2980b9) , Color(0xff2980b9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Video instead of Lottie animation
              _controller.value.isInitialized
                  ? SizedBox(
                      height: 200,
                      width: 200,
                      child: VideoPlayer(_controller),
                    )
                  : const CircularProgressIndicator(), // Show loading until video is ready

              const SizedBox(height: 20),

              // Fade-in & Scaling Effect for Text
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _opacityAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Text(
                        "Otantik Quotes",
                        style: GoogleFonts.pacifico(
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // Smooth Fade-in Text for "Smile for others"
              FadeTransition(
                opacity: _opacityAnimation,
                child: Text(
                  "Smile for others",
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                  ),
                ),
              ),

                  const SizedBox(height: 60),

              // Smooth Fade-in Text for "Smile for others"
              FadeTransition(
                opacity: _opacityAnimation,
                child: Text(
                  "Powered by Otantik Hub",
                  style: GoogleFonts.lato(
                    fontSize: 19,
                    fontWeight: FontWeight.w400,
                    color: const Color.fromARGB(179, 34, 33, 33),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
