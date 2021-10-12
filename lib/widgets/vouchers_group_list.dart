import 'dart:core';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:kampoeng_kepiting_mobile/constants.dart';
import 'package:kampoeng_kepiting_mobile/widgets/voucher_item.dart';
import '../models/order_detail.dart';

class VouchersGroupList extends StatelessWidget {
  final vouchersData;
  VouchersGroupList(this.vouchersData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GroupedListView<OrderDetail, String>(
        elements: vouchersData,
        groupBy: (voucher) =>
            voucher.created!.toIso8601String().substring(0, 10),
        floatingHeader: true,
        useStickyGroupSeparators: true,
        order: GroupedListOrder.DESC,
        groupSeparatorBuilder: (String groupValue) => Container(
          height: 50,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: 120,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                border: Border.all(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(small),
                child: Text(
                  '${DateFormat('dd MMM yyyy').format(DateTime.parse(groupValue))}',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
        indexedItemBuilder: (ctx, voucher, idx) => VoucherItem(voucher.id),
      ),
    );
  }
}
