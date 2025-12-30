import 'package:flutter/foundation.dart';
import '../common/api_result.dart';
import '../models/user.dart';

// 对应 Android 中的 UserStateViewModel
class UserStateViewModel extends ChangeNotifier {
  
  // 内部状态
  User? _currentUser;
  bool _isLoading = true; // 初始状态为加载中
  
    // 用于 UI 回显之前的 host (如果有)  
  String _host = "";   
  String get host => _host; 

  // 公开的 Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  
  // 核心属性：判断是否登录
  // 对应 Android 代码逻辑：if (navController.currentDestination?.route != RouteName.LOGIN)
  bool get isLoggedIn => _currentUser != null;

  // 1. 加载当前用户 (对应 loadCurrentUser)
  // 通常在 App 启动时调用，检查本地是否有 Token
  Future<void> loadCurrentUser() async {
    _isLoading = true;
    notifyListeners(); // 通知 UI 显示 Loading 状态

    try {
      // TODO: 这里实现读取本地存储 (SharedPreference/FlutterSecureStorage)
      // 模拟网络/IO 延迟
      await Future.delayed(const Duration(milliseconds: 500));

      // 假设我们从本地读到了 Token 并验证成功
      // _currentUser = await UserApi.fetchProfile(); 
      // 如果没有 Token，_currentUser 保持为 null
      
      print("User state loaded.");
    } catch (e) {
      print("Error loading user: $e");
    } finally {
      _isLoading = false;
      notifyListeners(); // 关键：加载完成后通知 GoRouter 重新评估路由重定向
    }
  }

    // 模拟登录逻辑  
  Future<ApiResult<User>> loginMonitorWithAccessToken(String hostUrl, String token) async {  
    try {  
      // 模拟网络延迟  
      await Future.delayed(const Duration(seconds: 1));  
  
      // 简单的验证逻辑 (模拟)  
      if (token.length < 3) {  
        return ApiError("Invalid Access Token");  
      }  
  
      final user = User(id: "1", host: hostUrl, token: token, username: '', avatarUrl: '');  
      _currentUser = user;  
      _host = hostUrl; // 记住 host  
        
      notifyListeners();  
      return ApiSuccess(user);  
    } catch (e) {  
      return ApiError("Network error: $e");  
    }  
  }  
  
  void logout() {  
    _currentUser = null;  
    notifyListeners();  
  } 
}