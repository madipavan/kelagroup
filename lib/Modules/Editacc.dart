import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kelawin/Modules/Mainscreen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Editacc extends StatefulWidget {
  final int userid;
  final String? role;
  const Editacc({super.key, required this.userid, this.role});

  @override
  State<Editacc> createState() => _EditaccState();
}

int userroleid = 0;
int id = 0;
String userrole = "";
TextEditingController namecontroller = TextEditingController();
TextEditingController citycontroller = TextEditingController();
TextEditingController addresscontroller = TextEditingController();
TextEditingController pincodecontroller = TextEditingController();
TextEditingController phonecontroller = TextEditingController();
TextEditingController emailcontroller = TextEditingController();
TextEditingController passcontroller = TextEditingController();
TextEditingController companycontroller = TextEditingController();
bool passvisible = false;
bool companyname = false;
bool vyapridetils = true;
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

class _EditaccState extends State<Editacc> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late AnimationController _iconAnimationController;
  @override
  void initState() {
    userrole = widget.role.toString();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        id = widget.userid;
        _getdata(id, context);
        userroleid = widget.userid;
      });
    });

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
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _iconAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Height = MediaQuery.of(context).size.height;
    final Width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffd5ecfa),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shadowColor: Colors.black,
              elevation: 10,
              child: Container(
                height: Height * 0.1,
                width: Width,
                color: Colors.white,
                child: ListTile(
                  leading: IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Mainscreen()));
                      },
                      icon: const Icon(
                        Icons.arrow_circle_left,
                        color: Colors.black87,
                        size: 45,
                      )),
                  title: Text(
                    "User Account Swami Samarth Kelagroup",
                    style: TextStyle(
                        fontFamily: "sans",
                        fontSize: Width * 0.02,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Edit Your Account details below.",
                    style: TextStyle(
                        fontFamily: "sans",
                        fontSize: Width * 0.01,
                        fontWeight: FontWeight.bold),
                  ),
                ),
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
                          width: Width * 0.35,
                          height: Height * 0.1,
                          child: TextFormField(
                            controller: namecontroller,
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
                                label: const Text("Full Name"),
                                labelStyle: TextStyle(
                                    color: Colors.black87,
                                    fontFamily: "sans",
                                    fontWeight: FontWeight.bold,
                                    fontSize: Width * 0.01),
                                contentPadding: EdgeInsets.all(Width * 0.005),
                                hoverColor: Colors.grey.shade300,
                                hintText: "Full Name",
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
                            controller: citycontroller,
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
                            controller: addresscontroller,
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
                            controller: pincodecontroller,
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
                                hintText: "Pincode",
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
                            enabled: false,
                            controller: phonecontroller,
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
                                  companyname = true;
                                }
                                if (optionrole == "kissan") {
                                  companyname = false;
                                }
                              });
                            },
                            items: <String>[
                              'kissan',
                              'vyapari',
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
                              controller: emailcontroller,
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
                              controller: passcontroller,
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
                                    Icons.password,
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
                      visible: companyname,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: Width * 0.025),
                            width: Width * 0.35,
                            height: Height * 0.1,
                            child: TextFormField(
                              controller: companycontroller,
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                              await _addaccount(context);
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
                              "Update",
                              style: TextStyle(
                                  fontFamily: "sans",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: Width * 0.01),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: Height * 0.05),
                          height: Height * 0.05,
                          width: Width * 0.1,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black87,
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
                                          'Are you sure you want to delete this account?',
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
                                              await _deleteacc(context);
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
                              "Delete",
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

