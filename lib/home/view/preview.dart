import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locket_beta/photo/cubit/photo_cubit.dart';
import 'package:locket_beta/photo/cubit/photo_state.dart';
import 'package:locket_beta/settings/global.dart';
import 'package:image_picker/image_picker.dart';

class ImagePreview extends StatefulWidget {
  const ImagePreview({
    super.key,
    required this.imagePath,
    required this.onSend,
  });
  final String imagePath;
  final void Function() onSend;

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  final TextEditingController _captionController = TextEditingController();

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _uploadPhoto() async {
    print('🔄 _uploadPhoto START');
    try {
      PhotoCubit photoCubit;
      try {
        photoCubit = context.read<PhotoCubit>();
        print('✅ Cubit loaded');
      } catch (e) {
        print('❌ Provider fail: $e');
        throw e;
      }

      final caption = _captionController.text.trim();
      print('📝 Caption: $caption');

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      await photoCubit.uploadPhoto(
        imageUrl: widget.imagePath,
        // imageUrl: widget.imagePath, // Uncomment sau khi test OK
        userId: '6911d640d34f6a5c5694199e',
        caption: caption.isNotEmpty ? caption : null,
      );

      print('✅ _uploadPhoto END SUCCESS');
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Upload thành công!')),
        );
        if (images is List<String>) {
          images.add(widget.imagePath);
        }
        widget.onSend();
        Navigator.pop(context);
      }
    } catch (e, stackTrace) {
      print('❌ _uploadPhoto ERROR: $e');
      print('Stack: $stackTrace');
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi upload: $e')),
        );
      }
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedFile == null) {
        print('❌ Không chọn ảnh');
        return;
      }

      print('📸 Ảnh được chọn: ${pickedFile.path}');

      // Mở màn hình Preview mới với ảnh được chọn
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ImagePreview(
            imagePath: pickedFile.path,
            onSend: widget.onSend,
          ),
        ),
      );
    } catch (e) {
      print('❌ Lỗi mở gallery: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể mở thư viện ảnh: $e')),
        );
      }
    }
  }

  Future<void> _pickAndUploadPhoto() async {
    try {
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedFile == null) {
        print('❌ Không chọn ảnh nào');
        return;
      }

      print('📸 Ảnh từ điện thoại: ${pickedFile.path}');

      final caption = _captionController.text.trim();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      final cubit = context.read<PhotoCubit>();

      await cubit.uploadPhoto(
        imageUrl: pickedFile.path,
        userId: '6911d640d34f6a5c5694199e',
        caption: caption.isNotEmpty ? caption : null,
      );

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Upload ảnh từ điện thoại thành công!')),
      );

      widget.onSend();
      Navigator.pop(context);
    } catch (e) {
      print("❌ Lỗi tải ảnh lên từ điện thoại: $e");
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi tải ảnh: $e')),
        );
      }
    }
  }

  void _handleDownload() {
    print('📥 Download clicked');
    // TODO: Implement download logic (e.g., using gallery_saver package)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tính năng tải xuống đang được phát triển')),
    );
  }

  void _handleShare() {
    print('🔗 Share clicked');
    // TODO: Implement share logic (e.g., using share_plus package)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chia sẻ ảnh')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PhotoCubit(),
      child: BlocListener<PhotoCubit, PhotoState>(
        listener: (context, state) {
          print('📡 BlocListener state change: $state'); // Log all state
          if (state is PhotoUpLoaded) {
            print('✅ PhotoUpLoaded: ${state.photo.id}');
          } else if (state is PhotoError) {
            print('❌ PhotoError: ${state.errorMessage}');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage)),
              );
            }
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xff1d1b20),
          body: Column(
            children: [
              // Top bar (giữ nguyên)
              Container(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.download,
                          color: Colors.white, size: 30),
                      onPressed: () {
                        print('📥 Download clicked');
                        // TODO: xử lý download
                      },
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.send, color: Colors.white, size: 30),
                      onPressed: () {
                        print('📤 Quick send clicked');
                        if (images is List<String>) {
                          images.add(widget.imagePath);
                        }
                        widget.onSend();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              // Preview (thêm error boundary cho Image.file)
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Builder(
                      builder: (context) {
                        try {
                          return Image.file(
                            File(widget.imagePath),
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              print(
                                  '❌ Image.file error: $error, stack: $stackTrace');
                              return const Center(
                                  child: Icon(Icons.error,
                                      color: Colors.red, size: 50));
                            },
                          );
                        } catch (e) {
                          print('❌ Image.file catch: $e');
                          return const Center(
                              child: Icon(Icons.error,
                                  color: Colors.red, size: 50));
                        }
                      },
                    ),
                  ),
                ),
              ),
              // Caption (giữ nguyên)
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: TextField(
                  controller: _captionController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Thêm chú thích...',
                    hintStyle: TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                    suffixIcon: Icon(Icons.send, color: Colors.white54),
                  ),
                  maxLines: null,
                ),
              ),
              // Dots (giữ nguyên)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: index == 0 ? Colors.white : Colors.white54,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
              // Bottom icons (thêm dropdown cho more_horiz)
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close,
                          color: Colors.white, size: 40),
                      onPressed: () {
                        print('❌ Close clicked - No save');
                        Navigator.pop(context);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.check,
                          color: Colors.white, size: 50),
                      onPressed: () {
                        print('✅ OK clicked - Calling upload');
                        _uploadPhoto();
                      },
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_horiz,
                          color: Colors.white, size: 40),
                      onSelected: (String value) {
                        switch (value) {
                          case 'upload_current':
                            _uploadPhoto();
                            break;
                          case 'upload_from_phone':
                            _pickAndUploadPhoto();
                            break;
                          case 'pick_only':
                            _pickImageFromGallery();
                            break;
                          case 'download':
                            _handleDownload();
                            break;
                          case 'share':
                            _handleShare();
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'upload_current',
                          child: Row(
                            children: [
                              Icon(Icons.cloud_upload),
                              SizedBox(width: 8),
                              Text('Tải ảnh hiện tại lên'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'upload_from_phone',
                          child: Row(
                            children: [
                              Icon(Icons.photo_library),
                              SizedBox(width: 8),
                              Text('Chọn & upload ảnh từ điện thoại'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'pick_only',
                          child: Row(
                            children: [
                              Icon(Icons.image_search),
                              SizedBox(width: 8),
                              Text('Chỉ chọn ảnh & xem trước'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'download',
                          child: Row(
                            children: [
                              Icon(Icons.download),
                              SizedBox(width: 8),
                              Text('Tải xuống'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'share',
                          child: Row(
                            children: [
                              Icon(Icons.share),
                              SizedBox(width: 8),
                              Text('Chia sẻ'),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
