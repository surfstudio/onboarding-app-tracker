import 'package:flutter/widgets.dart';
import 'package:time_tracker/ui/res/app_colors.dart';

const defaultFontFamily = 'Roboto';

class AppTypography {
  static const screenTitle = TextStyle(
    color: AppColors.screenTitle,
    fontWeight: FontWeight.bold,
  );

  static const cardTitle = TextStyle(
    color: AppColors.cardTitle,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    overflow: TextOverflow.ellipsis,
  );

  static const cardStatus = TextStyle(
    color: AppColors.white,
    fontSize: 14,
    overflow: TextOverflow.ellipsis,
  );

  static const cardStatusInProgress = TextStyle(
    color: AppColors.cardStatus,
    fontSize: 14,
    overflow: TextOverflow.ellipsis,
  );

  static const largeTitle = TextStyle(
    color: AppColors.typographyPrimary,
    fontWeight: FontWeight.w700,
    fontSize: 52,
    height: 60 / 52,
    fontFamily: defaultFontFamily,
  );

  static const title1 = TextStyle(
    color: AppColors.typographyPrimary,
    fontWeight: FontWeight.w700,
    fontSize: 32,
    height: 40 / 32,
    fontFamily: defaultFontFamily,
  );

  static const title2 = TextStyle(
    color: AppColors.typographyPrimary,
    fontWeight: FontWeight.w700,
    fontSize: 24,
    height: 32 / 24,
    fontFamily: defaultFontFamily,
  );

  static const title3 = TextStyle(
    color: AppColors.typographyPrimary,
    fontWeight: FontWeight.w700,
    fontSize: 18,
    height: 24 / 18,
    fontFamily: defaultFontFamily,
  );

  static const headline = TextStyle(
    color: AppColors.typographyPrimary,
    fontWeight: FontWeight.w700,
    fontSize: 16,
    height: 24 / 16,
    fontFamily: defaultFontFamily,
  );

  static const subHeadline1 = TextStyle(
    color: AppColors.typographyPrimary,
    fontWeight: FontWeight.w700,
    fontSize: 15,
    height: 20 / 14,
    fontFamily: defaultFontFamily,
  );

  static const subHeadline2 = TextStyle(
    color: AppColors.typographyPrimary,
    fontWeight: FontWeight.w700,
    fontSize: 14,
    height: 20 / 14,
    fontFamily: defaultFontFamily,
  );

  static const body = TextStyle(
    color: AppColors.typographyPrimary,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 24 / 16,
    fontFamily: defaultFontFamily,
  );

  static const body2 = TextStyle(
    color: AppColors.typographyPrimary,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 20 / 14,
    fontFamily: defaultFontFamily,
  );

  static const invisibleTextStyle =
      TextStyle(color: Color(0x00000000), fontSize: 0);
}
