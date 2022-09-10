import 'package:flutter/material.dart';

import '../models/student_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({Key? key}) : super(key: key);

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  List<StudentModel> _studentList = [];
  late Box<StudentModel> _studentBox;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _marksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _studentBox = Hive.box('student_box');
    _refreshItems();
  }

  Future<void> _createItem(StudentModel data) async {
    await _studentBox.add(data);
    _refreshItems();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added a new item')));
  }

  void _refreshItems() {
    setState(() {
      _studentList = _studentBox.values.toList();
    });
  }

  Future<void> _deleteItem(int itemIndex) async {
    await _studentBox.deleteAt(itemIndex);
    _refreshItems();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('An item has been deleted')));
  }

  Future<void> _updateItem(int itemIndex, StudentModel data) async {
    await _studentBox.putAt(itemIndex, data);
    _refreshItems();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('update a item')));
  }

  void _showDialog(BuildContext ctx, int? itemIndex){
    if (itemIndex != null) {
      _nameController.text = _studentList[itemIndex].name;
      _marksController.text = _studentList[itemIndex].marks.toString();
    }

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Add Student'),
          content: SingleChildScrollView(
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
                  controller: _marksController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Marks'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary:Colors.indigo, // background
                    onPrimary: Colors.white, // foreground
                  ),

                  onPressed: () async {
                    // Save new item
                    if (itemIndex == null) {
                      StudentModel data = StudentModel(name: _nameController.text.trim(), marks: int.parse(_marksController.text.trim()));

                      _createItem(data);
                    }

                    // // update an existing item
                    if (itemIndex != null) {
                      StudentModel data = StudentModel(name: _nameController.text.trim(), marks: int.parse(_marksController.text.trim()));
                      _updateItem(itemIndex, data);
                    }

                    /// Clear the text fields
                    _nameController.text = '';
                    _marksController.text = '';

                    Navigator.of(context).pop(); // Close the bottom sheet
                  },
                  child: Text(itemIndex == null ? 'Create' : 'Update'),
                ),
              ],
            ),
          ),
        ));
  }

  void _showBottomSheet(BuildContext ctx, int? itemIndex) async {
    if (itemIndex != null) {
      _nameController.text = _studentList[itemIndex].name;
      _marksController.text = _studentList[itemIndex].marks.toString();
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
              controller: _marksController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Marks'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary:Colors.indigo, // background
                onPrimary: Colors.white, // foreground
              ),

              onPressed: () async {
                // Save new item
                if (itemIndex == null) {
                  StudentModel data = StudentModel(name: _nameController.text.trim(), marks: int.parse(_marksController.text.trim()));

                  _createItem(data);
                }

                // // update an existing item
                if (itemIndex != null) {
                  StudentModel data = StudentModel(name: _nameController.text.trim(), marks: int.parse(_marksController.text.trim()));
                  _updateItem(itemIndex, data);
                }

                /// Clear the text fields
                _nameController.text = '';
                _marksController.text = '';

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
          'TypeAdepter',
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
      body: _studentList.isEmpty
          ? const Center(
              child: Text(
                'No Data',
                style: TextStyle(fontSize: 30),
              ),
            )
          : ListView.builder(
              itemCount: _studentList.length,
              itemBuilder: (_, index) {
                final currentItem = _studentList[index];
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.all(10),
                  elevation: 3,
                  child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.indigo,
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                        ),
                      ),
                      title: Text(
                        currentItem.name,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                      subtitle: Text(
                        currentItem.marks.toString(),
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ///  Edit button
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.greenAccent),
                            onPressed: () => _showDialog(context, index),
                          ),

                          /// Delete button
                          IconButton(
                            icon: const Icon(Icons.delete,color: Colors.redAccent),
                            onPressed: () => _deleteItem(index),
                          ),
                        ],
                      )),
                );
              }),
    );
  }
}
