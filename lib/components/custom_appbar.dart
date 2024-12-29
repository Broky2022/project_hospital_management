import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_hospital_management/utils/config.dart';

class CustomAppbar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppbar({Key? key, this.appTitle, this.route, this.icon, this.actions}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60);

  final String? appTitle;
  final String? route;
  final FaIcon? icon;
  final List<Widget>? actions;

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        widget.appTitle!,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.black
        ),
      ),
      leading: widget.icon != null
          ? Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Config.primaryColor,
        ),
        child: IconButton(onPressed: ()
        // Kiểm tra điều kiện route
        {
          if(widget.route != null) {
            // Nếu route được cung cấp, nút icon này sẽ điều hướng đến route đó
            Navigator.of(context).pushNamed(widget.route!);
          } else {
            // Ngược lại
            Navigator.of(context).pop();
          }
        },
          icon: widget.icon!,
          iconSize: 16,
          color: Colors.white,
        ),
      )
          : null,
// Nếu action không được set, trả về null
      actions: widget.actions ?? null,
    );
  }
}