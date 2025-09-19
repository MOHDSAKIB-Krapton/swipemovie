import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipemovie/screens/auth/login.dart';
import 'package:swipemovie/widgets/common/primary_button.dart';
import '../../provider/auth_provider.dart'; // your own provider

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

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final user = authProvider.user;
    final fullName = user?.userMetadata?['full_name'] ?? 'Guest';
    final avatarUrl = user?.userMetadata?['avatar_url'] as String?;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: AppBar(
              backgroundColor: Colors.black,
              elevation: 0,
              centerTitle: true,
              foregroundColor: Colors.white,
              title: const Text(
                'Profile',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // ===== background gradient like home =====
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0f2027),
                  Color(0xFF203a43),
                  Color(0xFF2c5364),
                ],
              ),
            ),
          ),

          // ===== main content =====
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'profile-avatar',
                    child: CircleAvatar(
                      radius: 55,
                      backgroundImage: avatarUrl != null
                          ? NetworkImage(avatarUrl)
                          : null,
                      backgroundColor: Colors.black,
                      child: avatarUrl == null
                          ? const Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.white70,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- Name ---
                  Text(
                    fullName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // --- Email ---
                  Text(
                    user?.email ?? 'No email',
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 32),

                  // ===== Settings / Actions =====
                  _buildSettingsTile(
                    context,
                    icon: Icons.person,
                    title: 'Edit Profile',
                    onTap: () {
                      // TODO: navigate to profile-edit screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Edit profile coming soon'),
                        ),
                      );
                    },
                  ),
                  _buildSettingsTile(
                    context,
                    icon: Icons.lock,
                    title: 'Change Password',
                    onTap: () {
                      // TODO: implement password change
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Change password coming soon'),
                        ),
                      );
                    },
                  ),
                  _buildSettingsTile(
                    context,
                    icon: Icons.notifications,
                    title: 'Notifications',
                    onTap: () {
                      // TODO: notification settings
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Notification settings coming soon'),
                        ),
                      );
                    },
                  ),
                  _buildSettingsTile(
                    context,
                    icon: Icons.info_outline,
                    title: 'About',
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'SwipeMovie',
                        applicationVersion: '1.0.0',
                        applicationLegalese: '© 2025 SwipeMovie',
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  PrimaryButton(
                    onTap: logout,
                    label: 'Logout',
                    isLoading: loading,
                    icon: Icons.logout,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // a reusable tile with glass effect
  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
      ),
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
        trailing: const Icon(Icons.chevron_right, color: Colors.white54),
        onTap: onTap,
      ),
    );
  }
}