_addaccount(context) async {
  var isDevicesConnected = await InternetConnectionChecker().hasConnection;
  var validations = _formkey.currentState!.validate();
  if (validations == true) {
    _loader(context);
    if (isDevicesConnected == true) {
      Map<String, dynamic> Account = await addobject(
          fname, phone, city, address, email, pass, company, pincode);
      var roleid = "${userrole}_id";
      var updateaccdata = await FirebaseFirestore.instance
          .collection(userrole)
          .where(roleid, isEqualTo: userroleid)
          .get();
      var updateaccid = updateaccdata.docs[0].id;
      await FirebaseFirestore.instance
          .collection(userrole)
          .doc(updateaccid)
          .update(Account)
          .whenComplete(() => _success(context))
          .onError((error, stackTrace) => _unsuccess(context));
    } else if (isDevicesConnected == false) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.wifi_off,
                    color: Colors.white,
                    size: 50,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'No Internet Connection',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Please check your internet connection and try again.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    style: ElevatedButton.styleFrom(
                        // primary: Colors.white,
                        // onPrimary: Colors.redAccent,
                        ),
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
    }
  } else {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            backgroundColor: Colors.white,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Incomplete Submission',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Please fill in all the required fields.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

Future<Map<String, dynamic>> addobject(
    fname, phone, city, address, email, pass, company, pincode) async {
  if (optionrole == "kissan") {
    return {
      "kissan_id": id,
      "email": email,
      "password": pass,
      "name": fname,
      "phone": phone,
      "city": city,
      "pincode": pincode,
      "state": states,
      "address": address,
      "role": optionrole,
    };
  } else if (optionrole == "vyapari") {
    return {
      "vyapari_id": id,
      "company": company,
      "email": email,
      "password": pass,
      "name": fname,
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

_success(context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 50,
              ),
              const SizedBox(height: 20),
              const Text(
                'Transaction Complete',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Your asccount has been successfully added.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      });
}

_unsuccess(context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.white,
                size: 50,
              ),
              const SizedBox(height: 20),
              const Text(
                'Transaction Failed',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Oops! Something went wrong during the transaction. Please try again later.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                style: ElevatedButton.styleFrom(
                    // primary: Colors.white,
                    // onPrimary: Colors.redAccent,
                    ),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ],
          ),
        );
      });
}

_loader(context) {
  showDialog(
      context: context,
      builder: (context) {
        return Center(
            child: LoadingAnimationWidget.discreteCircle(
                color: Colors.red,
                size: 50,
                secondRingColor: Colors.white,
                thirdRingColor: Colors.blueAccent));
      });
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

Future _getdata(id, context) async {
  var key = "${userrole}_id";
  var data = await FirebaseFirestore.instance
      .collection(userrole)
      .where(key, isEqualTo: id)
      .get();

  namecontroller.text = data.docs[0]["name"];
  fname = data.docs[0]["name"];
  citycontroller.text = data.docs[0]["city"];
  city = data.docs[0]["city"];
  addresscontroller.text = data.docs[0]["address"];
  address = data.docs[0]["address"];
  pincodecontroller.text = data.docs[0]["pincode"];
  pincode = data.docs[0]["pincode"];
  phonecontroller.text = data.docs[0]["phone"];
  phone = data.docs[0]["phone"];
  emailcontroller.text = data.docs[0]["email"];
  email = data.docs[0]["email"];
  passcontroller.text = data.docs[0]["password"];
  pass = data.docs[0]["password"];
  states = data.docs[0]["state"];
  optionrole = data.docs[0]["role"];

  if (userrole == "vyapari") {
    print("present");
    companycontroller.text = data.docs[0]["company"];
    company = data.docs[0]["company"];
    companyname = true;
  }
}

Future _deleteacc(context) async {
  var isDevicesConnected = await InternetConnectionChecker().hasConnection;
  if (isDevicesConnected == true) {
    _loader(context);
    var roleid = "${userrole}_id";
    var updateaccdata = await FirebaseFirestore.instance
        .collection(userrole)
        .where(roleid, isEqualTo: userroleid)
        .get();
    var updateaccid = updateaccdata.docs[0].id;
    await FirebaseFirestore.instance
        .collection(userrole)
        .doc(updateaccid)
        .delete()
        .whenComplete(() => _delsuccess(context))
        .onError((error, stackTrace) => _unsuccess(context));
  } else {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.wifi_off,
                  color: Colors.white,
                  size: 50,
                ),
                const SizedBox(height: 20),
                const Text(
                  'No Internet Connection',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Please check your internet connection and try again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  style: ElevatedButton.styleFrom(
                      // primary: Colors.white,
                      // onPrimary: Colors.redAccent,
                      ),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

_delsuccess(context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 50,
              ),
              const SizedBox(height: 20),
              const Text(
                'Transaction Complete',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Your Bill has been successfully Deleted.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Mainscreen()));
                  // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      });
}
