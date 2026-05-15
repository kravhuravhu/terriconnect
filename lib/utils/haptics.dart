import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class Haptics {
  // Light impact (for taps, card selections)
  static void light() {
    HapticFeedback.lightImpact();
  }
  
  // Medium impact (for confirmations, button presses)
  static void medium() {
    HapticFeedback.mediumImpact();
  }
  
  // Heavy impact (for major actions, celebrations)
  static void heavy() {
    HapticFeedback.heavyImpact();
  }
  
  // Selection click (for picking options)
  static void selection() {
    HapticFeedback.selectionClick();
  }
  
  // Success vibration pattern (custom)
  static void success() {
    HapticFeedback.lightImpact();
    Future.delayed(const Duration(milliseconds: 50), () {
      HapticFeedback.lightImpact();
    });
  }
  
  // Error vibration (for warnings)
  static void error() {
    HapticFeedback.heavyImpact();
  }
}