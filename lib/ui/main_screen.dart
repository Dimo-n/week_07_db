import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_db/bloc/bloc.dart';
import 'package:test_db/bloc/events.dart';
import 'package:test_db/bloc/states.dart';
import 'package:test_db/model/user.dart';
import 'package:test_db/datasource/ds_users.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final textStyle = TextStyle(fontSize: 22);
  final _nameInputController = TextEditingController();
  final _ageInputController = TextEditingController();
  bool _nameInput = false;
  bool _ageInput = false;
  bool _buttonActive = false;
  var listItems = [];

  @override
  void initState() {
    super.initState();
    _nameInputController.addListener(() {
      setState(() {
        _nameInput = _nameInputController.text.isNotEmpty;
      });
    });
    _ageInputController.addListener(() {
      setState(() {
        _ageInput = _ageInputController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _nameInputController.dispose();
    _ageInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _buttonActive = _nameInput && _ageInput;
    return BlocConsumer<UsersBloc, UsersState>(listener: (context, state) {
      if (state is UsersLoadedState) {
        listItems = state.users;
      }
    }, builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _nameInputController,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                labelText: 'Enter user name',
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: _ageInputController,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                labelText: 'Enter user age',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: _buttonActive ? () => _addTestValues() : null,
              child: const Text('ADD USER'),
            ),
            ElevatedButton(
              onPressed: _printUsers,
              child: const Text('Print     DB'),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: listItems.length,
                    itemBuilder: (context, index) {
                      final item = listItems[index];
                      return Container(
                        height: 30,
                        color: Colors.grey.shade100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(item.id.toString(), style: textStyle,),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              item.name.toString(),
                              style: textStyle,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(item.age.toString(), style: textStyle,),
                          ],
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      );
    });
  }

  void _addTestValues() {
    final bloc = BlocProvider.of<UsersBloc>(context);
    bloc.add(
      AddUserEvent(
        User(
          name: _nameInputController.text,
          age: int.parse(_ageInputController.text),
        ),
      ),
    );
    FocusScope.of(context).unfocus();
    _nameInputController.clear();
    _ageInputController.clear();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text("Success"),
            content: Text("User added"),
          );
        });
  }

  void _printUsers() {
    final bloc = BlocProvider.of<UsersBloc>(context);
    bloc.add(LoadUsersEvent());
  }
}
