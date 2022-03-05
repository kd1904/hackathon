import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class side_menu extends StatefulWidget {
  const side_menu({Key? key}) : super(key: key);

  @override
  State<side_menu> createState() => _side_menuState();
}

class _side_menuState extends State<side_menu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        "https://static.seekingalpha.com/cdn/s3/uploads/getty_images/1307157342/image_1307157342.jpg?io=getty-c-w750")),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 14,
                  ),
                  Text(
                    "Menu",
                    style: TextStyle(fontSize: 32),
                  ),
                  // Container(
                  //   height: 80,

                  //   child: CircleAvatar(
                  //     backgroundImage: NetworkImage(
                  //         "https://quickbooks.intuit.com/oidam/intuit/sbseg/en_us/Blog/Illustration/5bd3805355baa2fe0a68f98ad0d4e0d8.png",
                  //         scale: 145),
                  //     radius: 50,
                  //   ),
                  // child: Image(
                  //     image: NetworkImage(
                  //         "https://quickbooks.intuit.com/oidam/intuit/sbseg/en_us/Blog/Illustration/5bd3805355baa2fe0a68f98ad0d4e0d8.png")),
                  // ),
                ],
              ),
            ),
            // child: Center(
            //   child: Text(
            //     'Records   \nand    \nSavings',
            //     textAlign: TextAlign.center,
            //     style: TextStyle(color: Colors.white, fontSize: 25),
            //   ),
            // ),
            // decoration: BoxDecoration(
            //   color: Colors.black,
            // ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(AntDesign.bank),
            title: Text('Expense Monitor'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.savings),
            title: Text('Savings'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(AntDesign.customerservice),
            title: Text('Need help'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.backup_outlined),
            title: Text('Backup to drive'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {Navigator.of(context).pop()},
          )
        ],
      ),
    );
  }
}
