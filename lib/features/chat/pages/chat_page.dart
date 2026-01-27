import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wemu_team_app/core/configs/theme/app_colors.dart';
import 'package:wemu_team_app/core/di/injection.dart';
import 'package:wemu_team_app/features/chat/presentation/bloc/chat_cubit.dart';
import 'package:wemu_team_app/features/chat/presentation/bloc/chat_state.dart';
import 'package:wemu_team_app/features/chat/data/models/chat_message.dart' as chat_model;
import 'package:wemu_team_app/features/chat/presentation/bloc/chat_cubit.dart';
import 'package:wemu_team_app/features/chat/presentation/bloc/chat_state.dart';
import 'package:wemu_team_app/features/chat/widgets/bubble_left.dart';
import 'package:wemu_team_app/features/chat/widgets/bubble_right.dart';
import 'package:wemu_team_app/features/login/domain/repositories/auth_repository.dart';
import 'package:wemu_team_app/models/user_profile.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final String reservationId;
  final String taskTitle;
  final int commentsCount;

  const ChatPage({
    super.key,
    required this.reservationId,
    required this.taskTitle,
    required this.commentsCount,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();
  late final ChatCubit _chatCubit;
  UserProfile? _currentUser;

  @override
  void initState() {
    super.initState();
    _chatCubit = getIt<ChatCubit>();
    _currentUser = getIt<AuthRepository>().getCachedUser();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _chatCubit.initialize(widget.reservationId);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _chatCubit.close();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    _chatCubit.sendMessage(_messageController.text.trim());
    _messageController.clear();
    _scrollToBottom();
  }

  Future<void> _pickAndSendImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      
      if (image != null) {
        final file = File(image.path);
        await _chatCubit.sendImage(file);
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  String _formatTimestamp(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy h:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _chatCubit,
      child: BlocListener<ChatCubit, ChatState>(
        listener: (context, state) {
          if (state.status == ChatStatus.success) {
            _scrollToBottom();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.taskTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                BlocBuilder<ChatCubit, ChatState>(
                  builder: (context, state) {
                    return Text(
                      '${state.messages.length} messages',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.grey,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              // Messages List
              Expanded(
                child: BlocBuilder<ChatCubit, ChatState>(
                  builder: (context, state) {
                    if (state.status == ChatStatus.loading && state.messages.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.messages.isEmpty) {
                      return const Center(
                        child: Text(
                          'No messages yet',
                          style: TextStyle(color: AppColors.grey),
                        ),
                      );
                    }

                    final sortedMessages = List.of(state.messages)
                      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: sortedMessages.length,
                      itemBuilder: (context, index) {
                        final message = sortedMessages[index];
                        final currentUserId = _currentUser?.id ?? '';
                        final isMe = message.sender.id == currentUserId;

                        // Debug: print message info
                        // ignore: avoid_print
                        if (message.type == 'image' || message.type == 'Image') {
                          // ignore: avoid_print
                          print('Image message - type: ${message.type}, content: ${message.content}');
                        }

                        if (isMe) {
                          return BubbleRight(
                            text: message.content,
                            timestamp: message.createdAt,
                            messageType: message.type,
                          );
                        } else {
                          return BubbleLeft(
                            text: message.content,
                            senderName: message.sender.name ?? 'Unknown',
                            avatarUrl: message.sender.avatar,
                            timestamp: message.createdAt,
                            messageType: message.type,
                          );
                        }
                      },

                    );
                  },
                ),
              ),
              // Input Area
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: AppColors.lightGrey, width: 1),
                  ),
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _pickAndSendImage,
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F3F3),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.image,
                            color: AppColors.black,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            hintStyle: TextStyle(color: AppColors.grey),
                            filled: true,
                            fillColor: const Color(0xFFF3F3F3),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide(color: AppColors.lightGrey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide(color: AppColors.blue, width: 1.2),
                            ),
                          ),
                          maxLines: null,
                          textCapitalization: TextCapitalization.sentences,
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      BlocBuilder<ChatCubit, ChatState>(
                        builder: (context, state) {
                          final isLoading = state.isUploadingImage;
                          return GestureDetector(
                            onTap: isLoading ? null : _sendMessage,
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: isLoading ? AppColors.grey : AppColors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : const Icon(
                                      Icons.send,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
