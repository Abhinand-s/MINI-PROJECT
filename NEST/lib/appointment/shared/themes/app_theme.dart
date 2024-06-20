import 'package:flutter/material.dart';

class AppTheme{
  const AppTheme();
  ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _colorScheme,
      textTheme: _textTheme,
      inputDecorationTheme: _inputDecorationTheme,
      filledButtonTheme: _filledButtonTheme,

    );
  }
}
 ColorScheme get _colorScheme{
  return const ColorScheme(
    brightness: Brightness.light,
     primary: Color(0xff909cdf),
      onPrimary:Color(0xffFFFFFF) ,
      primaryContainer: Color(0xfff2f3fb),
      onPrimaryContainer: Color(0xff000000),
       secondary:Color(0xff9c254d),
        onSecondary: Color(0xffffffff),
        secondaryContainer: Color(0xffdfa3b7),
        tertiary: Color(0xffb6c2ff),
        tertiaryContainer: Color(0xffffffff),
        errorContainer: Color(0xff000000),
        surfaceVariant: Color(0xffeeeeee),
        outline: Color(0xff737373),
        outlineVariant: Color(0xffbfbfbf),
        inverseSurface: Color(0xff121212),
        surfaceTint: Color(0xff909cdf)
        , error: Color(0xFF5e162e),
         onError:Color(0xFFf5e9ed),
          background:Color(0xFFFFFFFF),
           onBackground: Color(0xff000000),
            surface: Color(0xFFf4f5fc),
             onSurface: Color(0xFF0e1016));
}

TextTheme get _textTheme{
  return const TextTheme(
   
  );
}
InputDecorationTheme get _inputDecorationTheme{
  return InputDecorationTheme(
    filled: true,
    fillColor: _colorScheme.background,
    border: InputBorder.none,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 12.0,
      vertical: 12.0
    ),
    enabledBorder: _enableBorder,
    focusedBorder: _focusedBorder,
    disabledBorder: _disabledBorder

  );
}
FilledButtonThemeData get _filledButtonTheme{
  return FilledButtonThemeData(
        style: FilledButton.styleFrom(
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0)
          )
        )
  );
}

InputBorder get _enableBorder => OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color:Colors.transparent)
);
InputBorder get _focusedBorder => OutlineInputBorder(
  borderRadius: BorderRadius.circular(8.0),
  borderSide: BorderSide.none
);
InputBorder get _disabledBorder => OutlineInputBorder(
  borderRadius: BorderRadius.circular(8.0),
  borderSide: BorderSide(color: Colors.grey.withOpacity(0.2))
);
