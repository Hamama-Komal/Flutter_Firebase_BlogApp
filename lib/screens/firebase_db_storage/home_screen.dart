import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:for_you/screens/firebase_db_storage/add_new_blog.dart';
import 'package:for_you/screens/start_screen.dart';
import 'package:for_you/ui_components/my_colors.dart';
import 'package:google_fonts/google_fonts.dart';

import 'blog_detail_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  FirebaseAuth auth = FirebaseAuth.instance;
  final postRef = FirebaseDatabase.instance.ref().child('Posts');
  TextEditingController searchController = TextEditingController();
  String search = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            _showPasswordDialog(context);
          },
          child: const Icon(
            Icons.add,
            size: 30,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Blogs",
          style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white),
        ),
        backgroundColor: myColors.dark,
        actions: [
          InkWell(
            onTap: () {
              _showLogoutDialog(context);
            },
            child: const Icon(
              Icons.logout,
              size: 30,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      backgroundColor: myColors.light2,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                maxLines: 1,
                keyboardType: TextInputType.text,
                controller: searchController,
                style: GoogleFonts.lato(),
                decoration: const InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                onChanged: (String value){
                  search = value;
                },
              ),
            ),
            Expanded(
              child:FirebaseAnimatedList(
                query: postRef.child('Post List'),
                itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                  if (snapshot.value != null) {
                    final data = snapshot.value as Map<dynamic, dynamic>;
                    String tempTitle = data['pTitle'] ?? '';
                    if (searchController.text.isEmpty || tempTitle.toLowerCase().contains(searchController.text.toLowerCase())) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlogDetailsScreen(
                                title: data['pTitle'] ?? '',
                                description: data['pDescription'] ?? '',
                                imageUrl: data['pImage'] ?? '',
                                author: data['uEmail'] ?? 'Unknown',
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: FadeInImage.assetNetwork(
                                        placeholder: "assets/images/img.png",
                                        image: data['pImage'] ?? '',
                                        height: MediaQuery.of(context).size.height * .25,
                                        width: MediaQuery.of(context).size.width * 0.75,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5,),
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text(data['pTitle'] ?? '', style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.black), maxLines: 1,),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text(data['pDescription'] ?? '', style: Theme.of(context).textTheme.displaySmall, maxLines: 4,),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }
                  return const SizedBox.shrink();
                },
              ),

              /* FirebaseAnimatedList(
                query: postRef.child('Post List'),
                itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                  if (snapshot.value != null) {
                    final data = snapshot.value as Map<dynamic, dynamic>;
                    String tempTitle = data['pTitle'] ?? '';
                    if (searchController.text.isEmpty) {
                      return _buildBlogItem(context, data);
                    } else if (tempTitle.contains(searchController.text.toString())) {
                      return _buildBlogItem(context, data);
                    } else {
                      return const SizedBox.shrink();
                    }
                  }
                  return const SizedBox.shrink();
                },
              ),*/
              /*FirebaseAnimatedList(
                query: postRef.child('Post List'),
                itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                  if (snapshot.value != null) {
                    final data = snapshot.value as Map<dynamic, dynamic>;
                    String tempTitle = data['pTitle'];
                    if (searchController.text.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: FadeInImage.assetNetwork(
                                      placeholder: "assets/images/im.png",
                                      image: data['pImage'] ?? '',
                                      height: MediaQuery.of(context).size.height * .25,
                                      width: MediaQuery.of(context).size.width * 0.75,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(data['pTitle'] ?? '', style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.black) ,maxLines: 1,),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(data['pDescription'] ?? '', style: Theme.of(context).textTheme.displaySmall , maxLines: 4,),
                                ),

                              ],
                            ),
                          ),
                        ),
                      );
                      // Your existing code for displaying posts when search is empty
                    } else if (tempTitle.toLowerCase().contains(searchController.text.toLowerCase())) {
                      // Your existing code for displaying posts when search matches title
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: FadeInImage.assetNetwork(
                                      placeholder: "assets/images/im.png",
                                      image: data['pImage'] ?? '',
                                      height: MediaQuery.of(context).size.height * .25,
                                      width: MediaQuery.of(context).size.width * 0.75,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(data['pTitle'] ?? '', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black), maxLines: 1,),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(data['pDescription'] ?? '', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: Colors.grey.shade700), maxLines: 4,),
                                ),

                              ],
                            ),
                          ),
                        ),
                      );

                    } else {
                      // Default return statement to handle other cases
                      return const SizedBox(); // or any other empty widget
                    }
                  }
                  // Add a return statement for cases where snapshot is null
                  return const SizedBox(); // or any other empty widget
                },
              ),*/

            ),

          ],
        ),
      ),
    );
  }

  Widget _buildBlogItem(BuildContext context, Map<dynamic, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: FadeInImage.assetNetwork(
                    placeholder: "assets/images/im.png",
                    image: data['pImage'] ?? '',
                    height: MediaQuery.of(context).size.height * .25,
                    width: MediaQuery.of(context).size.width * 0.75,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(data['pTitle'] ?? '', style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.black), maxLines: 1,),
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(data['pDescription'] ?? '', style: Theme.of(context).textTheme.displaySmall, maxLines: 4,),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop();
                auth.signOut().then((value) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const StartScreen()));
                });
              },
            ),
          ],
        );
      },
    );
  }


  void _showPasswordDialog(BuildContext context) {
    TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Password'),
          content: TextFormField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: 'Password',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                if (passwordController.text == 'admin123') {
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NewBlog()));
                } else {
                  Navigator.of(context).pop();
                  toastMessages("Access Denied");
                 /* ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Access Denied')),);*/
                }
              },
            ),
          ],
        );
      },
    );
  }

  void toastMessages(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey.shade200,
        textColor: Colors.black,
        fontSize: 16.0);
  }
}

