import 'package:pdfx/pdfx.dart';
import 'package:http/http.dart' as http;

class PdfApi {
  /// Mở PDF từ assets
  static Future<PdfDocument> loadFromAssets(String path) async {
    return PdfDocument.openAsset(path);
  }

  /// Mở PDF từ file local
  static Future<PdfDocument> loadFromFile(String filePath) async {
    return PdfDocument.openFile(filePath);
  }

  /// Mở PDF từ URL (tải về rồi mở)
  static Future<PdfDocument> loadFromUrl(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return PdfDocument.openData(response.bodyBytes);
    } else {
      throw Exception('Không tải được PDF');
    }
  }
}