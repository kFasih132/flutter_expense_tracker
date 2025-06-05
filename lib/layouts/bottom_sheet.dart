import 'package:flutter/material.dart';
import 'package:flutter_expense_traker/widgets/round_container.dart';

class BottomSheetDialogForAddingTransaction extends StatefulWidget {
  const BottomSheetDialogForAddingTransaction({super.key});

  @override
  State<BottomSheetDialogForAddingTransaction> createState() =>
      _BottomSheetDialogForAddingTransactionState();
}

class _BottomSheetDialogForAddingTransactionState
    extends State<BottomSheetDialogForAddingTransaction> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  final FocusNode _amountFocusNode = FocusNode();
  final FocusNode _noteFocusNode = FocusNode();

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _amountFocusNode.dispose();
    _noteFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //TODO: add Styling and functionality to the bottom sheet dialog
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 20,
          children: [
            const Text('add Transaction'),
            //TODO: Add validator to the amount field
            MyTextFeild(
              controller: _amountController,
              focusNode: _amountFocusNode,
              labelText: 'Amount',
              hintText: 'Enter amount',
              icon: Icons.money,
              keyboardType: TextInputType.number,
              maxLength: 20,
            ),
            const CategoryList(),
            MyTextFeild(
              controller: _noteController,
              focusNode: _noteFocusNode,

              labelText: 'Note',
              hintText: 'Enter note',
              icon: Icons.note,
              keyboardType: TextInputType.text,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}

class MyTextFeild extends StatelessWidget {
  const MyTextFeild({
    super.key,
    this.controller,
    this.focusNode,
    this.labelText,
    this.hintText,
    this.icon,
    this.obscureText,
    this.keyboardType,
    this.maxLines,
    this.maxLength,
    this.validator,
  });
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? labelText;
  final String? hintText;
  final IconData? icon;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? maxLength;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.blueGrey.shade600,
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        maxLines: maxLines,
        maxLength: maxLength,
        obscureText: obscureText ?? false,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: null,
          labelText: labelText,
          hintText: hintText,
          icon: icon != null ? Icon(icon) : null,
        ),
        validator: validator,
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }
}

//TODO: add real category list
class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        RoundContainer(child: Text('Food')),
        RoundContainer(child: Text('Transportation')),
        RoundContainer(child: Text('Entertainment')),
        RoundContainer(child: Text('Utilities')),
        RoundContainer(child: Text('Other')),
      ],
    );
  }
}
