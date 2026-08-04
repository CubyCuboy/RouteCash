import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../l10n/app_localizations.dart';
import '../../viewmodels/settings_view_model.dart';
import '../components/route_cash_buttons.dart';
import '../components/route_cash_inputs.dart';
import '../components/route_cash_dropdown.dart';

class EditProfileScreen extends StatefulWidget {
  final SettingsViewModel viewModel;
  const EditProfileScreen({super.key, required this.viewModel});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _nicknameController;
  late final TextEditingController _phoneController;
  Map<String, dynamic>? _selectedCountry;
  Map<String, dynamic>? _selectedState;
  Map<String, dynamic>? _selectedCurrency;
  
  File? _imageFile;
  bool _isSaving = false;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final profile = widget.viewModel.userProfile;
    _nameController = TextEditingController(text: profile?['full_name']?.toString() ?? '');
    _nicknameController = TextEditingController(text: profile?['nickname']?.toString() ?? '');
    _phoneController = TextEditingController(text: profile?['phone']?.toString() ?? '');
    
    _initializeSelections();
  }

  void _initializeSelections() {
    final profile = widget.viewModel.userProfile;
    if (widget.viewModel.countries.isNotEmpty && profile?['states'] != null) {
      final dynamic statesData = profile!['states'];
      Map<String, dynamic>? stateMap;
      
      if (statesData is List && statesData.isNotEmpty) {
        stateMap = Map<String, dynamic>.from(statesData.first);
      } else if (statesData is Map) {
        stateMap = Map<String, dynamic>.from(statesData);
      }

      if (stateMap != null && stateMap['countries'] != null) {
        final dynamic countryData = stateMap['countries'];
        Map<String, dynamic>? countryMap;
        
        if (countryData is List && countryData.isNotEmpty) {
          countryMap = Map<String, dynamic>.from(countryData.first);
        } else if (countryData is Map) {
          countryMap = Map<String, dynamic>.from(countryData);
        }

        if (countryMap != null) {
          final countryId = countryMap['country_id'];
          _selectedCountry = widget.viewModel.countries.firstWhere(
            (c) => c['country_id'] == countryId, 
            orElse: () => widget.viewModel.countries.first
          );
        }
      }
    }
    
    if (widget.viewModel.states.isNotEmpty && profile?['state_id'] != null) {
      _selectedState = widget.viewModel.states.firstWhere(
        (s) => s['state_id'] == profile!['state_id'], 
        orElse: () => widget.viewModel.states.first
      );
    }

    if (widget.viewModel.currencies.isNotEmpty && profile?['default_currency_id'] != null) {
      _selectedCurrency = widget.viewModel.currencies.firstWhere(
        (c) => c['currency_id'] == profile!['default_currency_id'], 
        orElse: () => widget.viewModel.currencies.first
      );
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  Future<String?> _uploadImage(String userId) async {
    if (_imageFile == null) return null;
    
    try {
      final profile = widget.viewModel.userProfile;
      final oldUrl = profile?['profile_image_url']?.toString();
      
      final fileExt = _imageFile!.path.split('.').last;
      final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final filePath = 'profiles/$userId/$fileName';
      
      // Subir con tipo de contenido explícito
      await Supabase.instance.client.storage
          .from('avatars')
          .upload(
            filePath, 
            _imageFile!, 
            fileOptions: const FileOptions(contentType: 'image/jpeg', upsert: true)
          );
      
      final newUrl = Supabase.instance.client.storage
          .from('avatars')
          .getPublicUrl(filePath);

      // Limpieza de imagen anterior para no llenar el storage
      if (oldUrl != null && oldUrl.isNotEmpty && oldUrl.contains('supabase')) {
        try {
          final uri = Uri.parse(oldUrl);
          final pathSegments = uri.pathSegments;
          final avatarsIndex = pathSegments.indexOf('avatars');
          if (avatarsIndex != -1 && avatarsIndex + 1 < pathSegments.length) {
            final oldPath = pathSegments.sublist(avatarsIndex + 1).join('/');
            await Supabase.instance.client.storage.from('avatars').remove([oldPath]);
          }
        } catch (e) {
          debugPrint('Error al eliminar imagen antigua: $e');
        }
      }
      
      return newUrl;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      rethrow;
    }
  }

  void _save() async {
    setState(() => _isSaving = true);
    final strings = AppLocalizations.of(context)!;
    
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      String? imageUrl;
      if (_imageFile != null) {
        imageUrl = await _uploadImage(user.id);
      }

      final err = await widget.viewModel.updateProfile(
        fullName: _nameController.text.trim(),
        nickname: _nicknameController.text.trim(),
        phone: _phoneController.text.trim(),
        stateId: _selectedState?['state_id'] ?? '',
        currencyId: _selectedCurrency?['currency_id'] ?? 0,
        profileImageUrl: imageUrl,
      );

      if (mounted) {
        if (err == null) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Perfil actualizado correctamente')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
        }
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final profile = widget.viewModel.userProfile;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          strings.profileEditTitle.toUpperCase(),
          style: GoogleFonts.inter(
            color: const Color(0xFF9D9D9D),
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.black12,
                    backgroundImage: _imageFile != null 
                        ? FileImage(_imageFile!) as ImageProvider
                        : (profile?['profile_image_url'] != null 
                            ? NetworkImage(profile!['profile_image_url']) 
                            : null),
                    child: (_imageFile == null && profile?['profile_image_url'] == null)
                        ? const Icon(Icons.person, size: 60, color: Colors.white)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            RouteCashTextField(
              label: strings.fullNameLabel,
              controller: _nameController,
              hintText: 'Tu nombre completo',
            ),
            const SizedBox(height: 24),
            RouteCashTextField(
              label: 'APODO / NICKNAME',
              controller: _nicknameController,
              hintText: '@usuario',
            ),
            const SizedBox(height: 24),
            RouteCashTextField(
              label: strings.phoneLabel,
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              hintText: '+1 234 567 890',
            ),
            const SizedBox(height: 24),
            RouteCashDropdown<Map<String, dynamic>>(
              label: strings.countryLabel,
              value: _selectedCountry,
              items: widget.viewModel.countries,
              displayMember: 'name',
              onChanged: (val) {
                setState(() {
                  _selectedCountry = val;
                  _selectedState = null;
                });
                if (val != null) widget.viewModel.loadStates(val['country_id']);
              },
            ),
            const SizedBox(height: 24),
            RouteCashDropdown<Map<String, dynamic>>(
              label: strings.stateLabel,
              value: _selectedState,
              items: widget.viewModel.states,
              displayMember: 'name',
              onChanged: (val) => setState(() => _selectedState = val),
            ),
            const SizedBox(height: 24),
            RouteCashDropdown<Map<String, dynamic>>(
              label: strings.mainCurrencyLabel,
              value: _selectedCurrency,
              items: widget.viewModel.currencies,
              displayMember: 'code',
              onChanged: (val) => setState(() => _selectedCurrency = val),
            ),
            const SizedBox(height: 48),
            RouteCashPrimaryButton(
              text: strings.saveChanges,
              isLoading: _isSaving,
              onPressed: _save,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
