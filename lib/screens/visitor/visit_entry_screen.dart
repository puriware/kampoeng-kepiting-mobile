import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../models/visit.dart';
import '../../providers/auth.dart';
import '../../providers/districts.dart';
import '../../providers/provinces.dart';
import '../../providers/regencies.dart';
import '../../providers/visits.dart';
import '../../widgets/message_dialog.dart';
import 'package:nanoid/async.dart';
import 'package:provider/provider.dart';

class VisitEntryScreen extends StatefulWidget {
  static const routeName = '/new-visit';
  VisitEntryScreen({Key? key}) : super(key: key);

  @override
  _VisitEntryScreenState createState() => _VisitEntryScreenState();
}

class _VisitEntryScreenState extends State<VisitEntryScreen> {
  var _dropDownProviceValue = '00';
  var _dropDownRegencyValue = '0000';
  var _dropDownDistrictValue = '0000000';
  List<DropdownMenuItem<String>> _provinceItems = [];
  List<DropdownMenuItem<String>> _regencyItems = [];
  List<DropdownMenuItem<String>> _districtItems = [];
  TextEditingController _crtlRegion = TextEditingController();
  var _isInit = true;
  var _isLoading = false;
  var _userId;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      try {
        _userId = Provider.of<Auth>(context, listen: false).activeUser!.id;
        await Provider.of<Provinces>(context, listen: false)
            .fetchAndSetProvinces();
        await Provider.of<Regencies>(context, listen: false)
            .fetchAndSetRegencies();
        await Provider.of<Districts>(context, listen: false)
            .fetchAndSetDistricts();

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

        _provinceItems.add(
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

  void _saveVisit() async {
    setState(() {
      _isLoading = true;
    });
    try {
      if (_crtlRegion.text.isNotEmpty) {
        final newVisit = Visit(
          visitor: _userId,
          region: _crtlRegion.text,
          visitCode: _userId + '#' + await nanoid(),
          province: _dropDownProviceValue,
          regency: _dropDownRegencyValue,
          district: _dropDownDistrictValue,
        );

        final result = await Provider.of<Visits>(
          context,
          listen: false,
        ).addVisit(newVisit);

        MessageDialog.showPopUpMessage(context, 'Add visit result', result);
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      } else {
        MessageDialog.showPopUpMessage(
          context,
          'Region is empty',
          'Please insert your origin region',
        );
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visit Entry'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.save,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(large),
                  topRight: Radius.circular(large),
                ),
              ),
              padding: EdgeInsets.all(large),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Text(
                        'Please enter your origin data',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    SizedBox(
                      height: large,
                    ),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: _dropDownProviceValue,
                      decoration: InputDecoration(
                        labelText: 'Province',
                        border: OutlineInputBorder(),
                        //prefixIcon: Icon(Icons.query_builder_sharp),
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
                        //prefixIcon: Icon(Icons.query_builder_sharp),
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
                        //prefixIcon: Icon(Icons.query_builder_sharp),
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
                        //helperText: _customerName,
                        //enabled: false,
                      ),
                      controller: _crtlRegion,
                      keyboardType: TextInputType.streetAddress,
                      onFieldSubmitted: (_) {
                        _saveVisit();
                      },
                    ),
                    SizedBox(
                      height: large,
                    ),
                    ElevatedButton.icon(
                      onPressed: _saveVisit,
                      icon: Icon(Icons.save_rounded),
                      label: Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
