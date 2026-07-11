import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/tool_registry.dart';
import '../models/tool_info.dart';
import '../../features/home/home_shell.dart';
import '../../features/home/category_screen.dart';
import '../../features/search/search_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeShell()),
    GoRoute(
      path: '/category/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final category = ToolCategory.values.firstWhere((c) => c.name == id, orElse: () => ToolCategory.text);
        return CategoryScreen(category: category);
      },
    ),
    GoRoute(path: '/search', builder: (context, state) => const SearchScreen()),
    GoRoute(
      path: '/tool/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final tool = findTool(id);
        if (tool == null) {
          return Scaffold(appBar: AppBar(), body: const Center(child: Text('工具不存在')));
        }
        return tool.builder(context);
      },
    ),
  ],
);
