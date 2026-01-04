import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:weave_the_border/core/constants/app_colors.dart';

class DecisionDialog extends StatelessWidget {
  final String title;
  final String content;
  final String cancelLabel;
  final String confirmLabel;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;
  final Color? confirmColor;
  final IconData? icon;

  const DecisionDialog({
    super.key,
    required this.title,
    required this.content,
    required this.cancelLabel,
    required this.confirmLabel,
    required this.onCancel,
    required this.onConfirm,
    this.confirmColor,
    this.icon,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required String content,
    String cancelLabel = '戦場に戻る',
    String confirmLabel = '退却する',
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    Color? confirmColor,
    IconData? icon,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withValues(alpha: 0.6),
      pageBuilder: (context, animation, secondaryAnimation) {
        return DecisionDialog(
          title: title,
          content: content,
          cancelLabel: cancelLabel,
          confirmLabel: confirmLabel,
          onCancel: onCancel ?? () => Navigator.of(context).pop(),
          onConfirm: onConfirm,
          confirmColor: confirmColor,
          icon: icon,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = AppColors.darkGlassBackground.withValues(
      alpha: 0.85,
    );
    final borderColor = AppColors.goldBorder.withValues(alpha: 0.8);
    final actionColor = confirmColor ?? AppColors.deepRed;

    return Stack(
      children: [
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
        Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: borderColor, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.6),
                    blurRadius: 24,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 32, color: borderColor),
                      const Gap(16),
                    ],

                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Serif',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: Colors.white,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Gap(20),
                    Text(
                      content,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        height: 1.8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Gap(32),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: onCancel,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                color: borderColor.withValues(alpha: 0.5),
                                width: 1,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              cancelLabel,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const Gap(16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: onConfirm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: actionColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              confirmLabel,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
