import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:kelawin/Models/khata_model.dart';
import 'package:kelawin/Models/ledgergroup_model.dart';
import 'package:kelawin/Models/user_model.dart';
import 'package:kelawin/presentation/user_operations/widgets/add_branch.dart';
import 'package:kelawin/presentation/user_operations/widgets/add_ledgergroup.dart';
import 'package:kelawin/presentation/user_operations/widgets/user_textfield.dart';
import 'package:kelawin/viewmodel/usersCrudOperations/branch_crud_operations.dart';

import '../../../viewmodel/usersCrudOperations/ledger_group_operations.dart';
import '../../../viewmodel/usersCrudOperations/users_crud_operations.dart';

class CreateUser extends StatefulWidget {
  final bool toUpdate;
  final UserModel? user;
  const CreateUser({super.key, required this.toUpdate, this.user});

  @override
  State<CreateUser> createState() => _CreateUserState();
}

List<String> states = [
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
];

class _CreateUserState extends State<CreateUser> {
  //dropdown
  String _userRole = "kissan";
  String _userState = "Madhya Pradesh";
  LedgergroupModel _ledgerGroup = LedgergroupModel(
      ledgerGroupId: 901,
      groupName: "Discount",
      groupType: "Assests",
      balanceSheetHead: "Assets");
  String _branch = "Shahpur";

  int _hammaliPercent = 5;
  int _commissionPercent = 5;
  //form
  final _formkey = GlobalKey<FormState>();
  //controllers
  TextEditingController userName = TextEditingController();
  TextEditingController userAddress = TextEditingController();
  TextEditingController userPincode = TextEditingController();
  TextEditingController userCity = TextEditingController();
  TextEditingController userPhone = TextEditingController();
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPass = TextEditingController();
  TextEditingController userCompany = TextEditingController();
  TextEditingController userAadhar = TextEditingController();
  TextEditingController userPan = TextEditingController();
  TextEditingController userBalance = TextEditingController();
  TextEditingController userReceived = TextEditingController();
  TextEditingController userDue = TextEditingController();
  TextEditingController note = TextEditingController();

  List<LedgergroupModel> _ledgerGroupList = [];
  List<String> _branchList = [];
  bool _isLoading = true;

  //controllers
  @override
  void initState() {
    if (widget.toUpdate) {
      _getUserUpdationData();
    } else {
      _getData();
    }
    super.initState();
  }

  Future _getUserUpdationData() async {
    _branchList = await BranchCrudOperations().getBranchFromServer();
    _ledgerGroupList =
        await LedgerGroupOperations().getAllLedgerGroupFromServer();

    if (mounted) {
      setState(() {
        userName.text = widget.user!.name;
        userAddress.text = widget.user!.address;
        userPincode.text = widget.user!.pincode;
        userCity.text = widget.user!.city;
        _userState = widget.user!.state;
        _userRole = widget.user!.role;
        userPhone.text = widget.user!.phone;
        userEmail.text = widget.user!.email;
        userPass.text = widget.user!.password;
        userCompany.text = widget.user!.company;
        userAadhar.text = widget.user!.aadhar;
        userPan.text = widget.user!.panCard;
        note.text = widget.user!.note;
        _branch = widget.user!.branch;
        _ledgerGroup = _ledgerGroupList.firstWhere(
          (element) => element.ledgerGroupId == widget.user!.ledgerGroupId,
          orElse: () => _ledgerGroup, // Avoids errors if no match is found
        );
        _ledgerGroupList = _ledgerGroupList;
        _isLoading = false;
      });
    }
  }

