import 'package:flutter/material.dart';
import 'package:swipemovie/widgets/common/primary_button.dart';

typedef OnItemTap = void Function(String label, bool selected);

class SelectableGrid extends StatefulWidget {
  final String title;
  final List<Map<String, String>> items; // each item has 'label' & 'imageUrl'
  final Set<String> selectedItems;
  final OnItemTap onItemTap;
  final VoidCallback onNext;
  final bool isLoading;

  const SelectableGrid({
    super.key,
    required this.title,
    required this.items,
    required this.selectedItems,
    required this.onItemTap,
    required this.onNext,
    this.isLoading = false,
  });

  @override
  State<SelectableGrid> createState() => _SelectableGridState();
}

class _SelectableGridState extends State<SelectableGrid> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: GridView.builder(
            itemCount: widget.items.length,
            padding: const EdgeInsets.only(bottom: 100),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              final item = widget.items[index];
              final label = item['label']!;
              final imageUrl = item['imageUrl']!;
              final selected = widget.selectedItems.contains(label);

              return _InterestCard(
                key: ValueKey(label),
                label: label,
                imageUrl: imageUrl,
                selected: selected,
                onTap: () {
                  widget.onItemTap(label, selected);
                  setState(() {}); // to refresh card selection
                },
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        PrimaryButton(
          onTap: widget.onNext,
          label: 'Next',
          enabled: widget.selectedItems.isNotEmpty,
          isLoading: widget.isLoading,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _InterestCard extends StatefulWidget {
  final String label;
  final String imageUrl;
  final bool selected;
  final VoidCallback onTap;

  const _InterestCard({
    super.key,
    required this.label,
    required this.imageUrl,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_InterestCard> createState() => _InterestCardState();
}

class _InterestCardState extends State<_InterestCard>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;

  void _handleTapDown(TapDownDetails _) => setState(() => _pressed = true);
  void _handleTapUp(TapUpDetails _) => setState(() => _pressed = false);
  void _handleTapCancel() => setState(() => _pressed = false);

  @override
  Widget build(BuildContext context) {
    final shrinkScale = widget.selected || _pressed ? 0.96 : 1.0;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 300),
        scale: shrinkScale,
        curve: Curves.easeOut,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  widget.imageUrl.startsWith('http')
                      ? Image.network(
                          widget.imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) =>
                              progress == null
                              ? child
                              : const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white24,
                                  ),
                                ),
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.broken_image,
                            color: Colors.white24,
                          ),
                        )
                      : Image.asset(
                          widget.imageUrl,
                          fit: BoxFit.cover,
                          cacheWidth: 300,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.broken_image,
                            color: Colors.white24,
                          ),
                        ),

                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black,
                          Colors.transparent,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Text(
                      widget.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: widget.selected ? 1 : 0,
              curve: Curves.easeInOut,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 4, color: Colors.redAccent),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
