import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField {
  Widget secondaryTextField(
    BuildContext context, {
    String? headline,
    String? hintT,
    TextEditingController? controller, // todo make this required
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    bool? obscureText,
    FocusNode? focusNode,
    bool? isNavigator,
    onTapFunction,
    String? hintText,
    Widget? prefixWidget,
    Widget? suffixIcon,
    bool? onlyNumbers = false,
    onSubmitted,
    int? lines,
    int? maxLength,
    bool? enabled = true,
    List<TextInputFormatter>? inputFormatters,
  }) {
    ThemeData theme = Theme.of(context);
    return Column(
      children: [
        if (headline != null) ...[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(headline,
                style: theme.textTheme.bodyText2!.copyWith(color: Colors.grey)),
          ),
          const SizedBox(height: 10),
        ],
        Container(
          decoration: BoxDecoration(
              color: const Color(0xffF6F6F6),
              borderRadius: BorderRadius.circular(6)),
          child: TextField(
            enabled: enabled,
            controller: controller,
            keyboardType: keyboardType ?? TextInputType.text,
            textInputAction: textInputAction ?? TextInputAction.done,
            obscureText: obscureText ?? false,
            onSubmitted: onSubmitted,
            readOnly: isNavigator ?? false,
            showCursor: isNavigator ?? true,
            focusNode: focusNode,
            maxLength: maxLength,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            onTap: onTapFunction ?? () {},
            style: theme.textTheme.bodyText1,
            minLines: lines ?? 1,
            inputFormatters: inputFormatters,
            maxLines: lines ?? 1,
            decoration: InputDecoration(
              prefixIcon: prefixWidget == null
                  ? null
                  : Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: prefixWidget,
                    ),
              suffixIcon: suffixIcon == null
                  ? null
                  : Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: suffixIcon,
                    ),
              fillColor: const Color(0xffF6F6F6),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              border: secondaryFieldOutlineInputBorder(),
              enabledBorder: secondaryFieldOutlineInputBorder(),
              disabledBorder: secondaryFieldOutlineInputBorder(),
              focusedBorder: secondaryFieldOutlineInputBorder(),
              hintText: hintText,
              hintStyle: theme.textTheme.bodyText2!
                  .copyWith(color: Colors.grey.withOpacity(0.9)),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  OutlineInputBorder secondaryFieldOutlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(GlobalSizes.kBorderRadius / 4),
      borderSide: BorderSide(
        color: const Color(0xffffffff).withOpacity(0.1),
        width: 1,
        style: BorderStyle.solid,
      ),
    );
  }

  OutlineInputBorder phoneFieldOutlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(GlobalSizes.kBorderRadius / 4),
      borderSide: BorderSide(
        color: Color.fromARGB(255, 131, 131, 131),
        // color: const Color(0xffffffff).withOpacity(0.1),
        width: 1,
        // style: BorderStyle.solid,
      ),
    );
  }

  Widget withouttitleTextField(
    BuildContext context, {
    final String? headline,
    final TextEditingController? controller, // todo make this required
    final TextInputType? keyboardType,
    final TextInputAction? textInputAction,
    final bool? obscureText,
    final FocusNode? focusNode,
    final bool? isNavigator,
    final onTapFunction,
    final String? hintText,
    final Widget? prefixWidget,
    final Widget? suffixIcon,
    final bool? onlyNumbers = false,
    final onSubmitted,
    final onChanged,
    final textCapitalization = TextCapitalization.none,
    final Color? fillColor,
    final int? lines,
    final double? radiusBorder,
    final List<TextInputFormatter>? inputFormatters,
  }) {
    ThemeData theme = Theme.of(context);
    return Container(
      height: 44,
      decoration: BoxDecoration(
          color: fillColor ?? const Color(0xffF6F6F6),
          borderRadius: BorderRadius.circular(radiusBorder ?? 6.0)),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType ?? TextInputType.text,
        textInputAction: textInputAction ?? TextInputAction.done,
        obscureText: obscureText ?? false,
        onSubmitted: onSubmitted,
        textCapitalization: textCapitalization,
        readOnly: isNavigator ?? false,
        showCursor: isNavigator ?? true,
        focusNode: focusNode,
        onTap: onTapFunction ?? () {},
        onChanged: onChanged ?? (String val) {},
        style: theme.textTheme.bodyText1,
        minLines: lines ?? 1,
        inputFormatters: inputFormatters,
        maxLines: lines ?? 1,
        decoration: InputDecoration(
          prefixIcon: prefixWidget == null
              ? null
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: prefixWidget,
                ),
          suffixIcon: suffixIcon == null
              ? null
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: suffixIcon,
                ),
          fillColor: fillColor ?? const Color(0xffF6F6F6),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
          border: secondaryFieldOutlineInputBorder(),
          enabledBorder: secondaryFieldOutlineInputBorder(),
          focusedBorder: secondaryFieldOutlineInputBorder(),
          hintText: hintText,
          hintStyle: theme.textTheme.bodyText2!
              .copyWith(color: Colors.grey.withOpacity(0.9)),
        ),
      ),
    );
  }

  Widget phoneTextField(
    BuildContext context, {
    final String? headline,
    final TextEditingController? controller, // todo make this required
    final TextInputType? keyboardType,
    final TextInputAction? textInputAction,
    final bool? obscureText,
    final FocusNode? focusNode,
    final bool? isNavigator,
    final onTapFunction,
    final String? hintText,
    final Widget? prefixWidget,
    final Widget? suffixIcon,
    final bool? onlyNumbers = false,
    final onSubmitted,
    final onChanged,
    final textCapitalization = TextCapitalization.none,
    final Color? fillColor,
    final int? lines,
    final double? radiusBorder,
    final List<TextInputFormatter>? inputFormatters,
  }) {
    ThemeData theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType ?? TextInputType.text,
      textInputAction: textInputAction ?? TextInputAction.done,
      obscureText: obscureText ?? false,
      // onSubmitted: onSubmitted,

      textCapitalization: textCapitalization,
      readOnly: isNavigator ?? false,
      showCursor: isNavigator ?? true,
      focusNode: focusNode,
      onTap: onTapFunction ?? () {},
      onChanged: onChanged ?? (String val) {},
      style: theme.textTheme.bodyText1,
      minLines: lines ?? 1,
      inputFormatters: inputFormatters,
      maxLines: lines ?? 1,
      decoration: InputDecoration(
        prefixIcon: prefixWidget == null
            ? null
            : Padding(
                padding: const EdgeInsets.all(12.0),
                child: prefixWidget,
              ),
        suffixIcon: suffixIcon == null
            ? null
            : Padding(
                padding: const EdgeInsets.all(12.0),
                child: suffixIcon,
              ),
        // fillColor: fillColor ?? const Color(0xffF6F6F6),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        border: phoneFieldOutlineInputBorder(),
        enabledBorder: phoneFieldOutlineInputBorder(),
        focusedBorder: phoneFieldOutlineInputBorder(),
        labelText: hintText,
        labelStyle: TextStyle(color: Colors.grey, fontSize: 16),
      ),
    );
  }
}

class GlobalSizes {
  static double kBorderRadius = 16;
  static double kChipBorderRadius = 6;
  static double kPaddingHorizontal = 15;
  static double kPaddingHorizontalLoginView = 25;
  static double kPaddingHorizontalSignupView = 25;
}
