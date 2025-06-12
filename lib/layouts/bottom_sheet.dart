import 'package:flutter/material.dart';
import 'package:flutter_expense_traker/theme/theme_extension.dart';
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
  final TextEditingController _timeController = TextEditingController();
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

  void onTapTimePicker(BuildContext context) {
    showTimePicker(context: context, initialTime: TimeOfDay.now()).then((
      selectedTime,
    ) {
      if (selectedTime != null) {
        final formatted = DateFormat(
          'HH:mm',
        ).format(DateTime(0, 0, 0, selectedTime.hour, selectedTime.minute));
        _timeController.text = formatted;
        print('Selected time: $selectedTime');
      }
    });
  }

  // Focus nodes for the text fields
  final FocusNode _amountFocusNode = FocusNode();
  final FocusNode _noteFocusNode = FocusNode();
  final FocusNode _dateFocusNode = FocusNode();
  final FocusNode _timeFocusNode = FocusNode();

  final List<String> _categoryNames = [
    'Food',
    'Transportation',
    'Entertainment',
    'Utilities',
    'Other',
  ];

  // State variable to hold the currently selected category.
  String? _selectedCategory;

  void _handleCategoryTap(String category) {
    setState(() {
      _selectedCategory = category; // Update the selected category
    });
    // You can also pass this category to an upper widget using a callback function here.
    print('Selected Category: $category'); // For demonstration
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _amountFocusNode.dispose();
    _noteFocusNode.dispose();
    _dateController.dispose();
    _dateFocusNode.dispose();
    _timeController.dispose();
    _timeFocusNode.dispose();
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
            Text(
              'add Transaction',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            //TODO: Add validator to the amount field
            MyTextFeild(
              controller: _amountController,
              focusNode: _amountFocusNode,
              hintText: 'Enter amount',
              keyboardType: TextInputType.number,
              maxLength: 10,
            ),
            Wrap(
              spacing: 8.0, // Horizontal space between items
              runSpacing: 8.0, // Vertical space between lines of items
              children:
                  _categoryNames.map((category) {
                    // Changed 'categories' to '_categoryNames'
                    return RoundContainer2(
                      onTap:
                          () =>
                              _handleCategoryTap(category), // Pass tap handler
                      isSelected:
                          _selectedCategory == category, // Set selection state
                      child: Text(category), // Display category text
                    );
                  }).toList(),
            ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: MyTextFeild(
                    controller: _dateController,
                    focusNode: _dateFocusNode,
                    hintText: 'Select date',
                    icon: Icons.calendar_month_rounded,
                    keyboardType: TextInputType.none,
                    readOnly: true,
                    onTap: () => onTapDatePicker(context),
                  ),
                ),
                const Spacer(flex: 1),
                Expanded(
                  flex: 3,
                  child: MyTextFeild(
                    controller: _timeController,
                    focusNode: _timeFocusNode,
                    readOnly: true,

                    hintText: 'Select Time',
                    icon: Icons.calendar_month_rounded,
                    keyboardType: TextInputType.none,
                    onTap: () => onTapTimePicker(context),
                  ),
                ),
              ],
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
    this.readOnly = false,
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
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorTheme.lightGreyColor,
      ),
      child: Center(
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          readOnly: readOnly,
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
