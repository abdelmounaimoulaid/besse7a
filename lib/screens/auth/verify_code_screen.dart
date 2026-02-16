import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/providers/auth_provider.dart';
import 'package:mobile_app/screens/auth/reset_password_screen.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String email;

  const VerifyCodeScreen({super.key, required this.email});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  bool _isLoading = false;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onDigitChanged(String value, int index) {
      if (value.length > 1) {
          // This case is handled in the onChanged callback of the TextField
          return;
      }
      if (value.isNotEmpty) {
      // Move to next field
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // Last digit entered, hide keyboard
        _focusNodes[index].unfocus();
        _verifyCode();
      }
    } else {
      // Move to previous field on backspace
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
  }
  
  String get _code => _controllers.map((c) => c.text).join();

  Future<void> _verifyCode() async {
    final code = _code;
    if (code.length != 6) return;

    setState(() => _isLoading = true);
    final l10n = AppLocalizations.of(context);
    
    try {
      final success = await Provider.of<AuthProvider>(context, listen: false).verifyCode(
        widget.email,
        code,
        locale: l10n.locale.languageCode,
      );

      if (mounted) {
        setState(() => _isLoading = false);
        if (success) {
           Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ResetPasswordScreen(email: widget.email, token: code),
            ),
          );
        } else {
           ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(Provider.of<AuthProvider>(context, listen: false).errorMessage ?? l10n.invalidCode),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _resendCode() async {
     final l10n = AppLocalizations.of(context);
     setState(() => _isLoading = true);
     try {
       await Provider.of<AuthProvider>(context, listen: false).resetPassword(
         widget.email,
         locale: l10n.locale.languageCode
       );
       if (mounted) {
         setState(() => _isLoading = false);
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(l10n.translate('reset_link_sent'))),
         );
       }
     } catch (e) {
       setState(() => _isLoading = false);
     }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.verifyCode)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.enter6Digit,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
             const SizedBox(height: 8),
            Text(
              widget.email,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 45,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      // maxLength: 1, // Removed to allow pasting
                      onChanged: (value) {
                         if (value.length > 1) {
                           // Handle paste case
                            final pasted = value.substring(0, 6); // Take up to 6 chars
                            for (int i = 0; i < pasted.length && i < 6; i++) {
                              _controllers[i].text = pasted[i];
                            }
                            // Focus the field after the last filled one
                            int nextFocus = pasted.length < 6 ? pasted.length : 5;
                            _focusNodes[nextFocus].requestFocus();
                            if (pasted.length == 6) {
                               _verifyCode();
                            }
                         } else {
                           _onDigitChanged(value, index);
                         }
                      },
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isLoading ? null : _verifyCode,
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF059669),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isLoading 
                ? const CircularProgressIndicator(color: Colors.white) 
                : Text(l10n.verify, style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
             const SizedBox(height: 16),
            TextButton(
              onPressed: _isLoading ? null : _resendCode,
              child: Text(l10n.resendCode),
            ),
          ],
        ),
      ),
    );
  }
}
