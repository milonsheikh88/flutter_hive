import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _studentList = [];
  late Box _studentBox;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _marksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _studentBox = Hive.box('home_box');
    _refreshItems();
  }

  void _refreshItems() {
    final data = _studentBox.keys.map((key) {
      final value = _studentBox.get(key);
      return {"key": key, "name": value["name"], "marks": value['marks']};
    }).toList();
    setState(() {
      _studentList = data.toList();
    });
  }

  Future<void> _createItem(Map<String, dynamic> newItem) async {
    await _studentBox.add(newItem);
    _refreshItems();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added a new item')));
  }

  Future<void> _updateItem(int itemKey, Map<String, dynamic> item) async {
    await _studentBox.put(itemKey, item);
    _refreshItems();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('update a item')));
  }

  Future<void> _deleteItem(int itemKey) async {
    await _studentBox.delete(itemKey);
    _refreshItems();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('An item has been deleted')));
  }

  void _showDialog(BuildContext ctx, int? itemKey){
    if (itemKey != null) {
      final existingItem = _studentList.firstWhere((element) => element['key'] == itemKey);
      _nameController.text = existingItem['name'];
      _marksController.text = existingItem['marks'];
    }

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Add Student'),
          content:SingleChildScrollView(
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
                    if (itemKey == null) {
                      _createItem({"name": _nameController.text, "marks": _marksController.text});
                    }

                    // update an existing item
                    if (itemKey != null) {
                      _updateItem(itemKey, {'name': _nameController.text.trim(), 'marks': _marksController.text.trim()});
                    }

                    // Clear the text fields
                    _nameController.text = '';
                    _marksController.text = '';

                    Navigator.of(context).pop(); // Close the bottom sheet
                  },
                  child: Text(itemKey == null ? 'Create' : 'Update'),
                ),
              ],
            ),
          ),
        ),);
  }

  void _showBottomSheet(BuildContext ctx, int? itemKey) async {
    if (itemKey != null) {
      final existingItem = _studentList.firstWhere((element) => element['key'] == itemKey);
      _nameController.text = existingItem['name'];
      _marksController.text = existingItem['marks'];
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
                if (itemKey == null) {
                  _createItem({"name": _nameController.text, "marks": _marksController.text});
                }

                // update an existing item
                if (itemKey != null) {
                  _updateItem(itemKey, {'name': _nameController.text.trim(), 'marks': _marksController.text.trim()});
                }

                // Clear the text fields
                _nameController.text = '';
                _marksController.text = '';

                Navigator.of(context).pop(); // Close the bottom sheet
              },
              child: Text(itemKey == null ? 'Create' : 'Update'),
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
          'Hive Box',
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
                          (currentItem['key'] + 1).toString(),
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                        ),
                      ),
                      title: Text(
                        currentItem['name'],
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                      subtitle: Text(
                        currentItem['marks'].toString(),
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Edit button
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.greenAccent),
                            onPressed: () => _showDialog(context, currentItem['key']),
                          ),
                          // Delete button
                          IconButton(
                            icon: const Icon(Icons.delete,color: Colors.redAccent),
                            onPressed: () => _deleteItem(currentItem['key']),
                          ),
                        ],
                      )),
                );
              }),
    );
  }
}
