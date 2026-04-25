import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class PdfService {

  ////////////////////////////////////////////////////

  static Future<void> exportSummaryToPdf(
      String title,
      String summary,
      ) async {

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {

          return pw.Padding(
            padding:
            const pw.EdgeInsets.all(20),

            child: pw.Column(
              crossAxisAlignment:
              pw.CrossAxisAlignment.start,

              children: [

                //////////////////////////////////////
                /// TITLE

                pw.Text(
                  title,
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight:
                    pw.FontWeight.bold,
                  ),
                ),

                pw.SizedBox(height: 20),

                //////////////////////////////////////
                /// SUMMARY

                pw.Text(
                  summary,
                  style: const pw.TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    ////////////////////////////////////////////////////

    final directory =
    await getApplicationDocumentsDirectory();

    final file = File(
      "${directory.path}/$title.pdf",
    );

    await file.writeAsBytes(
      await pdf.save(),
    );

    ////////////////////////////////////////////////////

    await Share.shareXFiles(
      [XFile(file.path)],
      text: "Here is your summary PDF",
    );
  }
}