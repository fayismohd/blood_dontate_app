import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {

  String? selectedBloodGroup;

  final CollectionReference _donor = FirebaseFirestore.instance.collection('donor');

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  void addDonor() async {
    await _donor.add({
      'name': nameController.text,
      'phone': phoneController.text,
      'group': selectedBloodGroup,
    });
  }

  final List<String> bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Users', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),

      body: Padding(
        padding: const EdgeInsets.all(15.0),

        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Donor Name',
                ),
              ),
            ),

            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child:  TextField(
                controller: phoneController,
                keyboardType: TextInputType.number,
                maxLength: 10,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Number',
                ),
              ),
            ),

            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
              
                value: selectedBloodGroup,
              
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Select Blood Group',
                  prefixIcon: Icon(Icons.bloodtype, 
                  color: Colors.red),
                  hintText: 'Select Blood Group',
                ),
              
                items: bloodGroups.map((e) {
                  return DropdownMenuItem<String>(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
              
                onChanged: (val) {
                  setState(() {
                    selectedBloodGroup = val;
                  });
                },
              
              ),
            ),

            const SizedBox(height: 15),

           SizedBox(
            width: double.infinity,
            height: 50,
             child: ElevatedButton(
               onPressed: () {
                 addDonor();
                 Navigator.pop(context);
               },
             
               style: ElevatedButton.styleFrom(
                 backgroundColor: Colors.red,
                 shape: const RoundedRectangleBorder(
                     borderRadius: BorderRadius.zero, 
                   ),
               ),
             
               child: const Text(
                 'Submit',
                 style: TextStyle(
                   color: Colors.white,
                   fontSize: 18,
                 ),
               ),
             ),
           ),

          ],
        ),
      ),
    );
  }
}