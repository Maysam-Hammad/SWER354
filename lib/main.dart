import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Form Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/form',
      routes: {
        '/form': (context) => const MyFormScreen(),
        '/output': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          return OutputScreen(
            username: args?['username'],
            password: args?['password'],
            email: args?['email'],
            rememberMe: args?['rememberMe'],
            gender: args?['gender'],
            country: args?['country'],
            age: args?['age'],
            selectedDate: args?['selectedDate'],
          );
        },
      },
    );
  }
}

class MyFormScreen extends StatefulWidget {
  const MyFormScreen({super.key});

  @override
  State<MyFormScreen> createState() => _MyFormScreenState();
}

class _MyFormScreenState extends State<MyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _username;
  String? _password;
  String? _email;
  bool _rememberMe = false;
  String? _gender;
  String? _country;
  double _age = 18;
  DateTime? _selectedDate;

  final List<String> _countries = ['Palestine', 'Jordan', 'Egypt', 'Syria', 'Iraq'];
  final List<String> _genders = ['Male', 'Female'];

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.pushNamed(
        context,
        '/output',
        arguments: {
          'username': _username,
          'password': _password,
          'email': _email,
          'rememberMe': _rememberMe,
          'gender': _gender,
          'country': _country,
          'age': _age,
          'selectedDate': _selectedDate,
        },
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2050),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Form Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Username',
                  hintText: 'Enter your username',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
                onSaved: (value) => _username = value,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple),
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onSaved: (value) => _password = value,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email address',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                onSaved: (value) => _email = value,
              ),
              const SizedBox(height: 16.0),
              CheckboxListTile(
                title: const Text('Remember me'),
                value: _rememberMe,
                onChanged: (bool? value) {
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 16.0),
              Row(
                children: <Widget>[
                  const Text('Gender:'),
                  const SizedBox(width: 10.0),
                  ..._genders.map((gender) => Row(
                        children: <Widget>[
                          Radio<String>(
                            value: gender.toLowerCase(),
                            groupValue: _gender,
                            onChanged: (String? value) {
                              setState(() {
                                _gender = value;
                              });
                            },
                          ),
                          Text(gender),
                          const SizedBox(width: 10.0),
                        ],
                      )),
                ],
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Country',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple),
                  ),
                ),
                value: _country,
                items: _countries.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _country = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a country';
                  }
                  return null;
                },
                onSaved: (value) => _country = value,
              ),
              const SizedBox(height: 16.0),
              Row(
                children: <Widget>[
                  const Text('Age: '),
                  Expanded(
                    child: Slider(
                      value: _age,
                      min: 18,
                      max: 99,
                      divisions: 81,
                      label: _age.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          _age = value;
                        });
                      },
                    ),
                  ),
                  Text(_age.round().toString()),
                ],
              ),
              const SizedBox(height: 16.0),
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Select Date',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        _selectedDate == null
                            ? 'No date selected'
                            : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              OutlinedButton(
                onPressed: _submitForm,
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.purple),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.purple,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OutputScreen extends StatelessWidget {
  final String? username;
  final String? password;
  final String? email;
  final bool? rememberMe;
  final String? gender;
  final String? country;
  final double? age;
  final DateTime? selectedDate;

  const OutputScreen({
    super.key,
    this.username,
    this.password,
    this.email,
    this.rememberMe,
    this.gender,
    this.country,
    this.age,
    this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Output', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0, // Remove shadow for a cleaner look
      ),
      body: Container(
        color: Colors.white, // Match the form page background
        child: Center(
          child: Card(
            elevation: 8,
            margin: const EdgeInsets.all(16.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Form Details',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildDetailRow('Username', username),
                  _buildDetailRow('Password', password),
                  _buildDetailRow('Email', email),
                  _buildDetailRow('Remember me', rememberMe?.toString()),
                  _buildDetailRow('Gender', gender),
                  _buildDetailRow('Country', country),
                  _buildDetailRow('Age', age?.round().toString()),
                  _buildDetailRow(
                    'Selected Date',
                    selectedDate?.toString().split(' ')[0],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.purple),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Text(
                          'Go Back',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.purple,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Text(
            value ?? 'Not provided',
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}