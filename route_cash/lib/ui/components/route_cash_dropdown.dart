import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RouteCashDropdown<T> extends StatelessWidget {
  const RouteCashDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    this.displayMember,
    required this.onChanged,
    this.enabled = true,
  });

  final String label;
  final T? value;
  final List<T> items;
  final String? displayMember;
  final void Function(T?)? onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final bool isActuallyEnabled = enabled && items.isNotEmpty;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: const Color(0xFF999999),
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: isActuallyEnabled ? () => _showPicker(context) : null,
          child: Opacity(
            opacity: isActuallyEnabled ? 1.0 : 0.5,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE0E0E0)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      items.isEmpty ? "Cargando..." : _getDisplayText(value),
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: value != null ? Colors.black : const Color(0xFF9B9B9B),
                      ),
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down, size: 20, color: Color(0xFF999999)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getDisplayText(T? val) {
    if (val == null) return "Seleccionar...";
    if (displayMember != null && val is Map) {
      return val[displayMember] ?? "";
    }
    return val.toString();
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                label,
                style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      title: Text(_getDisplayText(item), textAlign: TextAlign.center),
                      onTap: () {
                        onChanged?.call(item);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
