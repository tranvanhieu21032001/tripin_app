import 'package:flutter/material.dart';
import 'package:wemu_team_app/core/configs/theme/app_colors.dart';
import 'package:wemu_team_app/core/utils/date_helper.dart';

class BubbleRight extends StatelessWidget {
  final String text;
  final DateTime timestamp;
  final String? messageType;

  const BubbleRight({
    super.key,
    required this.text,
    required this.timestamp,
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
            // print('Image URL: ${_getImageUrl()}');
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
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
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
                        : AppColors.blue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: _isImageMessage()
                      ? _buildImageWidget()
                      : Text(
                          text,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, right: 4),
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

