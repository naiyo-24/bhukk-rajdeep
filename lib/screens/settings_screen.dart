import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../route/routes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.orangeAccent,
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Preferences',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SwitchListTile(
            title: const Text('Enable Notifications'),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
            activeColor: Colors.orangeAccent,
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: _darkModeEnabled,
            onChanged: (value) {
              setState(() {
                _darkModeEnabled = value;
              });
            },
            activeColor: Colors.orangeAccent,
          ),
          const SizedBox(height: 20),
          const Text(
            'General',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ListTile(
            title: const Text('Language'),
            subtitle: Text(_selectedLanguage),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Select Language',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ListTile(
                        title: const Text('English'),
                        onTap: () {
                          setState(() {
                            _selectedLanguage = 'English';
                          });
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text('Hindi'),
                        onTap: () {
                          setState(() {
                            _selectedLanguage = 'Hindi';
                          });
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text('Bengali'),
                        onTap: () {
                          setState(() {
                            _selectedLanguage = 'Bengali';
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Get.toNamed(Routes.privacyPolicy),
          ),
          ListTile(
            title: const Text('Terms & Conditions'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Get.toNamed(Routes.terms),
          ),
          const SizedBox(height: 20),
          const Text(
            'Account',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ListTile(
            title: const Text('Change Password'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to Change Password screen
            },
          ),
          ListTile(
            title: const Text('Delete Account'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Get.offAllNamed(Routes.login);
            },
          ),
        ],
      ),
    );
  }
}
