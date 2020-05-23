import 'package:agorartm/firebaseDB/auth.dart';
import 'package:agorartm/models/live.dart';
import 'package:agorartm/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../models/global.dart';
import '../models/post.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final databaseReference = Firestore.instance;
  List<Live> list =[];
  bool ready =false;
  Live liveUser;

  @override
  Widget build(BuildContext context) {
    return getMain();
  }


  @override
  void initState() {
    super.initState();
    liveUser = new Live(username: 'davish',me: true,image: 'https://www.hindustantimes.com/rf/image_size_1200x900/HT/p2/2019/09/25/Pictures/_115e3b3a-df82-11e9-b0cd-667d8786d605.jpg');
    list.add(liveUser);
    loadLiveUsers();
    dbChangeListen();
    /*var date = DateTime.now();
    var newDate = '${DateFormat("dd-MM-yyyy hh:mm:ss").format(date)}';
    print('akchy: $newDate');*/
  }
  void dbChangeListen(){
    databaseReference.collection('liveuser').orderBy("name",descending: true)
        .snapshots()
        .listen((result) {   // Listens to update in appointment collection

      setState(() {
        list = [];
        list.add(new Live(username: 'davish',me: true,image: 'https://www.hindustantimes.com/rf/image_size_1200x900/HT/p2/2019/09/25/Pictures/_115e3b3a-df82-11e9-b0cd-667d8786d605.jpg'));
      });

      result.documents.forEach((result) {
        setState(() {
          list.add(new Live(username: result.data['name'],image: result.data['image'],me: false));

        });
      });
    });

  }


  Future<void> loadLiveUsers() async {
    await databaseReference
        .collection('liveuser').orderBy("name",descending: true)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        list.add(new Live(username: f.data['name'],image: f.data['image'],me: false));
      });
    });
    setState(() {
      ready = true;
    });
  }


  Widget getMain() {
    return Scaffold(
      appBar: AppBar(

        leading: Transform.translate(
          offset: Offset(-5, 0),
          child:  Icon(FontAwesomeIcons.camera,color: Colors.white,)
        ),
        titleSpacing: -13,
        title: SizedBox(
            height: 35.0, child: Image.asset("assets/images/title.png")),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Icon(FontAwesomeIcons.paperPlane,color: Colors.white,),
          ),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () => logout(),
                child: Icon(
                    Icons.exit_to_app
                ),
              )
          ),
      ],

        backgroundColor: Colors.black87,
      ),
      body: Container(
        color: Colors.black,
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget> [
                Container(
                  height: 100,
                  child: getStories(),
                ),
                Divider(
                  height: 0,
                ),
                Column(
                  children: getPosts(context),
                ),
                SizedBox(height: 10,)
              ],
            )
          ],
        )
      ),
    );
  }

  Widget getStories() {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: getUserStories()
    );
  }

  List<Widget> getUserStories() {
    List<Widget> stories = [];
    for (Live users in list) {
      stories.add(getStory(users));
    }
    return stories;
  }

  Widget getStory(Live users) {
    return Container(
      margin: EdgeInsets.all(5),
      child: Column(
        children: <Widget>[
          Container(
              height: 70,
              width: 70,
              child: GestureDetector(
                onTap: (){
                  if(users.me==true){
                    //TODO: Add host function
                  }
                  else{
                    // TODO: Add join function
                  }
                },
                child: Stack(
                  alignment: Alignment(0, 0),
                  children: <Widget>[
                    !users.me ? Container(
                      height: 60,
                      width: 60,
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                                colors: [
                                  Colors.purple[700],
                                  Colors.pink,
                                  Colors.orange
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight
                            )
                        ),
                      ),
                    ) : SizedBox(height: 0,),
                    Container(
                      height: 55.5,
                      width: 55.5,
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                      ),
                    ),
                    Container(
                      height: 52,
                      width: 52,
                      child: CircleAvatar(
                          backgroundImage: NetworkImage(users.image)
                        //NetworkImage('https://firebasestorage.googleapis.com/v0/b/xperion-vxatbk.appspot.com/o/image_picker82875791.jpg?alt=media&token=09bf83c8-6d3b-4626-9058-85294f457b70'),
                      ),
                    ),
                    users.me ? Container(
                        height: 55,
                        width: 55,
                        alignment: Alignment.bottomRight,
                        child: Container(
                          decoration: new BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),

                          child: Icon(
                            Icons.add,
                            size: 13.5,
                            color: Colors.white,
                          ),
                        )
                    ) :
                    Container(
                        height: 70,
                        width: 70,
                        alignment: Alignment.bottomCenter,

                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Container(
                              height: 17,
                              width: 25,
                              decoration: new BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(
                                        4.0) //         <--- border radius here
                                ),
                                gradient: LinearGradient(
                                    colors: [Colors.black, Colors.black],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight
                                ),
                              ),


                            ),
                            Container(
                                decoration: new BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          2.0) //         <--- border radius here
                                  ),
                                  gradient: LinearGradient(
                                      colors: [Colors.pink, Colors.red],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight
                                  ),
                                ),

                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(
                                    'LIVE',
                                    style: TextStyle(
                                        fontSize: 7,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                )
                            ),
                          ],
                        )
                    )
                  ],
                ),
              )
          ),
          SizedBox(height: 3,),
          Text(users.username, style: textStyle)
        ],
      ),
    );
  }

  List<Widget> getPosts(BuildContext context) {
    List<Widget> posts = [];
    int index = 0;
    for (Post post in userPosts) {
      posts.add(getPost(context, post, index));
      index ++;
    }
    return posts;
  }

  Widget getPost(BuildContext context, Post post, int index) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      height: 30,
                      width: 30,
                      child: CircleAvatar(backgroundImage: post.user.profilePicture,),
                    ),
                    Text(post.user.username,style: TextStyle(color: Colors.white),)
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.more_vert,color: Colors.white,),
                  onPressed: () {

                  },
                )
              ],
            ),
          ),

          GestureDetector(
            onDoubleTap: () {
              setState(() {
                userPosts[index].isLiked = post.isLiked ? true : true;
                if (!post.isLiked) {
                  post.likes.add(user);
                }
              });
            },
            child: Container(
              constraints: BoxConstraints(
                maxHeight: 280
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  image: post.image
                )
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  post.isLiked?
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: GestureDetector(
                        onTap: (){
                          setState(() {
                            userPosts[index].isLiked = post.isLiked ? false : true;
                            if (!post.isLiked) {
                              post.likes.remove(user);
                            } else {
                              post.likes.add(user);
                            }
                          });
                        },
                        child: Icon(
                          Icons.favorite,
                          size: 30,
                          color: Colors.red ,
                        )
                    ),
                  ):
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          userPosts[index].isLiked = post.isLiked ? false : true;
                          if (!post.isLiked) {
                            post.likes.remove(user);
                          } else {
                            post.likes.add(user);
                          }
                        });
                      },
                        child: Icon(
                          Icons.favorite_border,
                          size: 30,

                          color: Colors.white,
                        )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 13),
                    child: GestureDetector(
                        onTap: (){
                          setState(() {
                            userPosts[index].isLiked = post.isLiked ? false : true;
                            if (!post.isLiked) {
                              post.likes.remove(user);
                            } else {
                              post.likes.add(user);
                            }
                          });
                        },
                        child: Icon(
                          FontAwesomeIcons.comment,
                          size: 25,

                          color: Colors.white,
                        )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 13),
                    child: GestureDetector(
                        onTap: (){
                          setState(() {
                            userPosts[index].isLiked = post.isLiked ? false : true;
                            if (!post.isLiked) {
                              post.likes.remove(user);
                            } else {
                              post.likes.add(user);
                            }
                          });
                        },
                        child: Icon(
                          FontAwesomeIcons.paperPlane,
                          size: 23,

                          color: Colors.white,
                        )
                    ),
                  ),
                ],
              ),

              Stack(
                    alignment: Alignment(0, 0),
                    children: <Widget>[
                      Icon(FontAwesomeIcons.bookmark, size: 28, color: Colors.white,),
                      IconButton(icon: Icon(Icons.bookmark), color: post.isSaved ? Colors.white : Colors.black,
                      onPressed: () {
                        setState(() {
                            userPosts[index].isSaved = post.isSaved ? false : true;

                          });
                      },)
                    ],
                  )
            ],
          ),

          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 15, right: 10),
                child: Text(
                  post.user.username,
                  style: textStyleBold,
                ),
              ),
              Text(
                post.description,
                style: textStyle,
              )
            ],
          ),
          SizedBox(height: 10,)

        ],
      )
    );
  }

  Widget getLikes(List<User> likes) {
    List<Widget> likers = [];
    for (User follower in likes) {
      likers.add(new Container(
        height: 45,
        padding: EdgeInsets.all(10),
        child: FlatButton(
          child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(follower.username, style: textStyleBold),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(3))
              ),
              child: FlatButton(
                color: user.following.contains(follower) ? Colors.white : Colors.blue,
                child: Text(user.following.contains(follower) ? "Following" : "Follow", style: TextStyle(fontWeight: FontWeight.bold, color: user.following.contains(follower) ? Colors.grey : Colors.white)),
                onPressed: () {
                  setState(() {
                    if (user.following.contains(follower)) {
                      user.following.remove(follower);
                    } else {
                      user.following.add(follower);
                    }
                  });
                },
              ),
            )
          ],
        ),
        onPressed: () {

        },
        )
      ));
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Likes", style: textStyleBold),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black,),
          onPressed: () {},
        ),
      ),
      body: Container(
        child: ListView(
          children: likers,
        ),
      ),
    );
  }
}