import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseImagesListScreen extends StatefulWidget {
  const SupabaseImagesListScreen({super.key});

  @override
  State<SupabaseImagesListScreen> createState() =>
      _SupabaseImagesListScreenState();
}

class _SupabaseImagesListScreenState
    extends State<SupabaseImagesListScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;

  bool _isLoading = true;
  String? _errorMessage;

  List<FileObject> _images = [];

  @override
  void initState() {
    super.initState();
    _listImages();
  }

  Future<void> _listImages() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final files = await _supabase.storage
          .from('images')
          .list(
            path: 'cards',
            searchOptions: const SearchOptions(
              limit: 100,
              offset: 0,
              sortBy: SortBy(
                column: 'name',
                order: 'asc',
              ),
            ),
          );

      for (final file in files) {
        debugPrint('Nombre: ${file.name}');
        debugPrint('Ruta completa: cards/${file.name}');
        debugPrint('ID: ${file.id}');
        debugPrint('Fecha creación: ${file.createdAt}');
        debugPrint('Fecha actualización: ${file.updatedAt}');
        debugPrint('Metadata: ${file.metadata}');
        debugPrint('--------------------------------------');
      }

      if (!mounted) return;

      setState(() {
        _images = files;
        _isLoading = false;
      });
    } on StorageException catch (error) {
      debugPrint(
        'Error de Supabase Storage: '
        '${error.message} - ${error.statusCode}',
      );

      if (!mounted) return;

      setState(() {
        _errorMessage =
            'Error de Supabase Storage: ${error.message}';
        _isLoading = false;
      });
    } catch (error, stackTrace) {
      debugPrint('Error inesperado: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        _errorMessage = 'Error inesperado: $error';
        _isLoading = false;
      });
    }
  }

  Future<String?> _getSignedUrl(String fileName) async {
    try {
      final path = 'cards/$fileName';

      final signedUrl = await _supabase.storage
          .from('images')
          .createSignedUrl(
            path,
            60 * 60,
          );

      return signedUrl;
    } on StorageException catch (error) {
      debugPrint(
        'No se pudo obtener URL para $fileName: '
        '${error.message}',
      );

      return null;
    } catch (error) {
      debugPrint(
        'Error inesperado obteniendo URL de $fileName: $error',
      );

      return null;
    }
  }

  Future<void> _printAllSignedUrls() async {
    if (_images.isEmpty) {
      debugPrint('No hay imágenes para generar URLs.');
      return;
    }

    for (final image in _images) {
      final signedUrl = await _getSignedUrl(image.name);

      debugPrint('Archivo: cards/${image.name}');
      debugPrint('URL firmada: $signedUrl');
      debugPrint('--------------------------------------');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Imágenes de Supabase'),
        actions: [
          IconButton(
            onPressed: _listImages,
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _printAllSignedUrls,
        icon: const Icon(Icons.link),
        label: const Text('Mostrar URLs'),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _listImages,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (_images.isEmpty) {
      return const Center(
        child: Text(
          'No se encontraron imágenes en images/cards.',
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _images.length,
      separatorBuilder: (_, __) =>
          const Divider(height: 1),
      itemBuilder: (context, index) {
        final image = _images[index];
        final fullPath = 'cards/${image.name}';

        return ListTile(
          leading: const Icon(Icons.image_outlined),
          title: Text(image.name),
          subtitle: Text(fullPath),
          trailing: IconButton(
            icon: const Icon(Icons.link),
            onPressed: () async {
              final signedUrl =
                  await _getSignedUrl(image.name);

              debugPrint('Archivo: $fullPath');
              debugPrint('URL firmada: $signedUrl');

              if (!context.mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    signedUrl == null
                        ? 'No se pudo generar la URL'
                        : 'URL mostrada en consola',
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}