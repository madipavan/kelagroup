import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:kelawin/Models/ledgergroup_model.dart';
import 'package:kelawin/presentation/user_operations/widgets/user_textfield.dart';
import 'package:kelawin/utils/apputils.dart';

import '../../../viewmodel/usersCrudOperations/ledger_group_operations.dart';

class AddLedgergroup extends StatefulWidget {
  const AddLedgergroup({super.key});

  @override
  State<AddLedgergroup> createState() => _AddLedgergroupState();
}

class _AddLedgergroupState extends State<AddLedgergroup> {
  final TextEditingController _groupName = TextEditingController();
  final TextEditingController _balanceSheetHead = TextEditingController();
  final TextEditingController _addNewType = TextEditingController();
  bool _addTypeVisibility = false;
  final _formkey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _addTypeKey = GlobalKey<FormFieldState>();
  String _type = "CurrentAssets";
  List<String> _typeList = [];
  List<LedgergroupModel> _foundList = [];
  bool _isLoading = true;

  @override
  void initState() {
    _getData();
    super.initState();
  }

  Future _getData() async {
    _typeList = await LedgerGroupOperations().getLedgerGroupTypeFromServer();
    _foundList = await LedgerGroupOperations().getAllLedgerGroupFromServer();
    _type = _typeList[0];
    _isLoading = false;
    if (mounted) {
      setState(() {
        _typeList = _typeList;
        _foundList = _foundList;
        _isLoading = _isLoading;
      });
    }
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
            content: SizedBox(
              height: 700,
              width: 550,
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  title: const Text(
                    "Ledger Group",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Colors.white,
                  leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back)),
                ),
                body: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 80),
                        child: Form(
                          key: _formkey,
                          child: Column(
                            children: [
                              UserTextfield(
                                  validationBuilder: ValidationBuilder()
                                      .minLength(2)
                                      .maxLength(100)
                                      .build(),
                                  label: "Group Name",
                                  controller: _groupName),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey, width: 1),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      width: 100,
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
                                        value: _type,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _type = newValue!;
                                          });
                                        },
                                        items: _typeList
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(value),
                                                IconButton(
                                                    onPressed: () async {
                                                      Apputils().showConfirmBox(
                                                          context,
                                                          "Sure want to Delete Type",
                                                          () async {
                                                        LedgerGroupOperations()
                                                            .deleteLedgerGroupTypeOnServer(
                                                                context, value);
                                                      });
                                                    },
                                                    icon: const Icon(
                                                        Icons.delete))
                                              ],
                                            ),
                                          );
                                        }).toList(),
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
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Center(
                                        child: IconButton(
                                            style: IconButton.styleFrom(
                                                shape:
                                                    const RoundedRectangleBorder()),
                                            onPressed: () {
                                              setState(() {
                                                _addTypeVisibility
                                                    ? _addTypeVisibility = false
                                                    : _addTypeVisibility = true;
                                              });
                                            },
                                            icon: Icon(
                                              _addTypeVisibility
                                                  ? Icons.cancel
                                                  : Icons.add,
                                              color: const Color(0xff0073dd),
                                            ))),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Visibility(
                                visible: _addTypeVisibility,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      key: _addTypeKey,
                                      controller: _addNewType,
                                      validator: ValidationBuilder()
                                          .minLength(2)
                                          .maxLength(100)
                                          .build(),
                                      cursorColor: Colors.grey,
                                      decoration: InputDecoration(
                                          suffix: IconButton(
                                              onPressed: () async {
                                                if (_addTypeKey.currentState!
                                                    .validate()) {
                                                  await Apputils().showConfirmBox(
                                                      context,
                                                      'Are You Sure To Add "${_addNewType.text}"',
                                                      () async {
                                                    await LedgerGroupOperations()
                                                        .addLedgerGroupTypeOnServer(
                                                            context,
                                                            _addNewType.text);
                                                  });
                                                  setState(() {
                                                    _addTypeVisibility = false;
                                                  });
                                                }
                                              },
                                              icon: const Icon(
                                                  Icons.edit_note_rounded)),
                                          label: const Text(
                                            "Add Type",
                                            style:
                                                TextStyle(color: Colors.grey),
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
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                ),
                              ),
                              UserTextfield(
                                  validationBuilder: ValidationBuilder()
                                      .minLength(2)
                                      .maxLength(100)
                                      .build(),
                                  label: "BalanceSheet Head",
                                  controller: _balanceSheetHead),
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
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 30,
                                                      vertical: 20),
                                              backgroundColor:
                                                  const Color(0xff0073dd),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5))),
                                          onPressed: () {
                                            if (_formkey.currentState!
                                                .validate()) {
                                              LedgerGroupOperations()
                                                  .addLedgerGroupOnServer(
                                                      context,
                                                      _getModel(
                                                          _groupName.text,
                                                          _type,
                                                          _balanceSheetHead
                                                              .text));
                                            }
                                          },
                                          child: const Text(
                                            "Submit",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
                                          )))
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Table(
                            columnWidths: const {
                              0: FractionColumnWidth(0.12),
                            },
                            border: TableBorder(
                              // Horizontal borders
                              verticalInside: BorderSide(
                                  color: Colors.grey.shade300, width: 1),
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
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Text(
                                        'LG ID',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Text(
                                        'GroupName',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Text(
                                        'Type',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Text(
                                        'Action',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ]),
                              for (int i = 0; i < _foundList.length; i++)
                                TableRow(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey, width: 1)),
                                    ),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          (i + 1).toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontFamily: "sans",
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          _foundList[i]
                                              .ledgerGroupId
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontFamily: "sans",
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          _foundList[i].groupName.toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontFamily: "sans",
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          _foundList[i].groupType.toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontFamily: "sans",
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: IconButton(
                                              onPressed: () async {
                                                await Apputils().showConfirmBox(
                                                    context,
                                                    'Are you sure you want to delete this Group?',
                                                    () async {
                                                  await LedgerGroupOperations()
                                                      .deleteLedgerGroupOnServer(
                                                          context,
                                                          _foundList[i]
                                                              .ledgerGroupId);
                                                });
                                              },
                                              icon: const Icon(Icons.delete))),
                                    ])
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }
}

LedgergroupModel _getModel(
    String groupName, String groupType, String balanceSheetHead) {
  return LedgergroupModel(
      ledgerGroupId: 0,
      groupName: groupName,
      groupType: groupType,
      balanceSheetHead: balanceSheetHead);
}
