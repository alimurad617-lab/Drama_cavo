// البيانات: عدّل الروابط وضع روابطك الخاصة هنا
class Episode {
  final String title;
  final Map<int, String> streams; // الجودة -> رابط مباشر (mp4 يُفضّل للتحميل)
  const Episode(this.title, this.streams);
}

class Series {
  final String title;
  final String genre;
  final String cover; // لون الغلاف
  final List<Episode> episodes;
  const Series(this.title, this.genre, this.cover, this.episodes);
}

// رابط تجريبي عام (Big Buck Bunny - مصدر قانوني للاختبار)
// استبدل القيم بروابط المحتوى الذي تملك حقوقه.
const testUrl = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";

final demoSeries = <Series>[
  Series("الوريث المفقود", "إثارة", "#4b4b4b", [
    Episode("الحلقة 1", {480: testUrl, 720: testUrl, 1080: testUrl}),
    Episode("الحلقة 2", {480: testUrl, 720: testUrl, 1080: testUrl}),
    Episode("الحلقة 3", {480: testUrl, 720: testUrl, 1080: testUrl}),
  ]),
  Series("زواج الصفقة", "رومانسي", "#6a5a5a", [
    Episode("الحلقة 1", {480: testUrl, 720: testUrl, 1080: testUrl}),
    Episode("الحلقة 2", {480: testUrl, 720: testUrl, 1080: testUrl}),
  ]),
  Series("الانتقام الحلو", "دراما", "#5a4c4c", [
    Episode("الحلقة 1", {480: testUrl, 720: testUrl, 1080: testUrl}),
    Episode("الحلقة 2", {480: testUrl, 720: testUrl, 1080: testUrl}),
    Episode("الحلقة 3", {480: testUrl, 720: testUrl, 1080: testUrl}),
    Episode("الحلقة 4", {480: testUrl, 720: testUrl, 1080: testUrl}),
  ]),
];
