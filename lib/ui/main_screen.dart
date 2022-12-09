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
  final _nameInputController = TextEditingController();
  final _ageInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<UsersBloc, UsersState>(
      listener: (BuildContext context, state) {
        if (state is UsersLoadedState) {
          print(state.users);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _nameInputController,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                labelText: 'Enter valid user name',
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
              onPressed: () {
                _addTestValues();
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AlertDialog(
                        title: Text("Success"),
                        content: Text("User added"),
                      );
                    });
              },
              child: const Text('Add test users'),
            ),
            ElevatedButton(
              onPressed: _printUsers,
              child: const Text('Print DB'),
            ),
          ],
        ),
      ),
    );
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
  }

  void _printUsers() {
    final bloc = BlocProvider.of<UsersBloc>(context);
    //bloc.add(LoadUsersEvent());
    
    
  }
}
