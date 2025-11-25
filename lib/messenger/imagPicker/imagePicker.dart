import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

class ImagePickerWidget extends StatefulWidget {
  String chatId;
  String senderId;

  ImagePickerWidget({
    Key? key,
    required this.chatId,
    required this.senderId
  }) :super(key: key);
  @override
  State<ImagePickerWidget> createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePickerWidget> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8000'));

  Future<void> _pickFromGallery() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      imageQuality: 80, // nén đơn giản
    );
    if (file == null) return;
    setState(() => _image = File(file.path));
  }

  Future<void> _takePhoto() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1600,
      imageQuality: 80,
    );
    if (file == null) return;
    setState(() => _image = File(file.path));
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;
    final form = FormData.fromMap({
      'file': await MultipartFile.fromFile(_image!.path, filename: 'upload.jpg'),
      'chatId': widget.chatId,   
      'userId': widget.senderId,
    });
    print("imagePicker: CHat ID = " + widget.chatId);
    try {
      final resp = await _dio.post('/api/messages/uploads/image', data: form);
      if (resp.statusCode == 200) {
        final secureUrl = resp.data['fileUrl'];
        print('Uploaded: $secureUrl');
        // gửi message qua websocket hoặc lưu vào state
      } else {
        print('Upload failed: ${resp.statusCode} ${resp.data}');
      }
    } on DioException catch (e) {
      print('Dio error: ${e.message} resp=${e.response?.data}');
    } catch (e) {
      print('Upload error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_image != null) Image.file(_image!, width: 200, height: 200, fit: BoxFit.cover),
        Row(
          children: [
            ElevatedButton(onPressed: _pickFromGallery, child: const Text('Gallery')),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: _takePhoto, child: const Text('Camera')),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: _uploadImage, child: const Text('Upload')),
          ],
        ),
      ],
    );
  }
}