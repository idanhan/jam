import 'package:flutter/material.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:provider/provider.dart';
import './cityChange.dart';

class countryCityDrop extends StatelessWidget {
  String contryValue = 'Country';
  String cityValue = 'City';
  String stateValue = 'State';

  @override
  Widget build(BuildContext context) {
    return Consumer<StateCityChange>(
      builder: (context, controller, child) => CSCPicker(
        showCities: true,
        showStates: true,

        ///placeholders for dropdown search field
        countrySearchPlaceholder: "Country",
        stateSearchPlaceholder: "State",
        citySearchPlaceholder: "City",

        ///labels for dropdown
        countryDropdownLabel: "Country",
        stateDropdownLabel: "State",
        cityDropdownLabel: "City",
        currentCity: controller.cityValue,
        currentCountry: controller.countryValue,
        currentState: controller.stateValue,
        dropdownHeadingStyle: const TextStyle(
            color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
        flagState: CountryFlag.ENABLE,
        onCountryChanged: (value) {
          ///store value in country variable
          controller.changeCountry(value);
          print(contryValue);
        },
        onStateChanged: (value) {
          if (value != null) {
            controller.changeState(value);
          }
        },

        ///triggers once state selected in dropdown
        onCityChanged: (value) {
          if (value != null) {
            controller.changeCity(value);
          }
        },
      ),
    );
  }
}
