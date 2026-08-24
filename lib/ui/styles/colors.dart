import 'package:flutter/material.dart';
import 'package:newsly/ui/styles/themeExtensions/customColorsExtension.dart';

//Replace these colors according to the UI you are building.
const Color primaryColor = Color(0xffFF6600);
const Color secondaryColor = Color(0xff2B3A55);
const Color errorColor = Color(0xffBA1A1A);

//Light
const Color pageBackgroundColor = Color(0xffF6F7F9);
const Color backgroundColor = Color(0xffFFFFFF);
const Color tertiaryColor = Color(0xffE4E7EC);

//Dark
const Color darkPageBackgroundColor = Color(0xff121417);
const Color darkBackgroundColor = Color(0xff1B1E24);
const Color darkTertiaryColor = Color(0xff2C313A);

const CustomColors lightCustomColors = CustomColors(
  successColor: Color(0xff2E9E5B),
  upvoteColor: Color(0xffFF6600),
  subtitleColor: Color(0xff6B7280),
  dividerColor: Color(0xffE4E7EC),
  shimmerBaseColor: Color(0xffE9ECF1),
  shimmerHighlightColor: Color(0xffF7F9FC),
);

const CustomColors darkCustomColors = CustomColors(
  successColor: Color(0xff4ADE80),
  upvoteColor: Color(0xffFF8534),
  subtitleColor: Color(0xff9CA3AF),
  dividerColor: Color(0xff2C313A),
  shimmerBaseColor: Color(0xff23272F),
  shimmerHighlightColor: Color(0xff2E333C),
);
