import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:listly/pages/list/widgets/check_list_item_options_widget.dart';
import 'package:listly/shared/models/check_list_item.dart';
import 'package:listly/shared/services/api_service.dart';

class CheckListItemWidget extends StatefulWidget {
    final ValueChanged update;
    final CheckListItem item;

    const CheckListItemWidget({
        super.key,
        required this.update,
        required this.item
    });

    @override
    CheckListItemWidgetState createState() {
        return CheckListItemWidgetState();
    }
}

class CheckListItemWidgetState extends State<CheckListItemWidget> {
    ApiService api = ApiService();

    void handleOnChanged(bool? value) {
        final payload = {
            'name': widget.item.name,
            'list_id': widget.item.listId,
            'completed': value
        };

        api.put('/list-item/${widget.item.id}', payload).then((value) {
            widget.update('');
        });
    }

    @override
    build(BuildContext context) {
        return GestureDetector(
            onLongPress: () {
                showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    builder: (BuildContext context) => CheckListItemOptionsWidget(
                        item: widget.item,
                        update: widget.update
                    )
                );
            },
            child: FormBuilderCheckbox(
                name: 'checkbox',
                onChanged: handleOnChanged,
                initialValue: widget.item.completed,
                activeColor: ColorScheme.dark().primary,
                title: Text(widget.item.name),
            )
        );
    }
}
