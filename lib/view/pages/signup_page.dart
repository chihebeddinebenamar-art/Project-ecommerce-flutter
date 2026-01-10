import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../const/constants.dart';
import '../../models/user_profile.dart';
import '../../services/user_service.dart';
import '../widgets/layout/widget_tree.dart';
import '../widgets/backgrounds/particle_background.dart';
import '../widgets/buttons/animated_signup_button.dart';
import '../data/notifiers.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage>
    with TickerProviderStateMixin {
  // Contrôleurs pour les champs
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  Map<String, String> _fieldErrors = {};

  
  late AnimationController _gradientController;
  late AnimationController _fadeController;
  late Animation<double> _gradientAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Contrôleur pour le gradient animé
    _gradientController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    // Contrôleur pour l'animation de fade
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();

    _gradientAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _gradientController,
        curve: Curves.easeInOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _gradientController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le nom est requis';
    }
    if (value.trim().length < 2) {
      return 'Le nom doit contenir au moins 2 caractères';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'L\'email est requis';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Format d\'email invalide';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le téléphone est requis';
    }
    final phoneRegex = RegExp(r'^[0-9+\-\s()]{8,}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Format de téléphone invalide';
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'L\'adresse est requise';
    }
    if (value.trim().length < 5) {
      return 'L\'adresse doit contenir au moins 5 caractères';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis';
    }
    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La confirmation du mot de passe est requise';
    }
    if (value != _passwordController.text) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }

  Future<void> _submit() async {
    // Réinitialiser les erreurs
    setState(() {
      _fieldErrors = {};
    });

    // Valider tous les champs
    final nameError = _validateName(_nameController.text);
    final emailError = _validateEmail(_emailController.text);
    final phoneError = _validatePhone(_phoneController.text);
    final addressError = _validateAddress(_addressController.text);
    final passwordError = _validatePassword(_passwordController.text);
    final confirmPasswordError = _validateConfirmPassword(_confirmPasswordController.text);

    if (nameError != null) _fieldErrors['name'] = nameError;
    if (emailError != null) _fieldErrors['email'] = emailError;
    if (phoneError != null) _fieldErrors['phone'] = phoneError;
    if (addressError != null) _fieldErrors['address'] = addressError;
    if (passwordError != null) _fieldErrors['password'] = passwordError;
    if (confirmPasswordError != null) _fieldErrors['confirmPassword'] = confirmPasswordError;

    if (_fieldErrors.isNotEmpty) {
      setState(() {});
      _showError('Veuillez corriger les erreurs dans le formulaire');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Sauvegarder le profil utilisateur
      if (userCredential.user != null) {
        final userService = UserService();
        final profile = UserProfile(
          uid: userCredential.user!.uid,
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
          address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
        );
        await userService.saveUserProfile(profile);
      }

      if (!mounted) return;
      // S'assurer que l'index est à 0 (Home) après l'inscription
      selectedIndexNotifier.value = 0;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const WidgetTree()),
      );
    } on FirebaseAuthException catch (e) {
      _showError(_friendlyMessage(e));
    } catch (e) {
      _showError('Une erreur est survenue. Réessayez.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _friendlyMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Cet email est déjà utilisé.';
      case 'weak-password':
        return 'Le mot de passe est trop faible (min 6 caractères).';
      case 'invalid-email':
        return 'Format d\'email invalide.';
      default:
        return 'Erreur : ${e.message ?? e.code}';
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? fieldKey,
    Widget? suffixIcon,
  }) {
    final hasError = fieldKey != null && _fieldErrors.containsKey(fieldKey);
    final errorMessage = fieldKey != null ? _fieldErrors[fieldKey] : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: hasError
                    ? Colors.red.withValues(alpha: 0.1)
                    : AppColors.primaryColor.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            validator: validator,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              prefixIcon: Icon(icon, color: AppColors.primaryColor),
              suffixIcon: suffixIcon,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: hasError ? Colors.red : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: hasError ? Colors.red : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: hasError ? Colors.red : AppColors.primaryColor,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
            ),
            onChanged: (value) {
              if (fieldKey != null && _fieldErrors.containsKey(fieldKey)) {
                setState(() {
                  _fieldErrors.remove(fieldKey);
                });
              }
            },
          ),
        ),
        if (errorMessage != null) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Row(
              children: [
                Icon(Icons.error_outline, size: 16, color: Colors.red),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    errorMessage,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _gradientAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(
                    AppColors.backgroundGradient.colors[0],
                    AppColors.backgroundGradientAlt.colors[0],
                    _gradientAnimation.value,
                  )!,
                  Color.lerp(
                    AppColors.backgroundGradient.colors[1],
                    AppColors.backgroundGradientAlt.colors[1],
                    _gradientAnimation.value,
                  )!,
                  Color.lerp(
                    AppColors.backgroundGradient.colors[2],
                    AppColors.backgroundGradientAlt.colors[2],
                    _gradientAnimation.value,
                  )!,
                  Color.lerp(
                    AppColors.backgroundGradient.colors[3],
                    AppColors.backgroundGradientAlt.colors[3],
                    _gradientAnimation.value,
                  )!,
                ],
                stops: const [0.0, 0.3, 0.6, 1.0],
              ),
            ),
            child: ParticleBackground(
              particleCount: 10,
              child: SafeArea(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 20),
                            // Logo et titre
                            Center(
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: AppColors.primaryGradient,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primaryColor.withValues(alpha: 0.3),
                                          blurRadius: 20,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.person_add,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  ShaderMask(
                                    shaderCallback: (bounds) => LinearGradient(
                                      colors: [
                                        AppColors.textPrimary,
                                        AppColors.textAccent,
                                      ],
                                    ).createShader(bounds),
                                    child: const Text(
                                      'Inscription',
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Créez votre compte',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 40),
                            // Champs du formulaire
                            _buildTextField(
                              controller: _nameController,
                              label: 'Nom complet',
                              hint: 'Entrez votre nom complet',
                              icon: Icons.person,
                              validator: _validateName,
                              fieldKey: 'name',
                            ),
                            _buildTextField(
                              controller: _emailController,
                              label: 'Email',
                              hint: 'Entrez votre email',
                              icon: Icons.email,
                              validator: _validateEmail,
                              keyboardType: TextInputType.emailAddress,
                              fieldKey: 'email',
                            ),
                            _buildTextField(
                              controller: _phoneController,
                              label: 'Téléphone',
                              hint: 'Entrez votre numéro de téléphone',
                              icon: Icons.phone,
                              validator: _validatePhone,
                              keyboardType: TextInputType.phone,
                              fieldKey: 'phone',
                            ),
                            _buildTextField(
                              controller: _addressController,
                              label: 'Adresse',
                              hint: 'Entrez votre adresse',
                              icon: Icons.location_on,
                              validator: _validateAddress,
                              fieldKey: 'address',
                            ),
                            _buildTextField(
                              controller: _passwordController,
                              label: 'Mot de passe',
                              hint: 'Entrez votre mot de passe',
                              icon: Icons.lock,
                              validator: _validatePassword,
                              obscureText: _obscurePassword,
                              fieldKey: 'password',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.primaryColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            _buildTextField(
                              controller: _confirmPasswordController,
                              label: 'Confirmer le mot de passe',
                              hint: 'Confirmez votre mot de passe',
                              icon: Icons.lock_outline,
                              validator: _validateConfirmPassword,
                              obscureText: _obscureConfirmPassword,
                              fieldKey: 'confirmPassword',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.primaryColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword = !_obscureConfirmPassword;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Bouton d'inscription
                            AnimatedSignupButton(
                              onTap: _submit,
                              isLoading: _isLoading,
                            ),
                            const SizedBox(height: 20),
                            // Lien vers login
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Vous avez déjà un compte ? ',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Text(
                                    'Connectez-vous',
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          );
        },
      ),
    );
  }
}

