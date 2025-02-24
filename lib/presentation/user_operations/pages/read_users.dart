import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_validator/form_validator.dart';
import 'package:intl/intl.dart';
import 'package:kelawin/Models/user_model.dart';
import 'package:kelawin/presentation/user_operations/pages/create_user.dart';
import 'package:kelawin/viewmodel/otp_viewmodel/otp_operation_viewmodel.dart';

import '../../../utils/apputils.dart';
import '../../../viewmodel/usersCrudOperations/users_crud_operations.dart';

class ReadUsers extends StatefulWidget {
  const ReadUsers({super.key});

  @override
  State<ReadUsers> createState() => _ReadUsersState();
}

class _ReadUsersState extends State<ReadUsers> {
  bool? _isLoading;
  late List<UserModel> allUsers;
  late List<UserModel> foundList;
  List<UserModel> tempFoundList = [];
  String _searchCatgory = "UserId";
  Map? selectedFilter;
  List<Map<String, dynamic>> filters = [
    {
      "filter": "Vyapari",
      "value": "vyapari",
    },
    {"filter": "Kissan", "value": "kissan"},
    {"filter": "KelaGroup", "value": "kelagroup"},
  ];
  @override
  void initState() {
    _getUsers();
    super.initState();
  }

  Future _getUsers() async {
    setState(() {
      _isLoading = true;
    });
    allUsers = await UsersCrudOperations().getAllUsersFromServer(context);

    if (mounted) {
      setState(() {
        foundList = allUsers;

        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: _isLoading!
          ? const Center(
              child: CircularProgressIndicator(
              backgroundColor: Colors.white,
              color: Colors.blue,
            ))
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Users Details",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold)),
                              const Spacer(),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 18),
                                      backgroundColor: const Color(0xff0073dd),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5))),
                                  onPressed: () async {
                                    await showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return const CreateUser(
                                            toUpdate: false,
                                          );
                                        });
                                    await _getUsers();
                                  },
                                  child: const Text(
                                    "Create User",
                                    style: TextStyle(color: Colors.white),
                                  )),
                              const SizedBox(
                                width: 20,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_month,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      DateFormat('dd-MM-yyyy')
                                          .format(DateTime.now())
                                          .toString(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontFamily: "sans",
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            children: filters.map((filter) {
                              bool isSelected = selectedFilter == null
                                  ? false
                                  : selectedFilter!["filter"] ==
                                      filter["filter"];
                              return Row(
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedFilter = filter;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? Colors.blue
                                              : Colors.white,
                                          border: Border.all(
                                            color: isSelected
                                                ? Colors.blueAccent
                                                : Colors.grey,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Text(
                                          filter["filter"].toString(),
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 16,
                                            fontFamily: "sans",
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      )),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                          Row(
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 20),
                                      backgroundColor: const Color(0xff0073dd),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5))),
                                  onPressed: () async {
                                    foundList = allUsers;
                                    tempFoundList = foundList;
                                    if (selectedFilter != null) {
                                      foundList = await _sortingAccordingRole(
                                          foundList, selectedFilter!["value"]);
                                    }
                                    setState(() {});
                                  },
                                  child: const Text(
                                    "Get Users",
                                    style: TextStyle(color: Colors.white),
                                  )),
                              const Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1),
                                    borderRadius: BorderRadius.circular(5)),
                                width: 80,
                                child: DropdownButton(
                                  padding: const EdgeInsets.only(left: 5),
                                  borderRadius: BorderRadius.circular(5),
                                  underline: const Text(""),
                                  isExpanded: true,
                                  dropdownColor: Colors.white,
                                  style: const TextStyle(
                                      fontFamily: "sans",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87),
                                  value: _searchCatgory,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _searchCatgory = newValue!;
                                    });
                                  },
                                  items: <String>[
                                    'UserId',
                                    'Name',
                                    'City',
                                    'State',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                  flex: 1,
                                  child: TextFormField(
                                    onChanged: (value) async {
                                      value = value.trim();
                                      if (selectedFilter == null) {
                                        //filtered list when getReprt button is clicked
                                        foundList = allUsers;

                                        foundList = await _searching(
                                            foundList, value, _searchCatgory);
                                      } else {
                                        //filtered list when getReprt button is clicked
                                        foundList = tempFoundList;

                                        foundList = await _searching(
                                            foundList, value, _searchCatgory);
                                      }

                                      setState(() {});
                                    },
                                    cursorColor: Colors.grey,
                                    decoration: InputDecoration(
                                        prefixIcon: const Icon(Icons.search),
                                        label: const Text(
                                          "Search Users",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                              color: Colors.blue.shade700,
                                              width: 1),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: const BorderSide(
                                              color: Colors.grey, width: 1),
                                        )),
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Container(
                      width: double.infinity,
                      color: Colors.white,
                      child: Table(
                        columnWidths: const {
                          0: FractionColumnWidth(0.05),
                          9: FractionColumnWidth(0.06),
                        },
                        border: TableBorder(
                          // Horizontal borders
                          verticalInside:
                              BorderSide(color: Colors.grey.shade300, width: 1),
                        ),
                        children: [
                          const TableRow(
                              decoration: BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                          color: Colors.grey, width: 1),
                                      bottom: BorderSide(
                                          color: Colors.grey, width: 1)),
                                  color: Color.fromARGB(38, 73, 112, 175)),
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text(
                                    'S No.',
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text(
                                    'UserId',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "sans",
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text(
                                    'Name',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "sans",
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text(
                                    'Address',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "sans",
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text(
                                    'City',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "sans",
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text(
                                    'State',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "sans",
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text(
                                    'Phone',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "sans",
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text(
                                    'Email',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "sans",
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text(
                                    'Company',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "sans",
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text(
                                    'Edit',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "sans",
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text(
                                    'Action',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "sans",
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ]),
                          for (int i = 0; i < foundList.length; i++)
                            TableRow(
                                decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey, width: 1)),
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: SelectableText(
                                      (i + 1).toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontFamily: "sans",
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: SelectableText(
                                      foundList[i].userId.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontFamily: "sans",
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: SelectableText(
                                      foundList[i].name.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontFamily: "sans",
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: SelectableText(
                                      foundList[i].address,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontFamily: "sans",
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: SelectableText(
                                      foundList[i].city,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontFamily: "sans",
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: SelectableText(
                                      foundList[i].state.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontFamily: "sans",
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: SelectableText(
                                      foundList[i].phone.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontFamily: "sans",
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: SelectableText(
                                      foundList[i].email.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontFamily: "sans",
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: SelectableText(
                                      foundList[i].role == "kissan"
                                          ? "NA"
                                          : foundList[i].company.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontFamily: "sans",
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 0, vertical: 0),
                                            backgroundColor:
                                                Colors.blue.shade900,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5))),
                                        onPressed: () async {
                                          await showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (context) {
                                                return CreateUser(
                                                  toUpdate: true,
                                                  user: foundList[i],
                                                );
                                              });
                                          await _getUsers();
                                        },
                                        child: const Text(
                                          "EDIT",
                                          style: TextStyle(color: Colors.white),
                                        )),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: IconButton(
                                          onPressed: () async {
                                            await OtpOperationViewmodel()
                                                .sendOtp(
                                                    context, "Ledger Deletion");
                                            Navigator.of(context).pop();
                                            showOtpDialog(
                                                context, foundList[i]);
                                          },
                                          icon: const Icon(Icons.delete))),
                                ])
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

Future<List<UserModel>> _sortingAccordingRole(
    List<UserModel> foundList, String role) async {
  foundList = foundList
      .where((element) => element.role.toString().toLowerCase().contains(role))
      .toList();
  return foundList;
}

Future<List<UserModel>> _searching(
    List<UserModel> foundList, String value, String searchCatgory) async {
  if (searchCatgory == "UserId") {
    foundList = foundList
        .where((element) =>
            element.userId.toString().toLowerCase().contains(value))
        .toList();
  }
  if (searchCatgory == "Name") {
    foundList = foundList
        .where(
            (element) => element.name.toString().toLowerCase().contains(value))
        .toList();
  }
  if (searchCatgory == "City") {
    foundList = foundList
        .where(
            (element) => element.city.toString().toLowerCase().contains(value))
        .toList();
  }
  if (searchCatgory == "State") {
    foundList = foundList
        .where(
            (element) => element.state.toString().toLowerCase().contains(value))
        .toList();
  }

  return foundList;
}

void showOtpDialog(BuildContext context, UserModel user) {
  TextEditingController otpController = TextEditingController();
  bool isLoading = false;
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent closing by clicking outside
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        // Track loading state
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Enter OTP'),
          content: Row(
            children: [
              Expanded(
                child: TextFormField(
                  readOnly: isLoading,
                  controller: otpController,
                  validator:
                      ValidationBuilder().minLength(6).maxLength(6).build(),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  inputFormatters: [
                    FilteringTextInputFormatter
                        .digitsOnly, // Allow digits and a single decimal point
                  ],
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide:
                            BorderSide(color: Colors.blue.shade700, width: 1),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1),
                      )),
                ),
              ),
              if (isLoading) // Show loader when verifying
                const Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close popup
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  isLoading = true; // Show loader
                });
                String userOtp = otpController.text;
                String otp = await OtpOperationViewmodel().verifyOtp();
                setState(() {
                  isLoading = false; // Show loader
                });
                // Validate OTP here
                if (otp == userOtp) {
                  Navigator.of(context).pop();
                  await Apputils().showConfirmBox(context,
                      'Are you sure you want to delete this user? deleting user will also delete khata and transactions of user!',
                      () async {
                    await UsersCrudOperations()
                        .deleteUserFromServer(context, user);
                  });
                } else {
                  // Show an error message
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invalid OTP')));
                }
              },
              child: Text(
                'Verify',
                style: TextStyle(color: Colors.blue.shade900),
              ),
            ),
          ],
        );
      });
    },
  );
}
