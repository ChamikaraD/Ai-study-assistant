import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // 1. Add this import!

class ManageAccountScreen extends StatelessWidget {
  const ManageAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          // 2. Update the back button
          onPressed: () => context.pop(),
        ),
        title: const Text('Manage Account', style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const CircleAvatar(radius: 50, backgroundImage: NetworkImage('https://via.placeholder.com/150')),
            TextButton(onPressed: () {}, child: const Text('Change Profile Picture')),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: 'Sarah',
              decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            TextFormField(
              initialValue: 'sarah@student.nsbm.ac.lk', // Using NSBM email format!
              decoration: const InputDecoration(labelText: 'Email Address', border: OutlineInputBorder()),
              readOnly: true, // Email usually shouldn't be changed easily
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                // 3. Update the save button to also pop back to settings
                onPressed: () => context.pop(),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                child: const Text('Save Changes', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}