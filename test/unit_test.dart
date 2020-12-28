import 'package:flutter_monthly_budget/models/validate_forms.dart';
//import 'package:flutter_monthly_budget/screens/transaction.dart';
import 'package:flutter_test/flutter_test.dart';

//Test for text form field
void main() {
  //Group of common test
  group('Transaction', () {
    //Test for amount field
    test('Amount Field', () {
      var result =
          ValidateForm.validateAmount('aa'); //Testing if input as character
      expect(result, 'Only numeric value is allowed');
    });
    test('Amount Field', () {
      var result = ValidateForm.validateAmount(''); //Testing if empty
      expect(result, 'Amount Required');
    });
    test('Amount Field', () {
      var result = ValidateForm.validateAmount('1'); //Testing for integer value
      expect(result, null);
    });
    test('Amount Field', () {
      var result = ValidateForm.validateAmount(
          '0'); //Testing if amount is 0, i.e. not a valid amount for transaction
      expect(result, 'Valid Amount is required');
    });

    //Test for description field
    test('Description Field', () {
      var result = ValidateForm.validateDescription(''); //Testing if empty
      expect(result, 'Description Required');
    });
    test('Description Field', () {
      var result = ValidateForm.validateDescription(
          'Test Description'); //Testing if contain character
      expect(result, null);
    });
    test('Description Field', () {
      //Testing if description size is greater then 50
      var result = ValidateForm.validateDescription(
          'Test Description this contain more than 50 characters Test Description this contain more than 50 characters Test Description this contain more than 50 characters');
      expect(result, 'Description not exceed then 50 characters');
    });
  });
}