  Future _getData() async {
    _branchList = await BranchCrudOperations().getBranchFromServer();
    _ledgerGroupList =
        await LedgerGroupOperations().getAllLedgerGroupFromServer();

    _isLoading = false;
    if (mounted) {
      setState(() {
        _branchList = _branchList;
        _ledgerGroupList = _ledgerGroupList;
        _ledgerGroup = _ledgerGroupList[0];
        _branch = _branchList[0];
        _isLoading = _isLoading;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    userName.dispose();
    userAddress.dispose();
    userPincode.dispose();
    userCity.dispose();
    userPhone.dispose();
    userEmail.dispose();
    userPass.dispose();
    userCompany.dispose();
    userAadhar.dispose();
    userPan.dispose();
    userBalance.dispose();
    userReceived.dispose();
    userDue.dispose();
    note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(
            backgroundColor: Colors.white,
            color: Colors.blue,
          ))
        : AlertDialog(
            backgroundColor: Colors.transparent,
            content: Row(
              children: [
                Expanded(
                    flex: 2,
                    child: Container(
                      height: 800,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5))),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                GestureDetector(
                                    onTap: () => Navigator.of(context).pop(),
                                    child: const Icon(
                                      Icons.arrow_back,
                                      size: 40,
                                    )),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: 600,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 150, vertical: 30),
                                child: SingleChildScrollView(
                                  child: Form(
                                    key: _formkey,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        const Text(
                                          "User Registration!",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 40),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: UserTextfield(
                                                label: "User name",
                                                controller: userName,
                                                validationBuilder:
                                                    ValidationBuilder(
                                                            requiredMessage: "")
                                                        .minLength(2)
                                                        .maxLength(45)
                                                        .build(),
                                                prefix: const Icon(
                                                    Icons.person_2_outlined),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.grey,
                                                        width: 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                width: 100,
                                                child: DropdownButton(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  underline: const Text(""),
                                                  isExpanded: true,
                                                  dropdownColor: Colors.white,
                                                  style: const TextStyle(
                                                      fontFamily: "sans",
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black87),
                                                  value: _userRole,
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      _userRole = newValue!;
                                                    });
                                                  },
                                                  items: <String>[
                                                    'kissan',
                                                    'vyapari',
                                                    'kelagroup',
                                                  ].map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: UserTextfield(
                                                label: "Address",
                                                controller: userAddress,
                                                validationBuilder:
                                                    ValidationBuilder(
                                                  requiredMessage: "",
                                                )
                                                        .minLength(2)
                                                        .maxLength(45)
                                                        .build(),
                                                prefix: const Icon(Icons
                                                    .not_listed_location_outlined),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: UserTextfield(
                                                label: "Pincode",
                                                validationBuilder:
                                                    ValidationBuilder(
                                                            requiredMessage: "")
                                                        .minLength(6)
                                                        .maxLength(6)
                                                        .build(),
                                                controller: userPincode,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: UserTextfield(
                                                label: "City",
                                                controller: userCity,
                                                validationBuilder:
                                                    ValidationBuilder(
                                                            requiredMessage: "")
                                                        .minLength(2)
                                                        .maxLength(45)
                                                        .build(),
                                                prefix: const Icon(
                                                    Icons.location_on),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.grey,
                                                        width: 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                width: 100,
                                                child: DropdownButton(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  underline: const Text(""),
                                                  isExpanded: true,
                                                  dropdownColor: Colors.white,
                                                  style: const TextStyle(
                                                      fontFamily: "sans",
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black87),
                                                  value: _userState,
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      _userState = newValue!;
                                                    });
                                                  },
                                                  items: states.map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: UserTextfield(
                                                validationBuilder:
                                                    ValidationBuilder(
                                                            requiredMessage: "")
                                                        .minLength(10)
                                                        .maxLength(10)
                                                        .build(),
                                                label: "Phone",
                                                controller: userPhone,
                                                prefix: const Icon(Icons
                                                    .phone_in_talk_outlined),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Visibility(
                                          visible: _userRole != "kissan",
                                          child: const SizedBox(
                                            height: 15,
                                          ),
                                        ),
                                        Visibility(
                                          visible: _userRole != "kissan",
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: UserTextfield(
                                                  validationBuilder:
                                                      ValidationBuilder(
                                                              requiredMessage:
                                                                  "")
                                                          .email()
                                                          .build(),
                                                  label: "Email",
                                                  controller: userEmail,
                                                  prefix: const Icon(
                                                      Icons.email_outlined),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: _userRole != "kissan",
                                          child: const SizedBox(
                                            height: 15,
                                          ),
                                        ),
                                        Visibility(
                                          visible: _userRole != "kissan",
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: UserTextfield(
                                                  validationBuilder:
                                                      ValidationBuilder(
                                                              requiredMessage:
                                                                  "")
                                                          .minLength(8)
                                                          .maxLength(45)
                                                          .build(),
                                                  label: "Password",
                                                  controller: userPass,
                                                  prefix: const Icon(
                                                      Icons.lock_outline),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: _userRole != "kissan",
                                          child: const SizedBox(
                                            height: 15,
                                          ),
                                        ),
                                        Visibility(
                                          visible: _userRole != "kissan",
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: UserTextfield(
                                                  label: "Company",
                                                  validationBuilder:
                                                      ValidationBuilder(
                                                              requiredMessage:
                                                                  "")
                                                          .minLength(2)
                                                          .maxLength(45)
                                                          .build(),
                                                  controller: userCompany,
                                                  prefix: const Icon(
                                                      Icons.business_rounded),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: _userRole == "vyapari",
                                          child: const SizedBox(
                                            height: 15,
                                          ),
                                        ),
                                        Visibility(
                                          visible: _userRole == "vyapari",
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Tooltip(
                                                  message: "Commission",
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.grey,
                                                            width: 1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    width: 100,
                                                    child: DropdownButton(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      underline: const Text(""),
                                                      isExpanded: true,
                                                      dropdownColor:
                                                          Colors.white,
                                                      style: const TextStyle(
                                                          fontFamily: "sans",
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.black87),
                                                      value: _commissionPercent,
                                                      onChanged:
                                                          (int? newValue) {
                                                        setState(() {
                                                          _commissionPercent =
                                                              newValue!;
                                                        });
                                                      },
                                                      items: <int>[
                                                        5,
                                                        10,
                                                        15,
                                                        20,
                                                        25,
                                                        30,
                                                      ].map<
                                                              DropdownMenuItem<
                                                                  int>>(
                                                          (int value) {
                                                        return DropdownMenuItem<
                                                            int>(
                                                          value: value,
                                                          child: Text(
                                                              value.toString()),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 50,
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Tooltip(
                                                  message: "Hammali",
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.grey,
                                                            width: 1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    width: 100,
                                                    child: DropdownButton(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      underline: const Text(""),
                                                      isExpanded: true,
                                                      dropdownColor:
                                                          Colors.white,
                                                      style: const TextStyle(
                                                          fontFamily: "sans",
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.black87),
                                                      value: _hammaliPercent,
                                                      onChanged:
                                                          (int? newValue) {
                                                        setState(() {
                                                          _hammaliPercent =
                                                              newValue!;
                                                        });
                                                      },
                                                      items: <int>[
                                                        5,
                                                        10,
                                                        15,
                                                        20,
                                                        25,
                                                        30
                                                      ].map<
                                                              DropdownMenuItem<
                                                                  int>>(
                                                          (int value) {
                                                        return DropdownMenuItem<
                                                            int>(
                                                          value: value,
                                                          child: Text(
                                                              value.toString()),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: UserTextfield(
                                                label: "Aadhar",
                                                validationBuilder:
                                                    ValidationBuilder(
                                                            requiredMessage: "")
                                                        .minLength(12)
                                                        .maxLength(12)
                                                        .build(),
                                                controller: userAadhar,
                                                prefix: const Icon(
                                                    Icons.business_rounded),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: UserTextfield(
                                                label: "Pan Card",
                                                validationBuilder:
                                                    ValidationBuilder(
                                                            requiredMessage: "")
                                                        .minLength(2)
                                                        .maxLength(45)
                                                        .build(),
                                                controller: userPan,
                                                prefix: const Icon(
                                                    Icons.business_rounded),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Tooltip(
                                                message: "Branch",
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.grey,
                                                          width: 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  width: 100,
                                                  child: DropdownButton(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    underline: const Text(""),
                                                    isExpanded: true,
                                                    dropdownColor: Colors.white,
                                                    style: const TextStyle(
                                                        fontFamily: "sans",
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black87),
                                                    value: _branch,
                                                    onChanged:
                                                        (String? newValue) {
                                                      setState(() {
                                                        _branch = newValue!;
                                                      });
                                                    },
                                                    items: _branchList.map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                  color: const Color(0xff0073dd)
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Center(
                                                  child: IconButton(
                                                      style: IconButton.styleFrom(
                                                          shape:
                                                              const RoundedRectangleBorder()),
                                                      onPressed: () {
                                                        showDialog(
                                                            barrierDismissible:
                                                                false,
                                                            context: context,
                                                            builder: (context) {
                                                              return const AddBranch();
                                                            });
                                                      },
                                                      icon: const Icon(
                                                        Icons.add,
                                                        color:
                                                            Color(0xff0073dd),
                                                      ))),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Tooltip(
                                                message: "LedgerGroup",
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.grey,
                                                          width: 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  width: 100,
                                                  child: DropdownButton<
                                                      LedgergroupModel>(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    underline: const Text(""),
                                                    isExpanded: true,
                                                    dropdownColor: Colors.white,
                                                    style: const TextStyle(
                                                        fontFamily: "sans",
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black87),
                                                    value: _ledgerGroup,
                                                    onChanged:
                                                        (LedgergroupModel?
                                                            newValue) {
                                                      setState(() {
                                                        _ledgerGroup =
                                                            newValue!;
                                                      });
                                                    },
                                                    items: _ledgerGroupList.map<
                                                            DropdownMenuItem<
                                                                LedgergroupModel>>(
                                                        (LedgergroupModel
                                                            value) {
                                                      return DropdownMenuItem<
                                                          LedgergroupModel>(
                                                        value: value,
                                                        child: Text(
                                                            value.groupName),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                  color: const Color(0xff0073dd)
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Center(
                                                  child: IconButton(
                                                      style: IconButton.styleFrom(
                                                          shape:
                                                              const RoundedRectangleBorder()),
                                                      onPressed: () {
                                                        showDialog(
                                                            barrierDismissible:
                                                                false,
                                                            context: context,
                                                            builder: (context) {
                                                              return const AddLedgergroup();
                                                            });
                                                      },
                                                      icon: const Icon(
                                                        Icons.add,
                                                        color:
                                                            Color(0xff0073dd),
                                                      ))),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Visibility(
                                          visible: !widget.toUpdate,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: UserTextfield(
                                                  label: "Balance",
                                                  isAmount: true,
                                                  controller: userBalance,
                                                  prefix: const Icon(
                                                      Icons.business_rounded),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: UserTextfield(
                                                  label: "Cr Amt",
                                                  isAmount: true,
                                                  controller: userReceived,
                                                  prefix: const Icon(
                                                      Icons.business_rounded),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: UserTextfield(
                                                  label: "Dr Amt",
                                                  isAmount: true,
                                                  controller: userDue,
                                                  prefix: const Icon(
                                                      Icons.business_rounded),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: UserTextfield(
                                                label: "Note",
                                                validationBuilder:
                                                    ValidationBuilder(
                                                            requiredMessage: "")
                                                        .minLength(2)
                                                        .maxLength(45)
                                                        .build(),
                                                controller: note,
                                                prefix: const Icon(
                                                    Icons.business_rounded),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                                flex: 3,
                                                child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 30,
                                                                vertical: 20),
                                                        backgroundColor:
                                                            const Color(
                                                                0xff0073dd),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5))),
                                                    onPressed: () {
                                                      if (_formkey.currentState!
                                                          .validate()) {
                                                        if (widget.toUpdate) {
                                                        } else {
                                                          UsersCrudOperations()
                                                              .addUserOnServer(
                                                            context,
                                                            _getUserModel(
                                                              userName.text,
                                                              userPass.text,
                                                              userPhone.text,
                                                              userPincode.text,
                                                              _userRole,
                                                              _userState,
                                                              userAddress.text,
                                                              userCity.text,
                                                              userCompany.text,
                                                              userEmail.text,
                                                              userAadhar.text,
                                                              userPan.text,
                                                              _commissionPercent,
                                                              _hammaliPercent,
                                                              _branch,
                                                              _ledgerGroup
                                                                  .ledgerGroupId,
                                                              note.text,
                                                            ),
                                                            _getUserKhata(
                                                              double.parse(userBalance
                                                                          .text ==
                                                                      ''
                                                                  ? "0"
                                                                  : userBalance
                                                                      .text),
                                                              double.parse(userReceived
                                                                          .text ==
                                                                      ''
                                                                  ? "0"
                                                                  : userReceived
                                                                      .text),
                                                              double.parse(
                                                                  userDue.text ==
                                                                          ''
                                                                      ? "0"
                                                                      : userDue
                                                                          .text),
                                                            ),
                                                          );
                                                        }
                                                      }
                                                    },
                                                    child: Text(
                                                      widget.toUpdate
                                                          ? "Update"
                                                          : "Submit",
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ))),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: Container(
                      height: 800,
                      decoration: const BoxDecoration(
                          color: Color(0xff0073dd),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5))),
                    )),
              ],
            ),
          );
  }
}

UserModel _getUserModel(
  String name,
  String password,
  String phone,
  String pincode,
  String role,
  String state,
  String address,
  String city,
  String company,
  String email,
  String aadhar,
  String panCard,
  int commission,
  int hammali,
  String branch,
  int ledgerGroupId,
  String note,
) {
  if (role != "kissan") {
    return UserModel(
      name: name,
      password: password,
      phone: phone,
      pincode: pincode,
      role: role,
      state: state,
      address: address,
      city: city,
      company: company,
      email: email,
      userId: 0,
      aadhar: aadhar,
      panCard: panCard,
      branch: branch,
      ledgerGroupId: ledgerGroupId,
      commissionPercent: role == "kelagroup" ? 0 : commission,
      hammaliPercent: role == "kelagroup" ? 0 : hammali,
      note: note,
    );
  } else {
    return UserModel(
      name: name,
      password: "",
      phone: phone,
      pincode: pincode,
      role: role,
      state: state,
      address: address,
      city: city,
      company: "",
      email: "",
      userId: 0,
      aadhar: aadhar,
      panCard: panCard,
      branch: branch,
      ledgerGroupId: ledgerGroupId,
      commissionPercent: 0,
      hammaliPercent: 0,
      note: note,
    );
  }
}

KhataModel _getUserKhata(
  double total,
  double received,
  double due,
) {
  return KhataModel(
      khataId: 0, received: received, total: total, due: due, userId: 0);
}
