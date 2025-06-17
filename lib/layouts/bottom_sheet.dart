import 'package:flutter/material.dart';
import 'package:flutter_expense_traker/data_base/category.dart';
import 'package:flutter_expense_traker/data_base/db.dart';
import 'package:flutter_expense_traker/data_base/transactions.dart';
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
  String groupValue = 'expense'; // Example group value for radio button
  final String expense = 'expense';
  final String income = 'income';
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
  Future<List<Categories>>? catigoories;

  Future<List<Categories>> getCategories() async {
    return await DbService().getAllCategories();
  }

  final List<String> _categoryNames = [
    'Food',
    'Transportation',
    'Entertainment',
    'Utilities',
    'Other',
  ];

  // State variable to hold the currently selected category.
  String? _selectedCategory;
  String? categoryId;

  void _handleCategoryTap(Categories category) {
    setState(() {
      _selectedCategory = category.name;
      categoryId = category.categoryId;
      // Update the selected category
    });
    // You can also pass this category to an upper widget using a callback function here.
    print('Selected Category: $category'); // For demonstration
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    catigoories = getCategories();
    _dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    _timeController.text = DateFormat('HH:mm').format(DateTime.now());
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
            MyTextFeild(
              controller: _amountController,
              focusNode: _amountFocusNode,
              hintText: 'Enter amount',
              keyboardType: TextInputType.number,
              maxLength: 10,
            ),
            FutureBuilder(
              future: catigoories,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Categories>? data = snapshot.data;
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        data!.map((e) {
                          return RoundContainer2(
                            onTap: () => _handleCategoryTap(e),
                            isSelected: _selectedCategory == e.name,
                            child: Text(e.name ?? 'no  name'),
                          );
                        }).toList(),
                  );
                } else {}
                return CircularProgressIndicator();
              },
            ),

            MyTextFeild(
              controller: _noteController,
              focusNode: _noteFocusNode,
              hintText: 'Enter note',
              keyboardType: TextInputType.text,
              maxLines: 2,
            ),
            ListTile(
              title: Text(
                'Transaction Type',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
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
                    hintText: DateFormat('dd/MM/yyyy').format(DateTime.now()),
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

                    hintText: DateFormat('HH:mm').format(DateTime.now()),
                    icon: Icons.calendar_month_rounded,
                    keyboardType: TextInputType.none,
                    onTap: () => onTapTimePicker(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ), //TODO: add Transac tion to dataBase
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pop(context);
                        try {
                          DbService().insertTransaction(
                            Transactions(
                              amount: num.parse(
                                _amountController.text.toString(),
                              ),
                              userId: 'Fasih/#12',
                              date: DateFormat(
                                'dd/mm/yyyy',
                              ).parse(_dateController.text),
                              time: _timeController.text,
                              transactionType: groupValue,
                              note: _noteController.text,
                              description: _noteController.text,
                              categoryId: 1,
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('data invalid or any error 4e: $e'),
                            ),
                          );
                        }
                      }
                    },
                    child: Text(
                      'Add',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
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
