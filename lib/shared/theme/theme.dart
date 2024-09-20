import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:handees/shared/res/shapes.dart';

export 'theme_extensions.dart';

final _textTheme = GoogleFonts.cabinTextTheme(
  const TextTheme(
    titleMedium: TextStyle(
      fontWeight: FontWeight.w600,
    ),
    titleLarge: TextStyle(
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(
      fontSize: 20.0,
      height: 1.2,
    ),
    bodyMedium: TextStyle(
      fontSize: 16.0,
      height: 1.25,
    ),
    bodySmall: TextStyle(
      fontSize: 12.0,
      height: 0.75,
    ),
  ),
);

const lightColorScheme = ColorScheme.light(
  primary: Color.fromRGBO(20, 22, 28, 1),
  onPrimary: Colors.white,
  tertiary: Color.fromRGBO(243, 248, 254, 1),
  onSecondary: Color.fromRGBO(20, 22, 28, 1),
  errorContainer: Color.fromRGBO(255, 234, 234, 1),
  error: Color.fromRGBO(249, 22, 22, 1),
  //background: Color.fromRGBO(20, 22, 28, 0.1),
  secondary: Color.fromRGBO(235, 237, 240, 1),
  brightness: Brightness.light,
);

const _authColorScheme = ColorScheme.dark(
  primary: Colors.white,
  onPrimary: Colors.black,
  brightness: Brightness.dark,
);

final darkColorScheme = ColorScheme.dark(
  primary: const Color.fromARGB(255, 97, 97, 97),
  onPrimary: Colors.white,
  surface: ThemeData.dark().scaffoldBackgroundColor,
  brightness: Brightness.dark,
);

final _buttonStyle = ButtonStyle(
  padding: WidgetStateProperty.all<EdgeInsets>(
    const EdgeInsets.all(16),
  ),
  shape: WidgetStateProperty.all(Shapes.bigShape),
);

InputDecorationTheme _buildInputDecorationTheme(ColorScheme colorScheme) =>
    InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: Shapes.bigShape.borderRadius as BorderRadius,
        borderSide: BorderSide.none,
      ),
      fillColor: colorScheme.secondary,
      filled: true,
    );

ThemeData buildTheme(ColorScheme colorScheme) => ThemeData.from(
      colorScheme: colorScheme,
      textTheme: _textTheme,
      useMaterial3: true,
    ).copyWith(
      dividerTheme:
          const DividerThemeData(color: Color.fromRGBO(150, 162, 168, 0.12)),
      appBarTheme: const AppBarTheme().copyWith(centerTitle: true),
      scaffoldBackgroundColor: colorScheme.surface,
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.all(colorScheme.primary),
      ),

      filledButtonTheme: FilledButtonThemeData(style: _buttonStyle),
      elevatedButtonTheme: ElevatedButtonThemeData(style: _buttonStyle),
      outlinedButtonTheme: OutlinedButtonThemeData(style: _buttonStyle),
      textButtonTheme: TextButtonThemeData(style: _buttonStyle),
      inputDecorationTheme: _buildInputDecorationTheme(colorScheme),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colorScheme.primary,
        selectionColor: colorScheme.primary.withOpacity(0.5),
        selectionHandleColor: colorScheme.primary,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.surface,
        shape: Shapes.smallShape,
        // elevation: 8,
        behavior: SnackBarBehavior.floating,
      ),
      // extensions: [
      //   ButtonThemeExtensions(
      //     filled: ElevatedButton.styleFrom(
      //             foregroundColor: colorScheme.onPrimary,
      //             backgroundColor: colorScheme.primary,
      //             textStyle: _textTheme.titleMedium)
      //         .copyWith(
      //       elevation: ButtonStyleButton.allOrNull(0.0),
      //     ),
      //     tonal: ElevatedButton.styleFrom(
      //             foregroundColor: colorScheme.onSecondaryContainer,
      //             backgroundColor: colorScheme.secondaryContainer,
      //             textStyle: _textTheme.titleMedium)
      //         .copyWith(
      //       elevation: ButtonStyleButton.allOrNull(0.0),
      //     ),
      //   )
      // ],
    );

final authTheme = buildTheme(_authColorScheme).copyWith(
  inputDecorationTheme: _buildInputDecorationTheme(_authColorScheme).copyWith(
    labelStyle: _textTheme.bodyMedium,
    border: const OutlineInputBorder(),
    filled: false,
  ),
);
