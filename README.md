# locket_beta

# Mô tả
Project Flutter tên `locket_beta`. README này hướng dẫn nhanh cách chuẩn bị môi trường, cách chạy sau khi clone/pull và một số lưu ý khi làm việc với Git.

# Yêu cầu
- Flutter SDK (phiên bản compatible với project) — https://flutter.dev
- Android SDK / Android Studio (để chạy Android)
- (macOS only) Xcode để chạy iOS
- (Windows) Visual Studio workload "Desktop development with C++" nếu chạy Windows desktop

# Thiết lập ban đầu (sau khi clone hoặc pull)
1. Kiểm tra môi trường:
   - flutter doctor
   - flutter doctor --android-licenses (chấp nhận license nếu cần)
2. Lấy dependencies:
   - ở thư mục project root: flutter pub get
3. Platform-specific:
   - Android: mở project bằng Android Studio để tự tạo `local.properties` hoặc tạo thủ công (hoặc có thể mở dự án cũ và copy vào):
     - sdk.dir=C:\\Path\\To\\Android\\sdk 
     - vd :
        sdk.dir=C:\\Users\\ACER\\AppData\\Local\\Android\\sdk
        flutter.sdk=D:\\Downloads\\setupFlutterAndroid\\flutter
4. Chạy app:
   - flutter run
