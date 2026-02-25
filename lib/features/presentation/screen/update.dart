import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateUser extends StatefulWidget {
  const UpdateUser({super.key});

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {

  final CollectionReference donor =
      FirebaseFirestore.instance.collection('donor');

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String? selectedBloodGroup;

  Map<String, dynamic>? args;

  final List<String> bloodGroups = [
    'A+','A-','B+','B-','AB+','AB-','O+','O-'
  ];

  bool isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!isLoaded) {

      final data =
          ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;

      if (data != null) {

        args = data;

        nameController.text = args!['name'].toString();
        phoneController.text = args!['phone'].toString();
        selectedBloodGroup = args!['group'].toString();

      }

      isLoaded = true;
    }
  }

  Future<void> updateDonor() async {

    if (args == null) return;

    await donor.doc(args!['id']).update({

      'name': nameController.text.trim(),
      'phone': phoneController.text.trim(),
      'group': selectedBloodGroup,

    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Donor updated successfully"),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    if (!isLoaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (args == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Error loading donor data",
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Update Donor",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(15),

        child: Column(
          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Donor Name",
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Phone",
              ),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: selectedBloodGroup,
              items: bloodGroups.map((e) =>
                  DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  )).toList(),
              onChanged: (val) {
                setState(() {
                  selectedBloodGroup = val;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Blood Group",
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(

                onPressed: updateDonor,

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),

                child: const Text(
                  "Update",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}