import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kelawin/utils/apputils.dart';

class Addaccount extends StatefulWidget {
  const Addaccount({super.key});

  @override
  State<Addaccount> createState() => _AddaccountState();
}

String states = "Madhya Pradesh";
String optionrole = "kissan";
String fname = "",
    lname = "",
    phone = "",
    city = "",
    address = "",
    email = "",
    pass = "",
    company = "",
    pincode = "";

final _formkey = GlobalKey<FormState>();

class _AddaccountState extends State<Addaccount> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late AnimationController _iconAnimationController;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    _animationController.forward();

    _iconAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _iconAnimationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _iconAnimationController.dispose();
    super.dispose();
  }

  bool passvisible = false;
  bool vyapridetils = false;

  @override
  Widget build(BuildContext context) {
    final Height = MediaQuery.of(context).size.height;
    final Width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xffd5ecfa),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: Width * 0.02),
              height: Height * 0.05,
              width: Width * 0.35,
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person,
                    size: Width * 0.025,
                  ),
                  SizedBox(
                    width: Width * 0.02,
                  ),
                  Text(
                    "Add Account",
                    style: TextStyle(
                        fontFamily: "sans",
                        fontWeight: FontWeight.bold,
                        fontSize: Width * 0.02),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: Height * 0.05),
              margin: EdgeInsets.only(top: Height * 0.01),
              height: Height * 0.78,
              width: Width * 0.4,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: Width * 0.15,
                          height: Height * 0.1,
                          child: TextFormField(
                            onChanged: (val) {
                              fname = val.toString().toLowerCase();
                            },
                            validator: ValidationBuilder()
                                .minLength(2)
                                .maxLength(25)
                                .build(),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            cursorColor: Colors.black87,
                            decoration: InputDecoration(
                                label: const Text("First Name"),
                                labelStyle: TextStyle(
                                    color: Colors.black87,
                                    fontFamily: "sans",
                                    fontWeight: FontWeight.bold,
                                    fontSize: Width * 0.01),
                                contentPadding: EdgeInsets.all(Width * 0.005),
                                hoverColor: Colors.grey.shade300,
                                hintText: "First Name",
                                hintStyle: TextStyle(
                                  fontFamily: "sans",
                                  fontSize: Width * 0.012,
                                ),
                                hintFadeDuration: const Duration(seconds: 1),
                                prefixIcon: Icon(
                                  Icons.person,
                                  size: Width * 0.015,
                                ),
                                fillColor:
                                    const Color.fromARGB(255, 229, 241, 248),
                                filled: true,
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.grey)),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.black87)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5))),
                          ),
                        ),
                        SizedBox(
                          width: Width * 0.15,
                          height: Height * 0.1,
                          child: TextFormField(
                            onChanged: (val) {
                              lname = val.toString().toLowerCase();
                            },
                            validator: ValidationBuilder()
                                .minLength(2)
                                .maxLength(25)
                                .build(),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            cursorColor: Colors.black87,
                            decoration: InputDecoration(
                                label: const Text("Last Name"),
                                labelStyle: TextStyle(
                                    fontFamily: "sans",
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Width * 0.01),
                                contentPadding: EdgeInsets.all(Width * 0.005),
                                hoverColor: Colors.grey.shade300,
                                hintText: "Last Name",
                                hintStyle: TextStyle(
                                  fontFamily: "sans",
                                  fontSize: Width * 0.012,
                                ),
                                hintFadeDuration: const Duration(seconds: 1),
                                prefixIcon: Icon(
                                  Icons.person,
                                  size: Width * 0.015,
                                ),
                                fillColor:
                                    const Color.fromARGB(255, 229, 241, 248),
                                filled: true,
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.grey)),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.black87)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5))),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: Width * 0.15,
                          height: Height * 0.1,
                          child: TextFormField(
                            onChanged: (val) {
                              city = val.toString().toLowerCase();
                            },
                            validator: ValidationBuilder()
                                .minLength(2)
                                .maxLength(25)
                                .build(),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            cursorColor: Colors.black87,
                            decoration: InputDecoration(
                                label: const Text("City"),
                                labelStyle: TextStyle(
                                    color: Colors.black87,
                                    fontFamily: "sans",
                                    fontWeight: FontWeight.bold,
                                    fontSize: Width * 0.01),
                                contentPadding: EdgeInsets.all(Width * 0.005),
                                hoverColor: Colors.grey.shade300,
                                hintText: "City",
                                hintStyle: TextStyle(
                                  fontFamily: "sans",
                                  fontSize: Width * 0.012,
                                ),
                                hintFadeDuration: const Duration(seconds: 1),
                                prefixIcon: Icon(
                                  Icons.location_city,
                                  size: Width * 0.015,
                                ),
                                fillColor:
                                    const Color.fromARGB(255, 229, 241, 248),
                                filled: true,
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.grey)),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.black87)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5))),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 229, 241, 248),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          width: Width * 0.15,
                          height: Height * 0.05,
                          child: DropdownButton(
                            padding: EdgeInsets.all(Width * 0.0025),
                            iconSize: Width * 0.01,
                            underline: const Text(""),
                            isExpanded: true,
                            dropdownColor: Colors.white,
                            style: TextStyle(
                                fontFamily: "sans",
                                fontSize: Width * 0.01,
                                color: Colors.black87),
                            value: states,
                            onChanged: (String? newValue) {
                              setState(() {
                                states = newValue!;
                              });
                            },
                            items: <String>[
                              'Madhya Pradesh',
                              'Maharashtra',
                              'Andhra Pradesh',
                              'Arunachal Pradesh',
                              'Assam',
                              'Bihar',
                              'Chhattisgarh',
                              'Goa',
                              'Gujarat',
                              'Haryana',
                              'Himachal Pradesh',
                              'Jharkhand',
                              'Karnataka',
                              'Kerala',
                              'Manipur',
                              'Meghalaya',
                              'Mizoram',
                              'Nagaland',
                              'Odisha',
                              'Punjab',
                              'Rajasthan',
                              'Sikkim',
                              'Tamil Nadu',
                              'Telangana',
                              'Tripura',
                              'Uttar Pradesh',
                              'Uttarakhand',
                              'West Bengal',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: Width * 0.025),
                          width: Width * 0.25,
                          height: Height * 0.1,
                          child: TextFormField(
                            onChanged: (val) {
                              address = val.toString().toLowerCase();
                            },
                            validator: ValidationBuilder()
                                .minLength(5)
                                .maxLength(45)
                                .build(),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            cursorColor: Colors.black87,
                            decoration: InputDecoration(
                                label: const Text("Address"),
                                labelStyle: TextStyle(
                                    color: Colors.black87,
                                    fontFamily: "sans",
                                    fontWeight: FontWeight.bold,
                                    fontSize: Width * 0.01),
                                contentPadding: EdgeInsets.all(Width * 0.005),
                                hoverColor: Colors.grey.shade300,
                                hintText: "Address",
                                hintStyle: TextStyle(
                                  fontFamily: "sans",
                                  fontSize: Width * 0.012,
                                ),
                                hintFadeDuration: const Duration(seconds: 1),
                                prefixIcon: Icon(
                                  Icons.location_on,
                                  size: Width * 0.015,
                                ),
                                fillColor:
                                    const Color.fromARGB(255, 229, 241, 248),
                                filled: true,
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.grey)),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.black87)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5))),
                          ),
                        ),
                        SizedBox(
                          width: Width * 0.02,
                        ),
                        SizedBox(
                          width: Width * 0.08,
                          height: Height * 0.1,
                          child: TextFormField(
                            onChanged: (val) {
                              pincode = val.toString().toLowerCase();
                            },
                            validator: ValidationBuilder()
                                .minLength(6)
                                .maxLength(6)
                                .build(),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            cursorColor: Colors.black87,
                            decoration: InputDecoration(
                                label: const Text("Pincode"),
                                labelStyle: TextStyle(
                                    color: Colors.black87,
                                    fontFamily: "sans",
                                    fontWeight: FontWeight.bold,
                                    fontSize: Width * 0.01),
                                contentPadding: EdgeInsets.all(Width * 0.005),
                                hoverColor: Colors.grey.shade300,
                                hintText: "Phone",
                                hintStyle: TextStyle(
                                  fontFamily: "sans",
                                  fontSize: Width * 0.012,
                                ),
                                hintFadeDuration: const Duration(seconds: 1),
                                prefixIcon: Icon(
                                  Icons.location_city,
                                  size: Width * 0.015,
                                ),
                                fillColor:
                                    const Color.fromARGB(255, 229, 241, 248),
                                filled: true,
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.grey)),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.black87)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5))),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: Width * 0.15,
                          height: Height * 0.1,
                          child: TextFormField(
                            onChanged: (val) {
                              phone = val.toString().toLowerCase();
                            },
                            validator: ValidationBuilder()
                                .minLength(10)
                                .maxLength(10)
                                .build(),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            cursorColor: Colors.black87,
                            decoration: InputDecoration(
                                label: const Text("Phone Number"),
                                labelStyle: TextStyle(
                                    color: Colors.black87,
                                    fontFamily: "sans",
                                    fontWeight: FontWeight.bold,
                                    fontSize: Width * 0.01),
                                contentPadding: EdgeInsets.all(Width * 0.005),
                                hoverColor: Colors.grey.shade300,
                                hintText: "Phone",
                                hintStyle: TextStyle(
                                  fontFamily: "sans",
                                  fontSize: Width * 0.012,
                                ),
                                hintFadeDuration: const Duration(seconds: 1),
                                prefixIcon: Icon(
                                  Icons.phone,
                                  size: Width * 0.015,
                                ),
                                fillColor:
                                    const Color.fromARGB(255, 229, 241, 248),
                                filled: true,
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.grey)),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.black87)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5))),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 229, 241, 248),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          width: Width * 0.15,
                          height: Height * 0.05,
                          child: DropdownButton(
                            padding: EdgeInsets.all(Width * 0.0025),
                            iconSize: Width * 0.01,
                            underline: const Text(""),
                            isExpanded: true,
                            dropdownColor: Colors.white,
                            style: TextStyle(
                                fontFamily: "sans",
                                fontSize: Width * 0.01,
                                color: Colors.black87),
                            value: optionrole,
                            onChanged: (String? newValue) {
                              setState(() {
                                optionrole = newValue!.toString().toLowerCase();
                                if (optionrole == "vyapari") {
                                  vyapridetils = true;
                                }
                                if (optionrole == "kelagroup") {
                                  vyapridetils = true;
                                }
                                if (optionrole == "kissan") {
                                  vyapridetils = false;
                                }
                              });
                            },
                            items: <String>[
                              'kissan',
                              'vyapari',
                              'kelagroup',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: vyapridetils,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: Width * 0.15,
                            height: Height * 0.1,
                            child: TextFormField(
                              onChanged: (val) {
                                email = val.toString().toLowerCase();
                              },
                              validator: ValidationBuilder().email().build(),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              cursorColor: Colors.black87,
                              decoration: InputDecoration(
                                  label: const Text("Email"),
                                  labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontFamily: "sans",
                                      fontWeight: FontWeight.bold,
                                      fontSize: Width * 0.01),
                                  contentPadding: EdgeInsets.all(Width * 0.005),
                                  hoverColor: Colors.grey.shade300,
                                  hintText: "Email",
                                  hintStyle: TextStyle(
                                    fontFamily: "sans",
                                    fontSize: Width * 0.012,
                                  ),
                                  hintFadeDuration: const Duration(seconds: 1),
                                  prefixIcon: Icon(
                                    Icons.email,
                                    size: Width * 0.015,
                                  ),
                                  fillColor:
                                      const Color.fromARGB(255, 229, 241, 248),
                                  filled: true,
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.grey)),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.black87)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5))),
                            ),
                          ),
                          SizedBox(
                            width: Width * 0.15,
                            height: Height * 0.1,
                            child: TextFormField(
                              onChanged: (val) {
                                pass = val.toString().toLowerCase();
                              },
                              obscureText: passvisible,
                              validator: ValidationBuilder()
                                  .minLength(8)
                                  .maxLength(20)
                                  .build(),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              cursorColor: Colors.black87,
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon(passvisible
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    onPressed: () {
                                      setState(() {
                                        passvisible = !passvisible;
                                      });
                                    },
                                  ),
                                  label: const Text("Password"),
                                  labelStyle: TextStyle(
                                      fontFamily: "sans",
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: Width * 0.01),
                                  contentPadding: EdgeInsets.all(Width * 0.005),
                                  hoverColor: Colors.grey.shade300,
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                    fontFamily: "sans",
                                    fontSize: Width * 0.012,
                                  ),
                                  hintFadeDuration: const Duration(seconds: 1),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    size: Width * 0.015,
                                  ),
                                  fillColor:
                                      const Color.fromARGB(255, 229, 241, 248),
                                  filled: true,
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.grey)),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.black87)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5))),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: vyapridetils,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: Width * 0.025),
                            width: Width * 0.35,
                            height: Height * 0.1,
                            child: TextFormField(
                              onChanged: (val) {
                                company = val.toString().toLowerCase();
                              },
                              validator: ValidationBuilder()
                                  .minLength(5)
                                  .maxLength(45)
                                  .build(),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              cursorColor: Colors.black87,
                              decoration: InputDecoration(
                                  label: const Text("Company Name"),
                                  labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontFamily: "sans",
                                      fontWeight: FontWeight.bold,
                                      fontSize: Width * 0.01),
                                  contentPadding: EdgeInsets.all(Width * 0.005),
                                  hoverColor: Colors.grey.shade300,
                                  hintText: "Company",
                                  hintStyle: TextStyle(
                                    fontFamily: "sans",
                                    fontSize: Width * 0.012,
                                  ),
                                  hintFadeDuration: const Duration(seconds: 1),
                                  prefixIcon: Icon(
                                    Icons.business,
                                    size: Width * 0.015,
                                  ),
                                  fillColor:
                                      const Color.fromARGB(255, 229, 241, 248),
                                  filled: true,
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.grey)),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.black87)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5))),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey.shade500,
                      endIndent: 10,
                      indent: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: Height * 0.05),
                          height: Height * 0.05,
                          width: Width * 0.1,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(221, 255, 0, 0),
                                padding: EdgeInsets.all(Width * 0.01),
                                shape: ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return ScaleTransition(
                                      scale: _animation,
                                      child: AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        title: AnimatedBuilder(
                                          animation: _iconAnimationController,
                                          builder: (context, child) {
                                            return Transform.translate(
                                                offset: Offset(
                                                    0.0,
                                                    3.0 *
                                                        _iconAnimationController
                                                            .value),
                                                child: const Icon(
                                                  Icons.info_rounded,
                                                  color:
                                                      Colors.blue, // Blue color
                                                  size: 40,
                                                ));
                                          },
                                        ),
                                        content: const Text(
                                          'Are you sure you want to submit this form?',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: "sans"),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: "sans"),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              bool already =
                                                  await _alreadyaccountcheck();
                                              if (already == false) {
                                                _addaccount(context);
                                              } else {
                                                Apputils().accountAlreadyExist(
                                                    context);
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue),
                                            child: const Text(
                                              'Submit',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: "sans"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            },
                            child: Text(
                              "Submit",
                              style: TextStyle(
                                  fontFamily: "sans",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: Width * 0.01),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future _addaccount(context) async {
  var isDevicesConnected = await InternetConnectionChecker().hasConnection;
  var validations = _formkey.currentState!.validate();
  if (validations == true) {
    Apputils().loader(context);

    if (isDevicesConnected == true) {
      try {
        Map<String, dynamic> Account = await addobject(
            fname, lname, phone, city, address, email, pass, company, pincode);

        await FirebaseFirestore.instance
            .collection(optionrole)
            .add(Account)
            .whenComplete(() => Apputils()
                .transactionSuccess(context, 2, "Account added successfully!"));

        Map<String, dynamic> khata =
            await _addkhata(Account["${optionrole}_id"], optionrole);
        await FirebaseFirestore.instance
            .collection("${optionrole}_khata")
            .add(khata);
      } catch (e) {
        Apputils().transactionUnsuccess(context, "Oops! something went wrong");
      }
    } else if (isDevicesConnected == false) {
      Apputils().noInternetConnection(context);
    }
  } else {
    Apputils().formisinComplete(context);
  }
}

Future<Map<String, dynamic>> addobject(
    fname, lname, phone, city, address, email, pass, company, pincode) async {
  var key = "${optionrole}_id";

  print(optionrole);
  var data = await FirebaseFirestore.instance
      .collection(optionrole)
      .orderBy(key, descending: true)
      .get();

  print(data.docs[0]);

  int newid = data.docs[0][key] + 1;
  String loginId = "sawamisamarth@$newid";
  String password = "swamisamarth@12";
  if (optionrole == "kissan") {
    return {
      "kissan_id": newid,
      "email": loginId,
      "password": password,
      "name": fname + " " + lname,
      "phone": phone,
      "city": city,
      "pincode": pincode,
      "state": states,
      "address": address,
      "role": optionrole,
    };
  } else if (optionrole == "vyapari" || optionrole == "kelagroup") {
    return {
      "${optionrole}_id": newid,
      "company": company,
      "email": email,
      "password": pass,
      "name": fname + lname,
      "phone": phone,
      "city": city,
      "pincode": pincode,
      "state": states,
      "address": address,
      "role": optionrole,
    };
  } else {
    return {};
  }
}

Future _alreadyaccountcheck() async {
  bool found = false;
  var data = await FirebaseFirestore.instance
      .collection(optionrole)
      .where("phone", isEqualTo: phone)
      .get();
  if (data.docs.isEmpty) {
    found = false;
  } else if (data.docs.isNotEmpty) {
    found = true;
  }
  return found;
}

Future<Map<String, dynamic>> _addkhata(newid, optionrole) async {
  var data = await FirebaseFirestore.instance
      .collection(optionrole + "_khata")
      .orderBy("khata_id", descending: true)
      .get();
  var id = data.docs[0]["khata_id"] + 1;

  return {
    "khata_id": id,
    optionrole + "_id": newid,
    "name": fname + lname,
    "Total": 0,
    "Due": 0,
    "Recieved": 0,
  };
}
