import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../controllers/theory_controller.dart';

class LessonDetailScreen extends StatefulWidget {
  final String lessonTitle;
  final String content;
  final String videoUrl;

  LessonDetailScreen({
    required this.lessonTitle,
    required this.content,
    required this.videoUrl,
  });

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  final TheoryController controller = Get.find<TheoryController>();
  bool _isLoading = true;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      lowerBound: 0.95,
      upperBound: 1.05,
    )..repeat(reverse: true);
  }

  Future<void> _initializePlayer() async {
    try {
      _videoController = VideoPlayerController.network(widget.videoUrl);
      await _videoController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoController,
        autoPlay: false,
        looping: false,
        aspectRatio: _videoController.value.aspectRatio,
      );

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = controller.isCompleted(widget.lessonTitle);
    final primaryGreen = const Color(0xFF4CAF50);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lessonTitle),
        backgroundColor: primaryGreen,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: widget.lessonTitle,
              child: Material(
                color: Colors.transparent,
                child: Text(
                  widget.lessonTitle,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(widget.content,
                style: const TextStyle(fontSize: 16, height: 1.5)),
            const SizedBox(height: 20),

            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : AspectRatio(
              aspectRatio: _videoController.value.aspectRatio,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Chewie(controller: _chewieController!),
              ),
            ),
            const SizedBox(height: 24),

            ScaleTransition(
              scale: _animController,
              child: ElevatedButton.icon(
                onPressed: () {
                  controller.toggleComplete(widget.lessonTitle);
                  setState(() {});
                },
                icon: Icon(
                    isCompleted ? Icons.check_circle : Icons.done_all_outlined),
                label: Text(
                    isCompleted ? "Đã hoàn thành" : "Đánh dấu hoàn thành"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCompleted ? Colors.green : primaryGreen,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
