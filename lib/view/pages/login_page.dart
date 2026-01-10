import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../const/constants.dart';
import '../widgets/layout/widget_tree.dart';
import '../widgets/backgrounds/particle_background.dart';
import '../data/notifiers.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  
  
  late AnimationController _gradientController;
  late AnimationController _fadeController;
  late Animation<double> _gradientAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _gradientController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

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
    _emailController.dispose();
    _passwordController.dispose();
    _gradientController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError('Email et mot de passe sont requis.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (!mounted) return;
      
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
      case 'user-not-found':
        return 'Aucun utilisateur trouvé pour cet email.';
      case 'wrong-password':
        return 'Mot de passe incorrect.';
      case 'email-already-in-use':
        return 'Cet email est déjà utilisé.';
      case 'weak-password':
        return 'Mot de passe trop faible (min 6 caractères).';
      case 'invalid-email':
        return 'Email invalide.';
      default:
        return 'Erreur : ${e.message ?? e.code}';
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          padding: const EdgeInsets.all(24.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight - 48,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                          const SizedBox(height: 40),
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
                                    Icons.login,
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
                                    'Connexion',
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
                                  'Connectez-vous à votre compte',
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
                          // Champs
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryColor.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.textPrimary,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Email',
                                hintText: 'Entrez votre email',
                                prefixIcon: const Icon(Icons.email, color: AppColors.primaryColor),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryColor.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.textPrimary,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Mot de passe',
                                hintText: 'Entrez votre mot de passe',
                                prefixIcon: const Icon(Icons.lock, color: AppColors.primaryColor),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                    color: AppColors.primaryColor,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          // Bouton Login
                          Container(
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryColor.withValues(alpha: 0.4),
                                  blurRadius: 25,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _isLoading ? null : _submit,
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        )
                                      : const Text(
                                          'Se connecter',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Lien vers signup
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Pas de compte ? ',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SignupPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Inscrivez-vous',
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
                        );
                      },
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
