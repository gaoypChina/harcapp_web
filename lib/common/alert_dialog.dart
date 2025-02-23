import 'package:flutter/material.dart';
import 'package:harcapp_core/comm_classes/app_text_style.dart';
import 'package:harcapp_core/comm_classes/color_pack.dart';
import 'package:harcapp_core/comm_widgets/app_card.dart';
import 'package:harcapp_core/comm_widgets/app_text.dart';
import 'package:harcapp_core/comm_widgets/simple_button.dart';
import 'package:harcapp_core/dimen.dart';

class DialogRoute extends PageRoute{

  Widget Function(BuildContext context) builder;
  bool dismissible;

  DialogRoute({required this.builder, this.dismissible = true});

  @override
  Color get barrierColor => Colors.black54;

  @override
  String? get barrierLabel => null;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => dismissible;

  @override
  Curve get barrierCurve => Curves.easeInOut;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => SafeArea(
      child: builder(context)
  );

  @override
  Widget buildTransitions(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child
      ) => FadeTransition(
    opacity: animation,
    child: child,
  );

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 230);

}

Future<void> openDialog({
  required BuildContext context,
  required Widget Function(BuildContext context) builder,
  bool dismissible = true
}) => Navigator.push(
    context,
    DialogRoute(
      builder: builder,
      dismissible: dismissible,
    )
);

class AlertDialogButton extends StatelessWidget{

  final String text;
  final Color? textColor;
  final bool enabled;
  final void Function() onTap;

  const AlertDialogButton({required this.text, this.textColor, this.enabled = true, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) => SimpleButton(
      radius: AppCard.bigRadius,
      padding: const EdgeInsets.all(Dimen.ICON_MARG),
      onTap: enabled?onTap:null,
      child: Text(text, style: AppTextStyle(fontWeight: weight.halfBold, color: textColor??(enabled?textEnab_(context):textDisab_(context)), fontSize: Dimen.TEXT_SIZE_BIG))
  );

}

Future<void> showAlertDialog(
    BuildContext context,
    { required String title,
      required String content,
      Widget? leading,
      List<Widget> Function(BuildContext context)? actionBuilder,
      bool dismissible = true,
    }) => openDialog(
  context: context,
  dismissible: dismissible,
  builder: (BuildContext context) => AlertDialog(
    title: Text(title, style: AppTextStyle(fontWeight: weight.halfBold)),
    content: Row(
      children: [
        if(leading != null) leading,
        Expanded(child: AppText(content, size: Dimen.TEXT_SIZE_BIG))
      ],
    ),
    actions: actionBuilder==null?null:actionBuilder(context),
    actionsPadding: const EdgeInsets.only(bottom: Dimen.ICON_MARG, right: Dimen.ICON_MARG),
    backgroundColor: cardEnab_(context),
    contentTextStyle: TextStyle(color: textEnab_(context)),
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Dimen.SIDE_MARG))),
  ),
);