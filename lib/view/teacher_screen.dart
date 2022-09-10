import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/teacher_model.dart';

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({Key? key}) : super(key: key);

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  List<TeacherModel> _teacherList = [];
  late Box<TeacherModel> _teacherBox;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _teacherBox = Hive.box('teacher_box');
    _refreshItems();
  }

  Future<void> _createItem(TeacherModel data) async {
    await _teacherBox.add(data);
    _refreshItems();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added a new item')));
  }

  void _refreshItems() {
    setState(() {
     _teacherList = _teacherBox.values.toList();
    });
  }

  Future<void> _deleteItem(int itemIndex) async {
    await _teacherBox.deleteAt(itemIndex);
    _refreshItems();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('An item has been deleted')));
  }

  Future<void> _updateItem(int itemIndex, TeacherModel data) async {
    await _teacherBox.putAt(itemIndex, data);
    _refreshItems();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('update a item')));
  }

  void _showDialog(BuildContext ctx, int? itemIndex){
    if (itemIndex != null) {
      _nameController.text = _teacherList[itemIndex].name;
      _mobileController.text = _teacherList[itemIndex].mobile;
      _emailController.text = _teacherList[itemIndex].email;
    }
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Add Teacher'),
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
                  controller: _mobileController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Mobile'),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(hintText: 'Email'),
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
                      TeacherModel data = TeacherModel(
                        name: _nameController.text.trim(),
                        mobile: _mobileController.text.trim(),
                        email: _emailController.text.trim(),
                      );

                      _createItem(data);
                    }

                    // // update an existing item
                    if (itemIndex != null) {
                      TeacherModel data = TeacherModel(
                        name: _nameController.text.trim(),
                        mobile: _mobileController.text.trim(),
                        email: _emailController.text.trim(),
                      );
                      _updateItem(itemIndex, data);
                    }

                    /// Clear the text fields
                    _nameController.text = '';
                    _mobileController.text = '';
                    _emailController.text = '';

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
      _nameController.text = _teacherList[itemIndex].name;
      _mobileController.text = _teacherList[itemIndex].mobile;
      _emailController.text = _teacherList[itemIndex].email;
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
              controller: _mobileController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Mobile'),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(hintText: 'Email'),
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
                  TeacherModel data = TeacherModel(
                    name: _nameController.text.trim(),
                    mobile: _mobileController.text.trim(),
                    email: _emailController.text.trim(),
                  );

                  _createItem(data);
                }

                // // update an existing item
                if (itemIndex != null) {
                  TeacherModel data = TeacherModel(
                    name: _nameController.text.trim(),
                    mobile: _mobileController.text.trim(),
                    email: _emailController.text.trim(),
                  );
                  _updateItem(itemIndex, data);
                }

                /// Clear the text fields
                _nameController.text = '';
                _mobileController.text = '';
                _emailController.text = '';

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
          'Lazy box',
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
      body: _teacherList.isEmpty
          ? const Center(
              child: Text(
                'No Data',
                style: TextStyle(fontSize: 30),
              ),
            )
          : ListView.builder(
          itemCount: _teacherList.length,
          itemBuilder: (_, index) {
            final currentItem = _teacherList[index];
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
                                    'Mobile: ${currentItem.mobile}',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    'Email: ${currentItem.email}',
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
