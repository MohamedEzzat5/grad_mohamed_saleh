import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradproj/widgets/cards.dart';
import 'package:gradproj/widgets/icons.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../core/widgets/style.dart';
import '../../theme/constants.dart';
import '../../widgets/text.dart';
import 'A1CPLUS.dart';
import 'PostprandialPlus.dart';

class Postprandial extends StatefulWidget {
  const Postprandial({super.key});

  @override
  State<Postprandial> createState() => _PostprandialState();
}

class _PostprandialState extends State<Postprandial> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> deleteTest(
      String userId, List<Map<String, dynamic>> a1cTests, int index) async {
    try {
      a1cTests.removeAt(index);
      await FirebaseFirestore.instance
          .collection('postprandial')
          .doc(userId)
          .update({'tests': a1cTests});
      setState(() {});
    } catch (e) {
      print('Failed to delete postprandial test: $e');
    }
  }

  Future<void> generatePdf(List<Map<String, dynamic>> postprandialTests) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: postprandialTests.map((test) {
              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 20),
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black),
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Date: ${test['date']}',
                        style: const pw.TextStyle(fontSize: 18)),
                    pw.Text('Time: ${test['time']}',
                        style: const pw.TextStyle(fontSize: 18)),
                    pw.Text('blood Sugar: ${test['bloodSugar']}%',
                        style: const pw.TextStyle(fontSize: 18)),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );

    await Printing.sharePdf(
        bytes: await pdf.save(), filename: 'postprandial.pdf');
  }

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: kButtonColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const TextTitle(
              text: 'Postprandial',
              textcolor: Colors.white,
            ),
            GestureDetector(
              onTap: () async {
                List<Map<String, dynamic>> a1cTests = [];
                DocumentSnapshot userDoc = await FirebaseFirestore.instance
                    .collection('A1C')
                    .doc(userId)
                    .get();
                if (userDoc.exists) {
                  a1cTests = List<Map<String, dynamic>>.from(userDoc['tests']);
                }
                await generatePdf(a1cTests);
              },
              child: const Icon(
                Icons.download_sharp,
                color: Colors.white,
                size: 25,
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('postprandial')
            .doc(userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Center(
                    child: Text(
                  'No postprandial data found, please add your tests!',
                  style: Styles.textStyle18,
                )),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: RawMaterialButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const PostprandialPlus(),
                      ));
                    },
                    elevation: 2.0,
                    fillColor: kButtonColor,
                    padding: const EdgeInsets.all(15.0),
                    shape: const CircleBorder(),
                    child: const Icon(
                      Icons.add,
                      color: Color.fromARGB(255, 255, 255, 255),
                      size: 35.0,
                    ),
                  ),
                ),
              ],
            );
          }

          List<Map<String, dynamic>> a1cTests =
              List<Map<String, dynamic>>.from(snapshot.data!['tests']);

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: a1cTests.length,
                  itemBuilder: (context, index) {
                    return CustomCard(
                      card_content: _content(a1cTests, index),
                      card_height: 150,
                      card_action: () {},
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: RawMaterialButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const PostprandialPlus(),
                    ));
                  },
                  elevation: 2.0,
                  fillColor: kButtonColor,
                  padding: const EdgeInsets.all(15.0),
                  shape: const CircleBorder(),
                  child: const Icon(
                    Icons.add,
                    color: Color.fromARGB(255, 255, 255, 255),
                    size: 35.0,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _content(List<Map<String, dynamic>> a1cTests, int index) {
    var test = a1cTests[index];
    String userId = FirebaseAuth.instance.currentUser!.uid;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15, left: 20),
          child: Row(
            children: [
              NormalText(
                text: test['date'],
                textcolor: Colors.black,
                weight: FontWeight.normal,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50),
                child: NormalText(
                  text: test['time'],
                  textcolor: Colors.black,
                  weight: FontWeight.normal,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: SmallIcon(
                  icon_name: Icons.delete,
                  action: () async {
                    await deleteTest(userId, a1cTests, index);
                  },
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Row(
                children: [
                  Image.asset(
                    'images/testimg.jpg',
                    width: 100,
                    height: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 60),
                              child: NormalText(
                                text: 'blood sugar',
                                textcolor: kButtonColor,
                                weight: FontWeight.normal,
                              ),
                            ),
                            NormalText(
                              text: test['bloodSugar'] + ' mmol',
                              textcolor: kButtonColor,
                              weight: FontWeight.normal,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
