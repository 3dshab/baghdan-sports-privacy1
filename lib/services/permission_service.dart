import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PermissionService {
  static const String _permissionsRequestedKey = 'permissions_requested';
  
  /// Check if permissions have been requested before
  static Future<bool> hasRequestedPermissions() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_permissionsRequestedKey) ?? false;
  }
  
  /// Mark permissions as requested
  static Future<void> markPermissionsAsRequested() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_permissionsRequestedKey, true);
  }
  
  /// Request all necessary permissions for the app
  static Future<Map<String, bool>> requestAllPermissions() async {
    final results = <String, bool>{};
    
    // Storage permissions (for older Android versions)
    if (await Permission.storage.isPermanentlyDenied == false) {
      final storageStatus = await Permission.storage.request();
      results['storage'] = storageStatus.isGranted;
    }
    
    // Photos permission (for Android 13+)
    if (await Permission.photos.isPermanentlyDenied == false) {
      final photosStatus = await Permission.photos.request();
      results['photos'] = photosStatus.isGranted;
    }
    
    // Videos permission (for Android 13+)
    if (await Permission.videos.isPermanentlyDenied == false) {
      final videosStatus = await Permission.videos.request();
      results['videos'] = videosStatus.isGranted;
    }
    
    // Camera permission (if needed for future features)
    if (await Permission.camera.isPermanentlyDenied == false) {
      final cameraStatus = await Permission.camera.request();
      results['camera'] = cameraStatus.isGranted;
    }
    
    // Notification permission (for Android 13+)
    if (await Permission.notification.isPermanentlyDenied == false) {
      final notificationStatus = await Permission.notification.request();
      results['notification'] = notificationStatus.isGranted;
    }
    
    await markPermissionsAsRequested();
    return results;
  }
  
  /// Request storage and media permissions with dialog
  static Future<bool> requestPermissionsWithDialog() async {
    // Request storage permissions
    final storageStatus = await Permission.storage.request();
    
    // For Android 13+ (API 33+), also request media permissions
    final photosStatus = await Permission.photos.request();
    final videosStatus = await Permission.videos.request();
    
    // Check if at least one permission is granted
    return storageStatus.isGranted || 
           photosStatus.isGranted || 
           videosStatus.isGranted;
  }
  
  /// Check if storage permissions are granted
  static Future<bool> hasStoragePermission() async {
    final storageStatus = await Permission.storage.status;
    final photosStatus = await Permission.photos.status;
    final videosStatus = await Permission.videos.status;
    
    return storageStatus.isGranted || 
           photosStatus.isGranted || 
           videosStatus.isGranted;
  }
  
  /// Check if all critical permissions are granted
  static Future<bool> hasAllCriticalPermissions() async {
    final storage = await Permission.storage.status;
    final photos = await Permission.photos.status;
    final videos = await Permission.videos.status;
    
    // At least one storage-related permission should be granted
    return storage.isGranted || photos.isGranted || videos.isGranted;
  }
  
  /// Open app settings
  static Future<void> openSettings() async {
    await openAppSettings();
  }
}
