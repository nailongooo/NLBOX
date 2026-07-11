import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/tool_page_scaffold.dart';
import '../../../core/widgets/result_actions_bar.dart';
import '../../../core/providers/settings_providers.dart';
import '../../../core/utils/device_info_util.dart';

class UserAgentScreen extends ConsumerStatefulWidget {
  const UserAgentScreen({super.key});
  @override
  ConsumerState<UserAgentScreen> createState() => _State();
}

class _State extends ConsumerState<UserAgentScreen> {
  String _info = '加载中...';

  @override
  void initState() {
    super.initState();
    getDeviceInfo().then((v) => mounted ? setState(() => _info = v) : null);
  }

  @override
  Widget build(BuildContext context) {
    return ToolPageScaffold(
      toolId: 'dev_user_agent',
      titleKey: 'dev_user_agent',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(child: Padding(padding: const EdgeInsets.all(16), child: SelectableText(_info))),
          const SizedBox(height: 8),
          const Text('提示：Web 版会显示浏览器 User-Agent；移动端/桌面端会显示操作系统与设备信息（Flutter App 本身没有浏览器 UA 的概念）。', style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 8),
          ResultActionsBar(copyText: _info),
        ],
      ),
    );
  }
}
