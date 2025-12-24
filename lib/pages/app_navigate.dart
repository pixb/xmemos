import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';

import '../theme/moe_memos_theme.dart';
import '../viewmodels/user_state_viewmodel.dart';
import 'login_page.dart';
import 'home_page.dart';

// 对应 RouteName object  
class RouteName {  
  static const String MEMOS = '/';  
  static const String SETTINGS = '/settings';  
  static const String LOGIN = '/login';  
  static const String INPUT = '/input';  
  static const String SHARE = '/share';  
  static const String EDIT = '/edit';  
  static const String RESOURCE = '/resource';  
  static const String ACCOUNT = '/account';  
  static const String SEARCH = '/search';  
}

class MoeMemosApp extends StatefulWidget {  
  const MoeMemosApp({super.key});  
  
  @override  
  State<MoeMemosApp> createState() => _MoeMemosAppState();  
} 

// app widget state
class _MoeMemosAppState extends State<MoeMemosApp> {  
  StreamSubscription? _sub;  
  
  @override  
  void initState() {  
    super.initState();  
    // 处理外部 Intent / Deep Links (对应 Android 的 handleIntent)  
    _initDeepLinkListener();  
  }  
  
  @override  
  void dispose() {  
    _sub?.cancel();  
    super.dispose();  
  }  
  
  // 对应 LaunchedEffect(context) 中的 Intent 处理
  void _initDeepLinkListener() {
    // 仅在非Web平台初始化深度链接监听
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      // 监听传入的链接/Intent
      _sub = uriLinkStream.listen((Uri? uri) {
        if (uri == null) return;
        _handleDeepLink(uri);
      }, onError: (err) {
        // Handle error
        print('Deep link error: $err');
      });
    }
  }  
    
  void _handleDeepLink(Uri uri) {  
     // 这里根据 uri.path 或 queryParameters 跳转  
     // 例如: if (uri.path == '/compose') router.push(RouteName.INPUT);  
     // Flutter 处理原生 Intent 通常需要配置 AndroidManifest 和 Info.plist  
  }  
  
  // 路由配置 (对应 NavHost)  
  final GoRouter _router = GoRouter(  
    initialLocation: RouteName.MEMOS,  
    redirect: (BuildContext context, GoRouterState state) async {  
       // 对应 LaunchedEffect 中的 suspendOnNotLogin 逻辑  
       final userState = Provider.of<UserStateViewModel>(context, listen: false);  
       final isLoggedIn = userState.isLoggedIn;   
         
       // 如果未登录且不在登录页，重定向到登录  
       if (!isLoggedIn && state.matchedLocation != RouteName.LOGIN) {  
         return RouteName.LOGIN;  
       }  
       return null;   
    },  
    routes: [
      // 1. HomePage (Start Destination)
      GoRoute(
        path: RouteName.MEMOS,
        pageBuilder: (context, state) => _buildPageWithTransition(const HomePage()),
      ),  
        
      // 2. SettingsPage  
      // GoRoute(  
      //   path: RouteName.SETTINGS,  
      //   pageBuilder: (context, state) => _buildPageWithTransition(const SettingsPage()),  
      // ),  
  
      // 3. LoginPage  
      GoRoute(  
        path: RouteName.LOGIN,  
        pageBuilder: (context, state) => _buildPageWithTransition(const LoginPage()),  
      ),  
  
      // 4. MemoInputPage (Normal)  
      // GoRoute(  
      //   path: RouteName.INPUT,  
      //   pageBuilder: (context, state) => _buildPageWithTransition(const MemoInputPage()),  
      // ),  
        
      // 5. Share Page (MemoInputPage with content)  
      // GoRoute(  
      //   path: RouteName.SHARE,  
      //   pageBuilder: (context, state) {  
      //      // 需要通过 extra 传递 ShareContent 对象  
      //      final shareContent = state.extra as ShareContent?;  
      //      return _buildPageWithTransition(MemoInputPage(shareContent: shareContent));  
      //   },  
      // ),  
  
      // 6. Edit Page (MemoInputPage with ID)  
      // 对应: "${RouteName.EDIT}?memoId={id}"  
      // GoRoute(  
      //   path: RouteName.EDIT,  
      //   pageBuilder: (context, state) {  
      //     final memoId = state.uri.queryParameters['memoId'];  
      //     return _buildPageWithTransition(MemoInputPage(memoIdentifier: memoId));  
      //   },  
      // ),  
  
      // 7. ResourceListPage  
      // GoRoute(  
      //   path: RouteName.RESOURCE,  
      //   pageBuilder: (context, state) => _buildPageWithTransition(const ResourceListPage()),  
      // ),  
  
      // // 8. AccountPage  
      // // 对应: "${RouteName.ACCOUNT}?accountKey={accountKey}"  
      // GoRoute(  
      //   path: RouteName.ACCOUNT,  
      //   pageBuilder: (context, state) {  
      //      final accountKey = state.uri.queryParameters['accountKey'] ?? "";  
      //      return _buildPageWithTransition(AccountPage(selectedAccountKey: accountKey));  
      //   },  
      // ),  
  
      // 9. SearchPage  
      // GoRoute(  
      //   path: RouteName.SEARCH,  
      //   pageBuilder: (context, state) => _buildPageWithTransition(const SearchPage()),  
      // ),  
    ],  
  );  
  
  // 对应 enterTransition / exitTransition 的 slide + fade 动画  
  static CustomTransitionPage _buildPageWithTransition(Widget child) {  
    return CustomTransitionPage(  
      child: child,  
      transitionsBuilder: (context, animation, secondaryAnimation, child) {  
        const begin = Offset(0.0, 0.25); // initialOffset = it / 4 (大致估算)  
        const end = Offset.zero;  
        const curve = Curves.ease;  
  
        var slideTween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));  
        var fadeTween = Tween(begin: 0.0, end: 1.0);  
  
        return SlideTransition(  
          position: animation.drive(slideTween),  
          child: FadeTransition(  
            opacity: animation.drive(fadeTween),  
            child: child,  
          ),  
        );  
      },  
    );  
  }  
  
  @override
  Widget build(BuildContext context) {
    // 对应 MoeMemosTheme
    return ChangeNotifierProvider(
      create: (_) => UserStateViewModel(),
      child: MaterialApp.router(
        title: 'Moe Memos',
        theme: MoeMemosTheme.light, // 你需要自定义的主题
        darkTheme: MoeMemosTheme.dark,
        routerConfig: _router,
        // 对应 Modifier.background(MaterialTheme.colorScheme.surface)
        // 在 Flutter 中通常由 Scaffold 的 backgroundColor 决定
      ),
    );
  }  
}
