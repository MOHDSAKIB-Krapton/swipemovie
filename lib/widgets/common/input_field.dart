import 'package:flutter/material.dart';

enum InputType { text, email, password, name }

class InputField extends StatefulWidget {
  const InputField({
    super.key,
    required this.controller,
    required this.hintText,
    this.inputType = InputType.text, // Default to a simple text field
  });

  final TextEditingController controller;
  final String hintText;
  final InputType inputType;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  // State variable to manage password visibility
  bool _showPassword = false;

  // A private helper method to create the InputDecoration
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400]),
      filled: true,
      fillColor: Colors.grey[800],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(0),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      // Add a suffix icon specifically for password fields
      suffixIcon: widget.inputType == InputType.password
          ? IconButton(
              icon: Icon(
                _showPassword ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey[400],
              ),
              onPressed: () {
                setState(() {
                  _showPassword = !_showPassword;
                });
              },
            )
          : null,
    );
  }

  // A private helper method to determine the keyboard type based on the input type
  TextInputType _getKeyboardType() {
    switch (widget.inputType) {
      case InputType.email:
        return TextInputType.emailAddress;
      case InputType.password:
        return TextInputType.visiblePassword;
      case InputType.name:
        return TextInputType.name;
      case InputType.text:
        return TextInputType.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the text should be obscured (for passwords)
    final bool obscureText =
        widget.inputType == InputType.password && !_showPassword;

    return SizedBox(
      width: double.infinity,
      child: TextField(
        controller: widget.controller,
        keyboardType: _getKeyboardType(),
        cursorColor: const Color(0xFFE50914),
        obscureText: obscureText,
        decoration: _inputDecoration(widget.hintText),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
