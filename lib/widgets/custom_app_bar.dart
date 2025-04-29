import 'package:flutter/material.dart';
import 'package:flutter/src/services/system_chrome.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final bool showProfileAvatar;
  final bool useGradient;
  final bool showDrawerToggle;
  final Widget? leading;
  final Color backgroundColor;
  final double elevation;
  final VoidCallback? onPressed;

  const CustomAppBar({
    super.key,
    this.title,
    this.actions,
    this.showProfileAvatar = false,
    this.useGradient = false,
    this.showDrawerToggle = false,
    this.leading,
    required this.backgroundColor,
    this.elevation = 0,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: elevation,
      leading: showDrawerToggle
          ? IconButton(
              icon: const Icon(Icons.menu, color: Color.fromARGB(255, 246, 146, 38)),
              onPressed: () => Scaffold.of(context).openDrawer(),
            )
          : leading ?? (showProfileAvatar 
              ? GestureDetector(
                  onTap: onPressed,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://media.licdn.com/dms/image/v2/D4E03AQFj3MR0cRC3Ig/profile-displayphoto-shrink_400_400/B4EZWPTxFmHcAg-/0/1741866080997?e=1750291200&v=beta&t=QDv3Jo89qjxCZpape46zZ6ec4IzSgU2F8t8I12YtQCw'),
                    ),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: onPressed,
                )),
      title: title != null
          ? Text(
              title!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            )
          : showProfileAvatar
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome User!',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: const [
                        Icon(Icons.location_on, size: 16, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(
                          'Baghajatin, Kolkata',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                )
              : null,
      actions: actions,
      flexibleSpace: useGradient
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}