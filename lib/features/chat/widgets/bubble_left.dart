import 'package:flutter/material.dart';
import 'package:wemu_team_app/core/configs/theme/app_colors.dart';
import 'package:wemu_team_app/core/utils/date_helper.dart';

class BubbleLeft extends StatelessWidget {
  final String text;
  final String senderName;
  final DateTime timestamp;
  final String? avatarUrl;
  final String? messageType;

  const BubbleLeft({
    super.key,
    required this.text,
    required this.senderName,
    required this.timestamp,
    this.avatarUrl,
    this.messageType,
  });

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'pm' : 'am';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  bool _isImageMessage() {
    if (messageType == null) return false;
    return messageType!.toLowerCase() == 'image';
  }

  String _getImageUrl() {
    if (text.startsWith('http://') || text.startsWith('https://')) {
      return text;
    }
    
    if (!text.contains('/')) {
      return 'https://api-prod.wemu.co/photos/$text';
    }
    
    if (text.startsWith('/')) {
      return 'https://api-prod.wemu.co$text';
    }
    
    return 'https://discovery-api-prod.wemu.co/photos/$text';
  }

  Widget _buildImageWidget() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: GestureDetector(
        onTap: () {
        },
        child: Image.network(
          _getImageUrl(),
          width: 250,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: 250,
              height: 200,
              color: AppColors.lightGrey,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            // print('Image load error: $error');
            return Container(
              width: 250,
              height: 200,
              color: AppColors.lightGrey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.broken_image,
                    color: AppColors.grey,
                    size: 48,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Failed to load image',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.lightGrey,
            backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
            child: avatarUrl == null
                ? Text(
                    senderName[0].toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 4, top: 2),
                  child: Text(
                    senderName,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  constraints: const BoxConstraints(maxWidth: 250),
                  padding: _isImageMessage() 
                      ? EdgeInsets.zero 
                      : const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                  decoration: BoxDecoration(
                    color: _isImageMessage() 
                        ? Colors.transparent 
                        : const Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: _isImageMessage()
                      ? _buildImageWidget()
                      : Text(
                          text,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.black,
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 4),
                  child: Text(
                    DateHelper.formatChatTimestamp(timestamp),
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

