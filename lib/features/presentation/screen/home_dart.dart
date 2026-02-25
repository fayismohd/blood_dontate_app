import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final CollectionReference donor =
      FirebaseFirestore.instance.collection('donor');

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Blood Donation App',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add, size: 40, color: Colors.white),
      ),

      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat,

      body: StreamBuilder<QuerySnapshot>(

        stream: donor.orderBy('name').snapshots(),

        builder: (context, snapshot) {

          /// Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          /// Empty state
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No donors found",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          /// Data loaded
          final docs = snapshot.data!.docs;

          return ListView.builder(

            padding: const EdgeInsets.only(bottom: 80),

            itemCount: docs.length,

            itemBuilder: (context, index) {

              final doc = docs[index];

              return Padding(
                padding: const EdgeInsets.all(10),

                child: Container(

                  padding: const EdgeInsets.all(10),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                    ],
                  ),

                  child: Row(

                    children: [

                      /// Blood group avatar
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.red,
                        child: Text(
                          doc['group'].toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(width: 15),

                      /// Name & Phone
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [

                            Text(
                              doc['name'].toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              doc['phone'].toString(),
                              style: const TextStyle(fontSize: 16),
                            ),

                          ],
                        ),
                      ),

                      /// Edit Button
                     IconButton(
  icon: const Icon(Icons.edit),
  color: Colors.blue,
  iconSize: 30,
  onPressed: () {

    Navigator.pushNamed(
  context,
  '/update',
  arguments: {
    'id': doc.id,
    'name': doc['name'],
    'phone': doc['phone'],
    'group': doc['group'],
  },
);

  },
),

                      /// Delete Button
                      IconButton(
                        icon: const Icon(Icons.delete),
                        color: Colors.red,

                        onPressed: () async {

                          await donor.doc(doc.id).delete();

                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text("Donor deleted"),
                            ),
                          );

                        },
                      ),

                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}