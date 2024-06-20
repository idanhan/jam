// import 'package:flutter/material.dart';
// import 'package:budget_app/profilepage/profileScreen.dart';

// class calDrawer extends StatelessWidget {
//   final width;
//   const calDrawer({super.key, required this.width});

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       width: width * 0.5,
//       child: ListView(
//         children: <Widget>[
//           const DrawerHeader(
//             child: Text("this", textAlign: TextAlign.center),
//           ),
//           ListTile(
//             leading: const CircleAvatar(
//               radius: 30,
//             ),
//             title: TextButton(
//                 onPressed: () {
//                   Navigator.of(context).push(MaterialPageRoute(
//                     builder: (context) => ProfileScreen(
//                       username: '',
//                       email: '',
//                       userData: ,
//                     ),
//                   ));
//                 },
//                 child: const Text(
//                   "MyProfile",
//                   style: TextStyle(fontSize: 15),
//                 )),
//           ),
//         ],
//       ),
//     );
//   }
// }
