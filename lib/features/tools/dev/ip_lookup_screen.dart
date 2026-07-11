import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../../core/widgets/tool_page_scaffold.dart';
import '../../../core/widgets/result_actions_bar.dart';
import '../../../core/providers/settings_providers.dart';

/// IP 地址查看：这是本 App 中少数需要联网的工具之一（查询公网 IP 必须依赖远程服务）。
class IpLookupScreen extends ConsumerStatefulWidget {
  const IpLookupScreen({super.key});
  @override
  ConsumerState<IpLookupScreen> createState() => _State();
}

class _State extends ConsumerState<IpLookupScreen> {
  bool _loading = false;
  String _result = '';
  String? _error;

  Future<void> _lookup() async {
    setState(() {
      _loading = true;
      _error = null;
      _result = '';
    });
    try {
      final resp = await http.get(Uri.parse('https://ipapi.co/json/')).timeout(const Duration(seconds: 8));
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body) as Map<String, dynamic>;
        setState(() => _result = [
              'IP：${data['ip'] ?? '-'}',
              '国家/地区：${data['country_name'] ?? '-'}',
              '城市：${data['city'] ?? '-'}',
              '运营商：${data['org'] ?? '-'}',
              '时区：${data['timezone'] ?? '-'}',
            ].join('\n'));
      } else {
        setState(() => _error = '查询失败，状态码：${resp.statusCode}');
      }
    } catch (e) {
      setState(() => _error = '查询失败，请检查网络连接：$e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ToolPageScaffold(
      toolId: 'dev_ip',
      titleKey: 'dev_ip',
      showNetworkBadge: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilledButton.icon(
            onPressed: _loading ? null : _lookup,
            icon: _loading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.public),
            label: const Text('查询我的公网 IP'),
          ),
          if (_error != null) ...[
            const SizedBox(height: 16),
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ],
          if (_result.isNotEmpty) ...[
            const SizedBox(height: 16),
            Card(child: Padding(padding: const EdgeInsets.all(16), child: SelectableText(_result))),
            const SizedBox(height: 8),
            ResultActionsBar(copyText: _result),
          ],
        ],
      ),
    );
  }
}
