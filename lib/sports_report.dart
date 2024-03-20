import 'package:flutter/material.dart';
import 'package:gradproj/constants.dart';

class SportsReport extends StatefulWidget {
  @override
  _SportsReportState createState() => _SportsReportState();
}

class _SportsReportState extends State<SportsReport> {
  int _currentIndex = 0;
  DateTime selectedDate = DateTime.now();
  List<String> sport_name = ['Walking','Dancing','Workouts'];
  List<String> sport_kind = ['1 Mile','Zomba','Dynamic Chest'];
  List<String> sport_kcal = ['100','150 - 200','4.6'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //automaticallyImplyLeading: false,
          title: Text(
            'Sports',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

        ),
        body: _reportPageWidget(),
    );

  }
Widget _reportPageWidget(){
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(80, 30, 0, 20),
          child: Row(
              children: [
                Text(
                    'select date',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16

                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child:  GestureDetector(
                      onTap: () async {
                        final DateTime? dateTime = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(3000)
                        );
                        if(dateTime != null){
                          setState(() {
                            selectedDate = dateTime;
                          });
                        }
                      },
                      child: Container(
                        width: 140,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Color(0xFFFBFDFF),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],

                        ),
                        child: Padding(padding: EdgeInsets.all(15),
                        child: Text(
                          '${selectedDate.year} - ${selectedDate.month} - ${selectedDate.day}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
  ),
                      ),
                    )),
              ]),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            children: [
              Text(
                'Total',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20

                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                child:               Text(
                  '304.6'+' KCal',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.red

                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context,index){
                _currentIndex = index;
                return Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 20) ,
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Color(0xFFFBFDFF),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],

                      ),
                          child: Column(
                          children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(30, 20, 0, 0),
                         child: Row(
                         children: [
                           Text(
                             'Sport',
                           style: TextStyle(
                             fontSize: 16,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                           Padding(
                               padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
                               child: Text(
                             'Kind',
                             style: TextStyle(
                               fontSize: 16,
                               fontWeight: FontWeight.bold,
                             ),
                           )),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(70, 0, 0, 0),
                                  child: Text(
                             'KCal',
                             style: TextStyle(
                               fontSize: 16,
                               fontWeight: FontWeight.bold,
                             ),
                           )),
                            ]
                          )),
                           Padding(
                               padding: EdgeInsets.fromLTRB(30, 10, 0, 0),
                           child: Row(
                             children: [
                               Text(
                                   sport_name[_currentIndex],
                                 style: TextStyle(
                                   fontWeight: FontWeight.bold,
                                   color: kButtonColor,
                                 ),
                               ),
                                   Row(
                                     children: [
                                       Padding(
                                         padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                         child:  Text(
                                           sport_kind[_currentIndex],
                                         style: TextStyle(
                                           fontWeight: FontWeight.bold,
                                           color: kButtonColor,
                                         ),
                                       )),

                                       Padding(
                                         padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
                                         child: Text(
                                         sport_kcal[_currentIndex],
                                         style: TextStyle(
                                           fontWeight: FontWeight.bold,
                                           color: Colors.red,
                                         ),
                                       )),
                                     ],
                                   ),

                             ],
                           )
                           ),



                            ]),
                      )
                );
              }
          ),
        ),

      ],
    );
}
}