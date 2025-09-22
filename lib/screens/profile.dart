import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool loading = false;

  Future<void> logout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    setState(() => loading = true);

    try {
      await authProvider.logout();
    } catch (e) {
      if (!mounted) return;

      setState(() => loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  // Widget of profile details :- Avatar, Name, Email
  Widget _profileDetails(
    BuildContext context, {
    required String? avatarUrl,
    required String? fullName,
    required String? email,
  }) {
    return Column(
      children: [
        Hero(
          tag: 'profile-avatar',
          child: CircleAvatar(
            radius: 55,
            backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
            backgroundColor: Colors.black,
            child: avatarUrl == null
                ? const Icon(Icons.person, size: 60, color: Colors.white70)
                : null,
          ),
        ),
        const SizedBox(height: 16),

        // --- Name ---
        Text(
          fullName ?? "WHO THE FUCK YOU ARE?",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),

        // --- Email ---
        Text(
          email ?? 'No email',
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  // Widget of a settings tile :- Can be used anywhere just depends on your usecase
  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLoading = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: isLoading
            ? SizedBox(
                width: 16,
                height: 16,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                  trackGap:
                      sqrt1_2, // if using CircularProgressIndicator.adaptive in some packages
                ),
              )
            : const Icon(Icons.chevron_right, color: Colors.white54),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final user = authProvider.user;
    final fullName = user?.userMetadata?['full_name'] ?? 'Guest';
    final avatarUrl = user?.userMetadata?['avatar_url'] as String?;

    final settings = [
      {
        'icon': Icons.person,
        'title': 'Edit Profile',
        'onTap': () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Edit profile coming soon')),
          );
        },
      },
      {
        'icon': Icons.lock,
        'title': 'Change Password',
        'onTap': () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Change password coming soon')),
          );
        },
      },
      {
        'icon': Icons.notifications,
        'title': 'Notifications',
        'onTap': () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Notification settings coming soon')),
          );
        },
      },
      {
        'icon': Icons.info_outline,
        'title': 'About',
        'onTap': () {
          showAboutDialog(
            context: context,
            applicationName: 'SwipeMovie',
            applicationVersion: '1.0.0',
            applicationLegalese: '© 2025 SwipeMovie',
            applicationIcon: Icon(Icons.movie, size: 48, color: Colors.red),
            barrierColor: Colors.black26,
          );
        },
      },
      {
        'icon': Icons.logout,
        'title': 'Logout',
        'onTap': logout,
        'isLoading': loading,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 0),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _profileDetails(
                            context,
                            avatarUrl: avatarUrl,
                            fullName: fullName,
                            email: user?.email,
                          ),

                          Column(
                            children: settings.map((setting) {
                              return _buildSettingsTile(
                                context,
                                icon: setting['icon'] as IconData,
                                title: setting['title'] as String,
                                onTap: setting['onTap'] as VoidCallback,
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
