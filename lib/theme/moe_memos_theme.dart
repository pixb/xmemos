import 'package:flutter/material.dart';  
  
class MoeMemosTheme {  
  // 1. 定义核心颜色 (种子颜色)  
  // 你可以根据你的 App 品牌色修改这里  
  static const Color _seedColor = Color(0xFF6750A4); // 比如紫色系  
  
  // 2. 亮色模式 (Light Theme) 配置  
  static ThemeData get light {  
    return ThemeData(  
      useMaterial3: true, // 开启 Material 3 支持  
      colorScheme: ColorScheme.fromSeed(  
        seedColor: _seedColor,  
        brightness: Brightness.light,  
        // 如果需要微调特定颜色，可以在这里覆盖：  
        // primary: Colors.blue,  
        // surface: Colors.white,  
      ),  
        
      // 自定义 AppBar 样式  
      appBarTheme: const AppBarTheme(  
        centerTitle: true,  
        elevation: 0,  
        backgroundColor: Colors.transparent, // 透明背景  
        foregroundColor: Colors.black,       // 文字颜色  
      ),  
  
      // 自定义 FloatingActionButton 样式  
      floatingActionButtonTheme: FloatingActionButtonThemeData(  
        backgroundColor: _seedColor,  
        foregroundColor: Colors.white,  
        elevation: 4,  
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),  
      ),  
  
      // 自定义卡片样式  
      cardTheme: CardThemeData(
        elevation: 2,  
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(8),  
      ),  
        
      // 自定义字体样式  
      textTheme: const TextTheme(  
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),  
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),  
        bodyMedium: TextStyle(fontSize: 14, height: 1.5), // 正文常用  
      ),  
    );  
  }  
  
  // 3. 暗色模式 (Dark Theme) 配置  
  static ThemeData get dark {  
    return ThemeData(  
      useMaterial3: true,  
      colorScheme: ColorScheme.fromSeed(  
        seedColor: _seedColor,  
        brightness: Brightness.dark, // 关键点：设置为暗色  
        // surface: const Color(0xFF121212), // 比如纯黑背景  
      ),  
  
      appBarTheme: const AppBarTheme(  
        centerTitle: true,  
        elevation: 0,  
        backgroundColor: Colors.transparent,  
        foregroundColor: Colors.white,  
      ),  
  
      floatingActionButtonTheme: FloatingActionButtonThemeData(  
        backgroundColor: _seedColor.withOpacity(0.8), // 暗色模式下稍微柔和一点  
        foregroundColor: Colors.white,  
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),  
      ),  
    );  
  }  
}