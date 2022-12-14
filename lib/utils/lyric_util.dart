import 'package:weapon/model/lyric.dart';

class LyricUtil {
  /// 格式化歌词
  static List<Lyric> formatLyric(String? lyricStr) {
    if (lyricStr == null || lyricStr.isEmpty) return [];
    // print("lyricStr： " + lyricStr);
    RegExp reg = RegExp(r"^\[\d{2}");
    List<Lyric> result =
        lyricStr.split("\n").where((r) => reg.hasMatch(r)).map((s) {
      String time = s.substring(0, s.indexOf(']'));
      String lyric = s.substring(s.indexOf(']') + 1);
      time = s.substring(1, time.length);
      int hourSeparatorIndex = time.indexOf(":");
      int minuteSeparatorIndex = time.indexOf(".");
      // print("time:$time; hourSeparatorIndex:$hourSeparatorIndex; minuteSeparatorIndex:$minuteSeparatorIndex");
      if (hourSeparatorIndex > 0 && minuteSeparatorIndex > 0) {
        return Lyric(
          lyric: lyric,
          startTime: Duration(
            minutes: int.parse(
              time.substring(0, hourSeparatorIndex),
            ),
            seconds: int.parse(
                time.substring(hourSeparatorIndex + 1, minuteSeparatorIndex)),
            milliseconds: int.parse(time.substring(minuteSeparatorIndex + 1)),
          ),
        );
      }
      return Lyric(lyric: '');
    }).toList();

    for (int i = 0; i < result.length - 1; i++) {
      result[i].endTime = result[i + 1].startTime;
    }
    result[result.length - 1].endTime = const Duration(hours: 1);
    return result;
  }

  /// 查找歌词
  static int findLyricIndex(double curDuration, List<Lyric> lyrics) {
    for (int i = 0; i < lyrics.length; i++) {
      if (curDuration >= (lyrics[i].startTime?.inMilliseconds ?? 0) &&
          curDuration <= (lyrics[i].endTime?.inMilliseconds ?? 0)) {
        return i;
      }
    }
    return 0;
  }
}
