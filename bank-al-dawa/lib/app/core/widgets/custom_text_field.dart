import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    required this.autofillHints,
    required this.icon,
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.validator,
    this.enableSuggestions = true,
    this.isPassword = true,
    this.autocorrect = true,
    this.inputType = TextInputType.name,
    this.textInputAction = TextInputAction.next,
    Key? key,
  }) : super(key: key);
  final String autofillHints;
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  final bool enableSuggestions;
  final bool autocorrect;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputType inputType;
  final TextInputAction textInputAction;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isSecurePassword = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofillHints: [widget.autofillHints],
      controller: widget.controller,
      enableSuggestions: true,
      readOnly: false,
      obscureText: widget.isPassword && isSecurePassword,
      autocorrect: true,
      style: Theme.of(context)
          .textTheme
          .subtitle1, //TextStyle(color: Colors.black.withOpacity(0.9)),
      textInputAction: widget.textInputAction,
      cursorColor: Theme.of(context).primaryColor,
      decoration: InputDecoration(
        hintStyle: TextStyle(
            color:
                Theme.of(context).textTheme.subtitle1!.color!.withOpacity(0.5)),
        labelStyle: TextStyle(
            color:
                Theme.of(context).textTheme.subtitle1!.color!.withOpacity(0.5)),
        errorStyle: const TextStyle(
            color: Colors.red,
            fontSize: 10,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w200),
        labelText: widget.labelText,
        hintText: widget.hintText,
        floatingLabelBehavior: FloatingLabelBehavior.never, //always
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 0.0),
          child: Icon(
            widget.icon,
            color: Theme.of(context).primaryColor,
          ),
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                    isSecurePassword ? Icons.visibility : Icons.visibility_off),
                color: Theme.of(context).primaryColor,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onPressed: () {
                  isSecurePassword = !isSecurePassword;
                  setState(() {});
                },
              )
            : null,
      ),
      validator: widget.validator,
      keyboardType: widget.inputType,
    );
  }
}
// onEditingComplete: () => TextInput.finishAutofillContext(),
