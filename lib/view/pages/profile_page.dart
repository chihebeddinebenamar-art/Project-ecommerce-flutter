import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../const/constants.dart';
import '../../models/user_profile.dart';
import '../../services/user_service.dart';
import 'welcome_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserService _userService = UserService();
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  
  UserProfile? _userProfile;
  bool _isLoading = true;
  bool _isEditing = false;
  bool _isSaving = false;
  Map<String, String> _fieldErrors = {};

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() => _isLoading = true);
    try {
      final profile = await _userService.getCurrentUserProfile();
      if (profile != null) {
        setState(() {
          _userProfile = profile;
          _nameController.text = profile.name;
          _emailController.text = profile.email;
          _phoneController.text = profile.phone ?? '';
          _addressController.text = profile.address ?? '';
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors du chargement du profil: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
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
    if (value != null && value.trim().isNotEmpty) {
      final phoneRegex = RegExp(r'^[0-9+\-\s()]{8,}$');
      if (!phoneRegex.hasMatch(value.trim())) {
        return 'Format de téléphone invalide';
      }
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value != null && value.trim().isNotEmpty && value.trim().length < 5) {
      return 'L\'adresse doit contenir au moins 5 caractères';
    }
    return null;
  }

  Future<void> _saveProfile() async {
    setState(() {
      _fieldErrors = {};
    });

    final nameError = _validateName(_nameController.text);
    final emailError = _validateEmail(_emailController.text);
    final phoneError = _validatePhone(_phoneController.text);
    final addressError = _validateAddress(_addressController.text);

    if (nameError != null) _fieldErrors['name'] = nameError;
    if (emailError != null) _fieldErrors['email'] = emailError;
    if (phoneError != null) _fieldErrors['phone'] = phoneError;
    if (addressError != null) _fieldErrors['address'] = addressError;

    if (_fieldErrors.isNotEmpty) {
      setState(() {});
      _showError('Veuillez corriger les erreurs dans le formulaire');
      return;
    }

    if (_userProfile == null) return;

    setState(() => _isSaving = true);

    try {
      final updatedProfile = UserProfile(
        uid: _userProfile!.uid,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
        address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
      );

      await _userService.updateUserProfile(updatedProfile);
      
      if (mounted) {
        setState(() {
          _userProfile = updatedProfile;
          _isEditing = false;
          _isSaving = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil mis à jour avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        _showError('Erreur lors de la mise à jour: $e');
      }
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Déconnexion', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const WelcomePage()),
          (route) => false,
        );
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
    String? fieldKey,
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
            enabled: enabled && _isEditing,
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
                const Icon(Icons.error_outline, size: 16, color: Colors.red),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(
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
      backgroundColor: Colors.grey.shade50,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userProfile == null
              ? Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text('Erreur lors du chargement du profil'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadUserProfile,
                          child: const Text('Réessayer'),
                        ),
                      ],
                    ),
                )
              : CustomScrollView(
                  slivers: [
                    // AppBar personnalisé
                    SliverAppBar(
                      expandedHeight: 200,
                      pinned: true,
                      backgroundColor: Colors.white,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                          ),
                          child: SafeArea(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 30),
                                Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 4,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    size: 55,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Text(
                                      _userProfile!.name,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Text(
                                      _userProfile!.email,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.white.withValues(alpha: 0.9),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Contenu
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // En-tête avec bouton modifier
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      'Informations personnelles',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (!_isEditing)
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          _isEditing = true;
                                          _fieldErrors = {};
                                        });
                                      },
                                      icon: const Icon(Icons.edit, size: 16),
                                      label: const Text('Modifier', style: TextStyle(fontSize: 12)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primaryColor,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      ),
                                    )
                                  else
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextButton(
                                          onPressed: _isSaving
                                              ? null
                                              : () {
                                                  setState(() {
                                                    _isEditing = false;
                                                    _fieldErrors = {};
                                                    // Restaurer les valeurs originales
                                                    _nameController.text = _userProfile!.name;
                                                    _emailController.text = _userProfile!.email;
                                                    _phoneController.text = _userProfile!.phone ?? '';
                                                    _addressController.text = _userProfile!.address ?? '';
                                                  });
                                                },
                                          child: const Text('Annuler'),
                                        ),
                                        const SizedBox(width: 6),
                                        ElevatedButton.icon(
                                          onPressed: _isSaving ? null : _saveProfile,
                                          icon: _isSaving
                                              ? const SizedBox(
                                                  width: 16,
                                                  height: 16,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                  ),
                                                )
                                              : const Icon(Icons.save, size: 18),
                                          label: Text(_isSaving ? 'Sauvegarde...' : 'Sauvegarder'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.primaryColor,
                                            foregroundColor: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                              const SizedBox(height: 30),
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
                                hint: 'Entrez votre numéro de téléphone (optionnel)',
                                icon: Icons.phone,
                                validator: _validatePhone,
                                keyboardType: TextInputType.phone,
                                fieldKey: 'phone',
                              ),
                              _buildTextField(
                                controller: _addressController,
                                label: 'Adresse',
                                hint: 'Entrez votre adresse (optionnel)',
                                icon: Icons.location_on,
                                validator: _validateAddress,
                                fieldKey: 'address',
                              ),
                              const SizedBox(height: 30),
                              // Bouton de déconnexion
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: OutlinedButton.icon(
                                  onPressed: _logout,
                                  icon: const Icon(Icons.logout),
                                  label: const Text(
                                    'Déconnexion',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red,
                                    side: const BorderSide(color: Colors.red, width: 2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}

