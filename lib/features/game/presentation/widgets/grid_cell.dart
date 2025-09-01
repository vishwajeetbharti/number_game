import 'package:flutter/material.dart';
import '../../domain/entities.dart';

class GridCellWidget extends StatefulWidget {
  final Cell cell;
  final VoidCallback onTap;

  const GridCellWidget({super.key, required this.cell, required this.onTap});

  @override
  State<GridCellWidget> createState() => _GridCellWidgetState();
}

class _GridCellWidgetState extends State<GridCellWidget> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final c = widget.cell;
    final bool isEmpty = c.value == null;
    final bg = switch ((c.matched, c.selected, c.feedback)) {
      (true, _, _) => Colors.grey.shade300,
      (_, true, _) => Colors.amber.shade100,
      (_, _, CellFeedback.invalid) => Colors.red.shade100,
      (_, _, CellFeedback.valid) => Colors.green.shade100,
      _ => Colors.white,
    };
    final borderColor = c.selected ? Colors.amber : Colors.black12;
    final textStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: c.matched ? Colors.black45 : Colors.black87,
    );
    final BoxBorder border = Border.all(color: borderColor, width: 1.2);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: border,
        boxShadow: c.feedback == CellFeedback.valid
            ? [BoxShadow(blurRadius: 6, spreadRadius: 0, offset: const Offset(0,2), color: Colors.black.withOpacity(0.06))]
            : const [],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: isEmpty ? null : widget.onTap,
        child: Center(
          child: isEmpty
              ? const SizedBox.shrink()
              : AnimatedOpacity(
            duration: const Duration(milliseconds: 160),
            opacity: c.matched ? 0.45 : 1.0,
            child: Text('${c.value}', style: textStyle),
          ),
        ),
      ),
    );
  }
}
