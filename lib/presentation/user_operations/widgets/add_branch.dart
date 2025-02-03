import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

import '../../../utils/apputils.dart';
import '../../../viewmodel/usersCrudOperations/branch_crud_operations.dart';

class AddBranch extends StatefulWidget {
  const AddBranch({super.key});

  @override
  State<AddBranch> createState() => _AddBranchState();
}

class _AddBranchState extends State<AddBranch> {
  bool _addBranchVisibility = false;
  String _branch = "Shahpur";
  List<String> _branchList = [];
  bool _isLoading = true;
  final TextEditingController _addNewBranch = TextEditingController();
  final GlobalKey<FormFieldState> _addBranchKey = GlobalKey<FormFieldState>();
  @override
  void initState() {
    _getData();
    super.initState();
  }

  Future _getData() async {
    _branchList = await BranchCrudOperations().getBranchFromServer();

    _branch = _branchList[0];
    _isLoading = false;
    if (mounted) {
      setState(() {
        _branchList = _branchList;

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
              width: 500,
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  title: const Text(
                    "Add Branch",
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
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey, width: 1),
                                  borderRadius: BorderRadius.circular(5)),
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
                                value: _branch,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _branch = newValue!;
                                  });
                                },
                                items: _branchList
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
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
                                color: const Color(0xff0073dd).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                                child: IconButton(
                                    style: IconButton.styleFrom(
                                        shape: const RoundedRectangleBorder()),
                                    onPressed: () {
                                      setState(() {
                                        _addBranchVisibility
                                            ? _addBranchVisibility = false
                                            : _addBranchVisibility = true;
                                      });
                                    },
                                    icon: Icon(
                                      _addBranchVisibility
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
                        visible: _addBranchVisibility,
                        child: Column(
                          children: [
                            TextFormField(
                              key: _addBranchKey,
                              controller: _addNewBranch,
                              validator: ValidationBuilder()
                                  .minLength(2)
                                  .maxLength(100)
                                  .build(),
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                  suffix: IconButton(
                                      onPressed: () async {
                                        if (_addBranchKey.currentState!
                                            .validate()) {
                                          await Apputils().showConfirmBox(
                                              context,
                                              'Are You Sure To Add "${_addNewBranch.text}"',
                                              () async {
                                            await BranchCrudOperations()
                                                .addBranchOnServer(context,
                                                    _addNewBranch.text);
                                          });
                                          setState(() {
                                            _addBranchVisibility = false;
                                          });
                                        }
                                      },
                                      icon:
                                          const Icon(Icons.edit_note_rounded)),
                                  label: const Text(
                                    "Add Branch",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: Colors.blue.shade700, width: 1),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
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
                      const SizedBox(
                        height: 15,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Table(
                            columnWidths: const {
                              0: FractionColumnWidth(0.15),
                              2: FractionColumnWidth(0.2),
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
                                        'Branch Name',
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
                              for (int i = 0; i < _branchList.length; i++)
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
                                          _branchList[i],
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
                                                    'Are You Sure To Delete Branch "${_branchList[i]}"',
                                                    () async {
                                                  await BranchCrudOperations()
                                                      .deleteBranchOnServer(
                                                          context,
                                                          _branchList[i]);
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
            ),
          );
  }
}
