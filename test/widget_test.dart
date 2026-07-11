// 基础冒烟测试：确保 App 能正常启动并渲染首页，不涉及具体业务逻辑断言。
//
// 说明：这里特意在压缩包里放一份自己的测试文件。如果不放，`flutter create` 在
// 补全平台工程目录时会自动生成一份引用了默认计数器 Demo（MyApp）的模板测试文件，
// 而我们的入口 Widget 叫 NaiLongApp，会导致 `flutter test` 直接报错。
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nailong_toolbox/app.dart';
import 'package:nailong_toolbox/core/providers/settings_providers.dart';

void main() {
  testWidgets('App 能正常启动并显示首页标题', (WidgetTester tester) async {
    // 测试环境下用内存实现替代真实的 SharedPreferences
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const NaiLongApp(),
      ),
    );
    await tester.pumpAndSettle();

    // 首次启动会先看到新手引导页，点击"开始使用"/"跳过"后应该能看到首页标题
    final skipOrStart = find.text('跳过');
    if (skipOrStart.evaluate().isNotEmpty) {
      await tester.tap(skipOrStart);
      await tester.pumpAndSettle();
    }

    expect(find.text('奶龙工具箱'), findsWidgets);
  });
}
