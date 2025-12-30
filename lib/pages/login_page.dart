import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../viewmodels/user_state_viewmodel.dart';
import '../common/api_result.dart';

// 对应 RouteName 常量
class RouteName {
  static const String HOME = '/';
  // ... 其他路由
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 对应 mutableStateOf + rememberSaveable
  late final TextEditingController _hostController;
  late final TextEditingController _tokenController;
  
  // 密码可见性 (Flutter 不需要 VisualTransformation，只需 obscureText)
  bool _obscureToken = true;

  @override
  void initState() {
    super.initState();
    final vm = context.read<UserStateViewModel>();
    // 初始化 controller
    _hostController = TextEditingController(text: vm.host);
    _tokenController = TextEditingController();
  }

  @override
  void dispose() {
    _hostController.dispose();
    _tokenController.dispose();
    super.dispose();
  }

  // 对应 login() 函数
  Future<void> _handleLogin() async {
    final hostText = _hostController.text.trim();
    final tokenText = _tokenController.text.trim();

    // 1. 校验空值
    if (hostText.isEmpty || tokenText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in the login form")), // R.string.fill_login_form
      );
      return;
    }

    // 2. URL 处理 (补全 https)
    String finalHost = hostText;
    if (!finalHost.contains("//")) {
      finalHost = "https://$finalHost";
      // 更新 UI 上的文字
      _hostController.text = finalHost;
    }

    // 3. 调用 ViewModel
    final userViewModel = context.read<UserStateViewModel>();
    // 显示 Loading (可选，这里略过，直接 await)
    final result = await userViewModel.loginMonitorWithAccessToken(finalHost, tokenText);

    // 4. 处理结果 (对应 suspendOnSuccess / suspendOnErrorMessage)
    if (!mounted) return;

    result.onSuccess((data) {
      // 导航逻辑：清空栈并跳转到 HOME
      // GoRouter 的 go() 方法天然就是替换栈的逻辑 (类似 popUpTo inclusive)
      context.go(RouteName.HOME);
    });

    result.onError((message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // 获取 ViewModel 状态 (watch 用于监听变化)
    final userViewModel = context.watch<UserStateViewModel>();
    final isUserLoggedIn = userViewModel.currentUser != null;

    // 对应 R.string
    final title = isUserLoggedIn ? "Add Account" : "MonitorX";
    const infoText = "### Input Login Information\n\nPlease enter your server address and access token."; // 模拟 Markdown

    return Scaffold(
      // 使用 NestedScrollView 来模拟 LargeTopAppBar 的滚动收缩效果
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar.large(
              title: Text(title),
              centerTitle: true, // Material 3 默认可能是左对齐，这里强制居中以匹配 Android 代码
              leading: isUserLoggedIn
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      tooltip: "Back",
                      onPressed: () {
                         // popBackStackIfLifecycleIsResumed
                         if (context.canPop()) context.pop();
                      },
                    )
                  : null, // 如果没登录，不显示返回按钮
            ),
          ];
        },
        // 对应 Column + padding + alignment
        body: SingleChildScrollView( // 替换 Compose 的 Column + verticalScroll (如果有) 或用于避让键盘
          padding: const EdgeInsets.only(bottom: 100), // 给 BottomAppBar 留位置
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              
              // Markdown 组件
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: MarkdownBody(
                  data: infoText,
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(fontSize: 16),
                    textAlign: WrapAlignment.center,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // 表单区域
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    // Host Input
                    TextFormField(
                      controller: _hostController,
                      decoration: const InputDecoration(
                        labelText: "Host", // R.string.host
                        prefixIcon: Icon(Icons.computer_outlined),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.next,
                      // Flutter 自动处理 bringIntoView
                    ),
                    
                    const SizedBox(height: 16),

                    // Access Token Input
                    TextFormField(
                      controller: _tokenController,
                      obscureText: _obscureToken, // 对应 PasswordVisualTransformation
                      decoration: const InputDecoration(
                        labelText: "Access Token", // R.string.access_token
                        prefixIcon: Icon(Icons.perm_identity_outlined),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.go,
                      onFieldSubmitted: (_) => _handleLogin(), // 对应 keyboardActions onGo
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      
      // 对应 BottomAppBar
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end, // FAB 居右或根据设计调整
          children: [
            // Compose 代码中，FAB 是放在 bottomBar 参数里的
            // Flutter 中我们可以直接放在 floatingActionButton 位置，
            // 或者放在这里模拟完全一样的布局。
            // 这里使用 ExtendedFloatingActionButton 模拟
            Expanded(
               child: Align(
                 alignment: Alignment.centerRight,
                 child: FloatingActionButton.extended(
                  onPressed: _handleLogin,
                  elevation: 4, // FloatingActionButtonDefaults.bottomAppBarFabElevation
                  icon: const Icon(Icons.login_outlined), // Icons.AutoMirrored.Outlined.Login
                  label: const Text("Add Account"), // R.string.add_account
                               ),
               ),
            )
          ],
        ),
      ),
    );
  }
}