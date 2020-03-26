import 'package:flutter/material.dart';

import '../model/card.dart';
import 'card_cvc_form_field.dart';
import 'card_expiry_form_field.dart';
import 'card_number_form_field.dart';

/// Basic form to add or edit a credit card, with complete validation.
class CardForm extends StatefulWidget {
  CardForm(
      {Key key,
      @required this.formKey,
      @required this.card,
      this.cardNumberDecoration,
      this.cardNumberTextStyle,
      this.cardExpiryDecoration,
      this.cardExpiryTextStyle,
      this.cardCvcDecoration,
      this.cardCvcTextStyle,
      this.cardNumberErrorText,
      this.cardExpiryErrorText,
      this.cardCvcErrorText,
      this.cardCvcTextInputAction,
      this.submitAction})
      : super(key: key);

  final GlobalKey<FormState> formKey;
  final StripeCard card;
  final InputDecoration cardNumberDecoration;
  final TextStyle cardNumberTextStyle;
  final InputDecoration cardExpiryDecoration;
  final TextStyle cardExpiryTextStyle;
  final InputDecoration cardCvcDecoration;
  final TextStyle cardCvcTextStyle;
  final String cardNumberErrorText;
  final String cardExpiryErrorText;
  final String cardCvcErrorText;
  final TextInputAction cardCvcTextInputAction;
  final Function submitAction;

  @override
  _CardFormState createState() => _CardFormState();
}

class _CardFormState extends State<CardForm> {
  final StripeCard _validationModel = StripeCard();

  final FocusNode _numberFocus = FocusNode();
  final FocusNode _expiryFocus = FocusNode();
  final FocusNode _cvvFocus = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            margin: const EdgeInsets.only(top: 16),
            child: CardNumberFormField(
              initialValue: _validationModel.number ?? widget.card.number,
              onChanged: (number) => _validationModel.number = number,
              validator: (text) => _validationModel.validateNumber()
                  ? null
                  : widget.cardNumberErrorText ?? CardNumberFormField.defaultErrorText,
              onSaved: (text) => widget.card.number = text,
              focusNode: _numberFocus,
              onFieldSubmitted:
                  _fieldFocusChange(context, _numberFocus, _expiryFocus),
              textStyle: widget.cardNumberTextStyle ??
                  CardNumberFormField.defaultTextStyle,
              decoration: widget.cardNumberDecoration ??
                  CardNumberFormField.defaultDecoration,
            ),
          ),
          Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(top: 8),
              child: CardExpiryFormField(
                initialMonth: _validationModel.expMonth ?? widget.card.expMonth,
                initialYear: _validationModel.expYear ?? widget.card.expYear,
                onChanged: (int month, int year) {
                  _validationModel.expMonth = month;
                  _validationModel.expYear = year;
                },
                onSaved: (int month, int year) {
                  widget.card.expMonth = month;
                  widget.card.expYear = year;
                },
                validator: (text) => _validationModel.validateDate()
                    ? null
                    : widget.cardExpiryErrorText ??
                        CardExpiryFormField.defaultErrorText,
                focusNode: _expiryFocus,
                onFieldSubmitted:
                    _fieldFocusChange(context, _expiryFocus, _cvvFocus),
                textStyle: widget.cardExpiryTextStyle ??
                    CardExpiryFormField.defaultTextStyle,
                decoration: widget.cardExpiryDecoration ??
                    CardExpiryFormField.defaultDecoration,
              )),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            margin: const EdgeInsets.only(top: 8),
            child: CardCvcFormField(
              initialValue: _validationModel.cvc ?? widget.card.cvc,
              onChanged: (text) => _validationModel.cvc = text,
              onSaved: (text) => widget.card.cvc = text,
              validator: (text) => _validationModel.validateCVC()
                  ? null
                  : widget.cardCvcErrorText ??
                      CardCvcFormField.defaultErrorText,
              focusNode: _cvvFocus,
              onFieldSubmitted: (value) {
                _cvvFocus.unfocus();
                if (widget.submitAction != null) {
                  widget.submitAction();
                }
              },
              textStyle:
                  widget.cardCvcTextStyle ?? CardCvcFormField.defaultTextStyle,
              decoration: widget.cardCvcDecoration ??
                  CardCvcFormField.defaultDecoration,
              textInputAction: widget.cardCvcTextInputAction ??
                  CardCvcFormField.defaultTextInputAction,
            ),
          ),
        ],
      ),
    );
  }
}
