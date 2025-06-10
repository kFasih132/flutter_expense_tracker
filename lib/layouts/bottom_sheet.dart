import 'package:flutter/material.dart';
import 'package:flutter_expense_traker/widgets/round_container.dart';
import 'package:intl/intl.dart';

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
  final TextEditingController _dateController = TextEditingController();
  String groupValue = 'Expense'; // Example group value for radio button
  final String expense = 'Expense';
  final String income = 'Income';
  void onChanged(String? value) {
    setState(() {
      groupValue = value!;
    });
  }

  void onTapDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    ).then((selectedDate) {
      if (selectedDate != null) {
        final formatted = DateFormat('dd/MM/yyyy').format(selectedDate);
        _dateController.text = formatted;
        print('Selected date: $selectedDate');
      }
    });
  }

  // Focus nodes for the text fields
  final FocusNode _amountFocusNode = FocusNode();
  final FocusNode _noteFocusNode = FocusNode();
  final FocusNode _dateFocusNode = FocusNode();

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _amountFocusNode.dispose();
    _noteFocusNode.dispose();
    _dateController.dispose();
    _dateFocusNode.dispose();
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
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            const Text('add Transaction'),
            //TODO: Add validator to the amount field
            MyTextFeild(
              controller: _amountController,
              focusNode: _amountFocusNode,
              hintText: 'Enter amount',
              keyboardType: TextInputType.number,
              maxLength: 10,
            ),
            const CategoryList(),
            MyTextFeild(
              controller: _noteController,
              focusNode: _noteFocusNode,
              hintText: 'Enter note',
              keyboardType: TextInputType.text,
              maxLines: 2,
            ),
            ListTile(
              title: const Text('Transaction Type'),
              subtitle: Row(
                children: [
                  Radio.adaptive(
                    value: expense,
                    groupValue: groupValue,
                    onChanged: onChanged,
                  ),
                  const Text('Expense'),
                  Radio.adaptive(
                    value: income,
                    groupValue: groupValue,
                    onChanged: onChanged,
                  ),
                  const Text('Income'),
                ],
              ),
            ),
            MyTextFeild(
              controller: _dateController,
              focusNode: _dateFocusNode,
              labelText: 'Date',
              hintText: 'Select date',
              icon: Icons.calendar_month_rounded,
              keyboardType: TextInputType.none,
              onTap: () => onTapDatePicker(context),
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
    this.onTap,
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
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        //TODO: add real color from theme
        color: Color(0xffe5e7eb),
      ),
      child: Center(
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          maxLines: maxLines,
          maxLength: maxLength,
          onTap: onTap,
          obscureText: obscureText ?? false,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            disabledBorder: InputBorder.none,

            labelText: labelText,
            hintText: hintText,
            icon: icon != null ? Icon(icon) : null,
          ),
          validator: validator,
          onTapOutside: (event) {
            FocusScope.of(context).unfocus();
          },
        ),
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
