import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../controllers/theory_controller.dart';

// Helper: Kiểm tra link YouTube
bool isYoutubeUrl(String url) {
  return url.contains('youtube.com') || url.contains('youtu.be');
}

// Helper: lấy videoId từ url YouTube
String? getYoutubeVideoId(String url) {
  return YoutubePlayer.convertUrlToId(url);
}

class LessonDetailScreen extends StatefulWidget {
  final String lessonTitle;
  final String content;
  final String videoUrl;

  const LessonDetailScreen({
    super.key,
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
  YoutubePlayerController? _youtubePlayerController;
  final TheoryController controller = Get.find<TheoryController>();
  bool _isLoading = true;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      lowerBound: 0.95,
      upperBound: 1.05,
    )..repeat(reverse: true);

    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    if (isYoutubeUrl(widget.videoUrl)) {
      final videoId = getYoutubeVideoId(widget.videoUrl);
      if (videoId != null) {
        _youtubePlayerController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
          ),
        );
      }
      setState(() => _isLoading = false);
    } else if (widget.videoUrl.endsWith('.mp4')) {
      _videoController = VideoPlayerController.network(widget.videoUrl);
      await _videoController.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoController,
        autoPlay: false,
        looping: false,
        aspectRatio: _videoController.value.aspectRatio,
      );
      setState(() => _isLoading = false);
    } else {
      // Không hỗ trợ loại video này
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    if (_chewieController != null) {
      _chewieController?.dispose();
      _videoController.dispose();
    }
    _youtubePlayerController?.dispose();
    _animController.dispose();
    super.dispose();
  }

  Widget _buildVideoWidget() {
    if (isYoutubeUrl(widget.videoUrl) && _youtubePlayerController != null) {
      return YoutubePlayer(
        controller: _youtubePlayerController!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.red,
      );
    } else if (_chewieController != null &&
        _videoController.value.isInitialized) {
      return AspectRatio(
        aspectRatio: _videoController.value.aspectRatio,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Chewie(controller: _chewieController!),
        ),
      );
    } else {
      return const Center(child: Text("Không hỗ trợ video này."));
    }
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
                : _buildVideoWidget(),
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