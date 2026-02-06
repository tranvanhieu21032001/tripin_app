import 'package:flutter/material.dart';
import 'package:wemu_team_app/core/configs/assets/app_vector.dart';
import 'package:wemu_team_app/core/configs/theme/app_colors.dart';

/// Dùng chung cho cả "On going" (TripsPage) và post list (ProfilePage)
class TripCard extends StatelessWidget {
  const TripCard({
    super.key,
    required this.imageAsset,
    required this.title,
    this.subtitle,
    this.timeAgo,
    this.showOverlay = false,
    this.category,
    this.address,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
  });

  final String imageAsset;
  final String title;
  final String? subtitle;
  final String? timeAgo;
  final bool showOverlay;
  final String? category;
  final String? address;
  final VoidCallback? onTap;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageHeight = (screenWidth - padding.horizontal) * 9 / 16;

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onTap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: imageHeight,
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(imageAsset, fit: BoxFit.cover),
                    ),
                    if (showOverlay) ...[
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.05),
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (category != null)
                              Text(
                                category!,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white70,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            const SizedBox(height: 4),
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (address != null)
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 14,
                                    color: Colors.white70,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      address!,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.white70,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          if (!showOverlay) ...[
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
              ),
            ],
            if (timeAgo != null) ...[
              const SizedBox(height: 4),
              Text(
                timeAgo!,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.black.withOpacity(0.5),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

/// Dùng cho upcoming/Public list (ảnh nhỏ bên trái, text bên phải)
class CompactTripCard extends StatelessWidget {
  const CompactTripCard({
    super.key,
    required this.imageAsset,
    required this.title,
    required this.subtitle,
    this.description,
    this.onTap,
    this.imageWidth = 140,
    this.imageHeight = 100,
  });

  final String imageAsset;
  final String title;
  final String subtitle;
  final String? description;
  final VoidCallback? onTap;
  final double imageWidth;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              imageAsset,
              width: imageWidth,
              height: imageHeight,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                if (description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
