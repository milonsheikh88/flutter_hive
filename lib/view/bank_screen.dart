import 'package:flutter/material.dart';
import 'package:flutter_hive/models/bank_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/bank_model.dart';

class BankScreen extends StatefulWidget {
  const BankScreen({Key? key}) : super(key: key);

  @override
  State<BankScreen> createState() => _BankScreenState();
}

class _BankScreenState extends State<BankScreen> {
  List<BankModel> _bankList = [];
  late Box<BankModel> _bankBox;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bankBox = Hive.box('bank_box');
    _refreshItems();
  }

  Future<void> _createItem(BankModel data) async {
    await _bankBox.add(data);
    _refreshItems();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added a new item')));
  }

  void _refreshItems() {
    setState(() {
     _bankList = _bankBox.values.toList();
    });
  }

  Future<void> _deleteItem(int itemIndex) async {
    await _bankBox.deleteAt(itemIndex);
    _refreshItems();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('An item has been deleted')));
  }

  Future<void> _updateItem(int itemIndex, BankModel data) async {
    await _bankBox.putAt(itemIndex, data);
    _refreshItems();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('update a item')));
  }

  void _showDialog(BuildContext ctx, int? itemIndex){
    if (itemIndex != null) {
      _nameController.text = _bankList[itemIndex].name;
      _accountController.text = _bankList[itemIndex].accountNumber.toString();
      _amountController.text = _bankList[itemIndex].amount.toString();
    }
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Add Teacher'),
          content:  SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(hintText: 'Name'),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _accountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Account Number'),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Amount'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.indigo, // background
                    onPrimary: Colors.white, // foreground
                  ),
                  onPressed: () async {
                    // Save new item
                    if (itemIndex == null) {
                      BankModel data = BankModel(
                        name: _nameController.text.trim(),
                        accountNumber: int.parse(_accountController.text.trim()),
                        amount: int.parse(_amountController.text.trim()),
                      );

                      _createItem(data);
                    }

                    // // update an existing item
                    if (itemIndex != null) {
                      BankModel data = BankModel(
                        name: _nameController.text.trim(),
                        accountNumber: int.parse(_accountController.text.trim()),
                        amount: int.parse(_amountController.text.trim()),
                      );
                      _updateItem(itemIndex, data);
                    }

                    /// Clear the text fields
                    _nameController.text = '';
                    _accountController.text = '';
                    _amountController.text = '';
                    Navigator.of(context).pop(); // Close the bottom sheet
                  },
                  child: Text(itemIndex == null ? 'Create' : 'Update'),
                ),
                const SizedBox(
                  height: 15,
                )
              ],
            ),
          ),
        ));
  }

  void _showBottomSheet(BuildContext ctx, int? itemIndex) async {
    if (itemIndex != null) {
      _nameController.text = _bankList[itemIndex].name;
      _accountController.text = _bankList[itemIndex].accountNumber.toString();
      _amountController.text = _bankList[itemIndex].amount.toString();
    }

    showModalBottomSheet(
      context: ctx,
      elevation: 5,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24.0))),
      builder: (_) => Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, top: 24, left: 20, right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'Name'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _accountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Account Number'),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Amount'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.indigo, // background
                onPrimary: Colors.white, // foreground
              ),
              onPressed: () async {
                // Save new item
                if (itemIndex == null) {
                  BankModel data = BankModel(
                    name: _nameController.text.trim(),
                    accountNumber: int.parse(_accountController.text.trim()),
                    amount: int.parse(_amountController.text.trim()),
                  );

                  _createItem(data);
                }

                // // update an existing item
                if (itemIndex != null) {
                  BankModel data = BankModel(
                    name: _nameController.text.trim(),
                    accountNumber: int.parse(_accountController.text.trim()),
                    amount: int.parse(_amountController.text.trim()),
                  );
                  _updateItem(itemIndex, data);
                }
                /// Clear the text fields
                _nameController.text = '';
                _accountController.text = '';
                _amountController.text = '';

                Navigator.of(context).pop(); // Close the bottom sheet
              },
              child: Text(itemIndex == null ? 'Create' : 'Update'),
            ),
            const SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigoAccent.withOpacity(0.16),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.indigoAccent,
        leading: Icon(
          Icons.menu,
          color: Colors.white,
        ),
        title: Text(
          'Encrypted box',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () => _showDialog(context, null),
          )
        ],
      ),
      body: _bankList.isEmpty
          ? const Center(
              child: Text(
                'No Data',
                style: TextStyle(fontSize: 30),
              ),
            )
          : ListView.builder(
          itemCount: _bankList.length,
          itemBuilder: (_, index) {
            final currentItem = _bankList[index];
            return Container(
              color: Colors.white,
              margin: const EdgeInsets.all(10),
              child:Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                              child: CircleAvatar(
                                backgroundColor: Colors.indigo,
                                child: Text(
                                  (index + 1).toString(),
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentItem.name,
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    'A/C: ${currentItem.accountNumber.toString()}',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    'Amount: ${currentItem.amount.toString()}',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ///  Edit button
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.greenAccent),
                            onPressed: () => _showDialog(context, index),
                          ),

                          /// Delete button
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () => _deleteItem(index),
                          ),
                        ],
                      ),
                    ),
                  ]),
            );
          }),
    );
  }
}
