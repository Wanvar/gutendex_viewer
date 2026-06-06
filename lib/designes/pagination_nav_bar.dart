import 'package:flutter/material.dart';

class PaginationNavBar extends StatelessWidget {
  final bool hasPrevious;
  final bool hasNext;
  final bool isLoading;
  final VoidCallback? onPreviousPressed;
  final VoidCallback? onNextPressed;

  const PaginationNavBar({
    super.key,
    required this.hasPrevious,
    required this.hasNext,
    required this.isLoading,
    required this.onPreviousPressed,
    required this.onNextPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, -2),
          )
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              tooltip: "Poprzednia strona",

              onPressed: (isLoading || !hasPrevious) ? null : onPreviousPressed,
            ),


            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isLoading
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.indigo,
                ),
              )
                  : Text(
                "Maksymalnie 32 pozycje",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),


            IconButton(
              icon: const Icon(Icons.arrow_forward_ios_rounded),
              tooltip: "Następna strona",
              onPressed: (isLoading || !hasNext) ? null : onNextPressed,
            ),
          ],
        ),
      ),
    );
  }
}