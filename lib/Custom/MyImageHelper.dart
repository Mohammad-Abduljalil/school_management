import 'package:flutter/material.dart';
import 'package:school_management/core/AppConstants.dart';

class MyImageHelper {
  static ImageProvider? buildImageProvider(String? path) {
    if (path == null || path.isEmpty) {
      return null;
    }

    if (path.startsWith('http')) {
      return NetworkImage(path);
    }

    if (path.startsWith('images/') || path.startsWith('assets/') || path.startsWith('images\\')) {
      return AssetImage(path.replaceAll('\\', '/'));
    }

    String cleanPath = path.startsWith('/') ? path.substring(1) : path;
    return NetworkImage("${AppConstants.linkStorage}$cleanPath");
  }

  static Widget buildCircleAvatar({String? path, double radius = 25, IconData fallbackIcon = Icons.person}) {
    final provider = buildImageProvider(path);
    
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[200],
      backgroundImage: provider,
      child: provider == null ? Icon(fallbackIcon, color: Colors.grey, size: radius * 0.8) : null,
    );
  }
}
