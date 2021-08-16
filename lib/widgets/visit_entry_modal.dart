import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../providers/districts.dart';
import '../../providers/provinces.dart';
import '../../providers/regencies.dart';
import '../../widgets/message_dialog.dart';
import 'package:provider/provider.dart';

class VisiEntryModal extends StatefulWidget {
  final Function saveVisit;
  VisiEntryModal(this.saveVisit, {Key? key}) : super(key: key);

  @override
  _VisiEntryModalState createState() => _VisiEntryModalState();
}

class _VisiEntryModalState extends State<VisiEntryModal> {
  var _dropDownProviceValue = '00';
  var _dropDownRegencyValue = '0000';
  var _dropDownDistrictValue = '0000000';
  List<DropdownMenuItem<String>> _provinceItems = [];
  List<DropdownMenuItem<String>> _regencyItems = [];
  List<DropdownMenuItem<String>> _districtItems = [];
  TextEditingController _crtlRegion = TextEditingController();
  var _isInit = true;
  var _isLoading = false;
  var _isWarning = false;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      try {
        final dataProvinces =
            Provider.of<Provinces>(context, listen: false).provinces;

        if (dataProvinces.isNotEmpty) {
          _provinceItems = dataProvinces
              .map(
                (prov) => DropdownMenuItem(
                  child: Text(prov.name),
                  value: prov.id,
                ),
              )
              .toList();
        }

        _provinceItems.insert(
          0,
          DropdownMenuItem(
            child: Text('Undefined'),
            value: '00',
          ),
        );

        _regencyItems.add(
          DropdownMenuItem(
            child: Text('Undefined'),
            value: '0000',
          ),
        );

        _districtItems.add(
          DropdownMenuItem(
            child: Text('Undefined'),
            value: '0000000',
          ),
        );
        _isInit = false;
      } catch (error) {
        MessageDialog.showPopUpMessage(
          context,
          "Error",
          error.toString(),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _dropDownProviceValue = '00';
    _dropDownRegencyValue = '0000';
    _dropDownDistrictValue = '0000000';
    _provinceItems.clear();
    _regencyItems.clear();
    _districtItems.clear();
    super.dispose();
  }

  void _getRegencies() {
    try {
      final dataRegencies = Provider.of<Regencies>(context, listen: false)
          .getRegencyByProvinceId(_dropDownProviceValue);
      setState(() {
        if (dataRegencies != null && dataRegencies.isNotEmpty) {
          _regencyItems = dataRegencies
              .map(
                (reg) => DropdownMenuItem(
                  child: Text(reg.name),
                  value: reg.id,
                ),
              )
              .toList();
        } else {
          _regencyItems.clear();
        }

        _regencyItems.insert(
          0,
          DropdownMenuItem(
            child: Text('Undefined'),
            value: '0000',
          ),
        );
        _dropDownRegencyValue = '0000';
        _dropDownDistrictValue = '0000000';
      });
    } catch (error) {
      MessageDialog.showPopUpMessage(
        context,
        "Error",
        error.toString(),
      );
    }
  }

  void _getDistricts() {
    try {
      final dataDistricts = Provider.of<Districts>(context, listen: false)
          .getDistrictByRegencyId(_dropDownRegencyValue);

      setState(() {
        if (dataDistricts != null && dataDistricts.isNotEmpty) {
          _districtItems = dataDistricts
              .map(
                (reg) => DropdownMenuItem(
                  child: Text(reg.name),
                  value: reg.id,
                ),
              )
              .toList();
        } else {
          _districtItems.clear();
        }

        _districtItems.insert(
          0,
          DropdownMenuItem(
            child: Text('Undefined'),
            value: '0000000',
          ),
        );

        _dropDownDistrictValue = '0000000';
      });
    } catch (error) {
      MessageDialog.showPopUpMessage(
        context,
        "Error",
        error.toString(),
      );
    }
  }

  void _savingVisit() {
    setState(() {
      _isWarning = false;
    });

    if (_crtlRegion.text.isNotEmpty) {
      final region = _crtlRegion.text;
      final province =
          _dropDownProviceValue != '00' ? _dropDownProviceValue : null;
      final regency =
          _dropDownRegencyValue != '0000' ? _dropDownRegencyValue : null;
      final district =
          _dropDownDistrictValue != '0000000' ? _dropDownDistrictValue : null;

      widget.saveVisit(
        region,
        province,
        regency,
        district,
      );
      Navigator.of(context).pop();
    } else {
      setState(() {
        _isWarning = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                top: large,
                left: large,
                right: large,
              ),
              decoration: BoxDecoration(
                color: Colors.white10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(150.0, 0.0, 150.0, 8.0),
                    child: Container(
                      height: 8.0,
                      width: 8.0,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.all(
                          const Radius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Please enter your origin data',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  SizedBox(
                    height: large,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: _dropDownProviceValue,
                        decoration: InputDecoration(
                          labelText: 'Province',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.category_rounded),
                          //helperText: _incoDescription,
                        ),
                        icon: Icon(Icons.arrow_drop_down_circle_rounded),
                        items: _provinceItems,
                        onChanged: (value) {
                          _dropDownProviceValue = value.toString();
                          _getRegencies();
                        },
                      ),
                      SizedBox(
                        height: large,
                      ),
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: _dropDownRegencyValue,
                        decoration: InputDecoration(
                          labelText: 'Regency',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.category_rounded),
                          //helperText: _incoDescription,
                        ),
                        icon: Icon(Icons.arrow_drop_down_circle_rounded),
                        items: _regencyItems,
                        onChanged: (value) {
                          _dropDownRegencyValue = value.toString();
                          _getDistricts();
                        },
                      ),
                      SizedBox(
                        height: large,
                      ),
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: _dropDownDistrictValue,
                        decoration: InputDecoration(
                          labelText: 'District',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.category_rounded),
                          //helperText: _incoDescription,
                        ),
                        icon: Icon(Icons.arrow_drop_down_circle_rounded),
                        items: _districtItems,
                        onChanged: (value) {
                          _dropDownDistrictValue = value.toString();
                        },
                      ),
                      SizedBox(
                        height: large,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Region',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.house_rounded),
                          errorText: _isWarning
                              ? 'Please insert your origin region'
                              : null,
                        ),
                        controller: _crtlRegion,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                      ),
                      SizedBox(
                        height: large,
                      ),
                      Container(
                        height: 64,
                        child: ElevatedButton.icon(
                          onPressed: _savingVisit,
                          icon: Icon(Icons.save_rounded),
                          label: Text('Save'),
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
