import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DownloadItem {
  final String key;      // series/episode/quality
  final String title;
  final int quality;
  double progress;
  String? path;
  bool done;
  bool failed;

  DownloadItem({
    required this.key, required this.title, required this.quality,
    this.progress = 0, this.path, this.done = false, this.failed = false,
  });

  Map<String, dynamic> toJson() => {
    'key': key, 'title': title, 'quality': quality, 'path': path, 'done': done,
  };
  factory DownloadItem.fromJson(Map<String, dynamic> j) => DownloadItem(
    key: j['key'], title: j['title'], quality: j['quality'],
    path: j['path'], done: j['done'] ?? false,
  );
}

class Downloader {
  Downloader._();
  static final Downloader instance = Downloader._();
  final _dio = Dio();
  final items = ValueNotifier<Map<String, DownloadItem>>({});
  final _tasks = <String, CancelToken>{};

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString('downloads') ?? '[]';
    try {
      final list = (jsonDecode(raw) as List).map((e) => DownloadItem.fromJson(e)).toList();
      items.value = {for (var e in list) e.key: e};
    } catch (_) {}
  }

  Future<void> _save() async {
    final p = await SharedPreferences.getInstance();
    p.setString('downloads', jsonEncode(items.value.values.toList()));
  }

  Future<void> start(String key, String title, int quality, String url) async {
    if (items.value[key]?.done ?? false) return;
    final dir = await getApplicationDocumentsDirectory();
    final folder = Directory('${dir.path}/downloads');
    await folder.create(recursive: true);
    final path = '${folder.path}/$key.mp4';

    final it = DownloadItem(key: key, title: title, quality: quality);
    items.value = {...items.value, key: it};
    _save();

    final ct = CancelToken();
    _tasks[key] = ct;
    try {
      await _dio.download(url, path, cancelToken: ct,
        onReceiveProgress: (rec, tot) {
          it.progress = tot <= 0 ? 0 : rec / tot;
          items.value = {...items.value};
        });
      it.done = true;
      it.path = path;
      items.value = {...items.value};
      _save();
    } catch (_) {
      it.failed = true;
      items.value = {...items.value};
    }
    _tasks.remove(key);
  }

  Future<void> remove(String key) async {
    _tasks[key]?.cancel();
    final it = items.value[key];
    if (it?.path != null) {
      try { await File(it!.path!).delete(); } catch (_) {}
    }
    items.value = {...items.value}..remove(key);
    _save();
  }
}
