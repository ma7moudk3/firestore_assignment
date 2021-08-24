import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var city, country;
  var setDefaultcity = true, setDefaultcountry = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('carMake')
                    .orderBy('name')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) return Container();
                  if (setDefaultcity) {
                    city = snapshot.data.docs[0].get('name');
                    debugPrint('setDefault make: $city');
                  }
                  return DropdownButton(
                    isExpanded: false,
                    value: city,
                    items: snapshot.data.docs.map((value) {
                      return DropdownMenuItem(
                        value: value.get('name'),
                        child: Text('${value.get('name')}'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      debugPrint('selected onchange: $value');
                      setState(
                        () {
                          debugPrint('make selected: $value');
                          city = value;
                          setDefaultcity = false;
                          setDefaultcountry = true;
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: city != null
                  ? StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('cities')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                      
                        if (setDefaultcountry) {
                          country = snapshot.data.docs[0].get('city');
                        }
                        return DropdownButton(
                          isExpanded: false,
                          value: country,
                          items: snapshot.data.docs.map((value) {
                            return DropdownMenuItem(
                              value: value.get('city'),
                              child: Text(
                                '${value.get('city')}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
              
                        );
                      },
                    )
                  : Container(
                      child: Text('carMake null carMake: $city makeModel: $country'),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}