import 'dart:ffi';

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _controller;
  late Animation _forwardAnimation;
  late Animation _reverseAnimation;
  late Animation _positionAnimation;
  late Animation _widgetAnimation;
  bool selected = false;
  int index = 10;
  late Widget _animatedWidget;
  late double height;
  late int selectedItem;
  List<String> image = [
    "assets/1.jpg",
    "assets/2.jpg",
    "assets/3.jpg",
    "assets/1.jpg"
  ];
  List<String> fName = ["Rohit", "Mahendra Singh", "Virat", "Jasprit"];
  List<String> lName = ["Sharma", "Dhoni", "Kohli", "Bumrah"];

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animatedWidget = widgetRow(0, fName[0], lName[0]);
    _controller.addListener(() {});
  }

  @override
  void didUpdateWidget(covariant Home oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    _forwardAnimation =
        SizeTween(begin: Size(0.0, height * 0.3), end: Size(0.0, height * 0.64))
            .animate(_controller);
    _reverseAnimation =
        SizeTween(begin: Size(0.0, height * 0.3), end: Size(0.0, 0.0))
            .animate(_controller);
    _positionAnimation =
        SizeTween(begin: Size(0.0, 160.0), end: Size(0.0, 70.0))
            .animate(_controller);
    // _widgetAnimation = Tween<Widget>(begin: widgetRow(), end: widgetColumn())
    //     .animate(_controller);

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return ListView.builder(
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        _showSheet(index);
                        setState(() {
                          _animatedWidget =
                              widgetColumn(index, fName[index], lName[index]);
                        });
                      },
                      child: container(image[index], index),
                    );
                  },
                );
              },
            ),
            Positioned(
              top: 10.0,
              left: 10.0,
              child: Icon(Icons.arrow_back, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget container(String image, int indexx) {
    return Stack(
      children: [
        Hero(
          tag: image,
          child: Container(
            child: Image(
              image: AssetImage(image),
              fit: BoxFit.cover,
              height: index == indexx
                  ? _forwardAnimation.value.height
                  : _reverseAnimation.value.height,
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ),
        Positioned(
            top: _positionAnimation.value.height,
            left: 30.0,
            child: AnimatedSwitcher(
              duration: Duration(
                milliseconds: 500,
              ),
              child: index == indexx
                  ? _animatedWidget
                  : widgetRow(index, fName[indexx], lName[indexx]),
            ))
      ],
    );
  }

  void _showSheet(int indexx) {
    setState(() {
      index = indexx;
    });
    _scaffoldKey.currentState!
        .showBottomSheet((context) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            height: 300.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    _controller.reverse();
                    Navigator.pop(context);
                    setState(() {
                      _animatedWidget =
                          widgetRow(index, fName[indexx], lName[indexx]);
                    });
                  },
                  icon: Icon(
                    Icons.horizontal_rule_outlined,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Photos",
                      style: TextStyle(
                          fontSize: 23.0, fontWeight: FontWeight.w800),
                    ),
                    Text("Likes"),
                    Text("Collections"),
                  ],
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      children: [
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return Container(
                                height: 180.0,
                                width: 180.0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Image(
                                    image: AssetImage("assets/2.jpg"),
                                    fit: BoxFit.fill,
                                  ),
                                ));
                          },
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Container(
                          height: 180.0,
                          width: 180.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image(
                              image: AssetImage("assets/1.jpg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
            transitionAnimationController: _controller,
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(40.0))))
        .closed
        .whenComplete(() {
          if (mounted) {
            setState(() {});
          }
        });
    _controller.forward();
  }

  Widget widgetColumn(int indexx, String FName, String LName) {
    return Column(
      key: Key("2"),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: index == indexx ? 45 : null,
          backgroundImage: AssetImage("assets/avatar.png"),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          FName,
          style: TextStyle(
              fontSize: index == indexx ? 30.0 : null,
              fontWeight: FontWeight.w400,
              color: Colors.white),
        ),
        SizedBox(
          height: 0.0,
        ),
        Text(
          LName,
          style: TextStyle(
              fontSize: index == indexx ? 30.0 : null,
              fontWeight: FontWeight.w400,
              color: Colors.white),
        ),
        SizedBox(
          height: 5.0,
        ),
        TweenAnimationBuilder(
          curve: Curves.easeIn,
          tween: Tween<double>(begin: 1.0, end: 0.0),
          duration: Duration(milliseconds: 900),
          builder: (context, double value, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: value * 30),
                  child: Text(
                    '@name',
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.7)),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: value * 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_pin,
                        size: 14.0,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      Text(
                        'Gujarat, India',
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.7)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: value * 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.facebook,
                        size: 14.0,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      Text(
                        'facebook.com',
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.7)),
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ],
    );
  }

  Widget widgetRow(int indexx, String FName, String LName) {
    return Row(
      key: Key("1"),
      children: [
        CircleAvatar(
          radius: index == indexx ? 20 : null,
          backgroundImage: AssetImage("assets/avatar.png"),
        ),
        SizedBox(
          width: 15.0,
        ),
        Text(
          FName,
          style: TextStyle(
              fontSize: index == indexx ? 15.0 : null,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
        SizedBox(
          width: 5.0,
        ),
        Text(
          LName,
          style: TextStyle(
              fontSize: index == indexx ? 15.0 : null,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        )
      ],
    );
  }
}
