import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wemu_team_app/widgets/select/field_select.dart';
import 'package:wemu_team_app/core/configs/assets/app_vector.dart';
import 'package:wemu_team_app/core/configs/theme/app_colors.dart';
import 'package:wemu_team_app/widgets/select/field_user_select.dart';
import 'package:wemu_team_app/widgets/input/field_input.dart';
import 'package:wemu_team_app/widgets/datetime/date_time_picker.dart';
import 'package:wemu_team_app/widgets/button/basic_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wemu_team_app/core/di/injection.dart';
import 'package:wemu_team_app/features/login/domain/repositories/auth_repository.dart';
import 'package:wemu_team_app/features/tasks/presentation/bloc/tasks_cubit.dart';
import 'package:wemu_team_app/features/timesheet/presentation/bloc/timesheet_cubit.dart';

class AddTaskSheet extends StatefulWidget {
  const AddTaskSheet({super.key});

  static Future<bool?> show({required BuildContext context}) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.introOverlay,
      builder: (_) => const AddTaskSheet(),
    );
  }

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final GlobalKey<ScaffoldMessengerState> _sheetMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final AuthRepository _authRepository = getIt<AuthRepository>();
  final TasksCubit _tasksCubit = getIt<TasksCubit>();
  final TimesheetCubit _timesheetCubit = getIt<TimesheetCubit>();

  void _showSheetSnackBar(String message, {Color backgroundColor = Colors.red}) {
    _sheetMessengerKey.currentState?.clearSnackBars();
    _sheetMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        duration: const Duration(seconds: 5),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 100, left: 16, right: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  List<String> selectedCustomerIds = [];
  List<UserOption> customerOptions = [];
  Map<String, String> customerIdToNameMap = {};
  Map<String, String> customerIdToPhoneMap = {};
  bool isLoadingCustomers = false;
  bool isLoadingEmployees = false;
  bool _showCustomerField = false;

  List<String> selectedEmployeeIds = [];
  List<UserOption> employeeOptions = [];

  List<Map<String, String>> serviceOptions = [];
  String? selectedServiceId;
  bool isLoadingServices = false;
  String _serviceSearchQuery = '';

  final TextEditingController _taskController = TextEditingController();
  final List<TextEditingController> _subTaskControllers = [];
  final List<String> _subTaskIds = [];

  final TextEditingController _notesController = TextEditingController();

  final List<File> _selectedPhotos = [];

  final ImagePicker _imagePicker = ImagePicker();
  bool _isLoading = false;
  OverlayEntry? _serviceOverlayEntry;
  final LayerLink _serviceLayerLink = LayerLink();
  final GlobalKey _serviceInputKey = GlobalKey();

  late DateTime _selectedDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();

    final now = DateTime.now();
    final rounded = _roundUpToQuarterHour(now);
    _startTime = TimeOfDay(hour: rounded.hour, minute: rounded.minute);
    final end = rounded.add(const Duration(minutes: 30));
    _endTime = TimeOfDay(hour: end.hour, minute: end.minute);

    _loadEmployees();
    _loadCustomers();

    _taskController.addListener(() {
      final text = _taskController.text;
      setState(() {
        _serviceSearchQuery = text;
      });

      if (selectedServiceId != null) {
        final selectedService = serviceOptions.firstWhere(
          (s) => s['id'] == selectedServiceId,
          orElse: () => const <String, String>{},
        );
        final serviceName = selectedService['name'] ?? '';
        if (serviceName.isNotEmpty && text.trim() == serviceName) {
          return;
        }
        setState(() {
          selectedServiceId = null;

          final startMinutes = _startTime.hour * 60 + _startTime.minute;
          final endMinutes = _endTime.hour * 60 + _endTime.minute;
          if (startMinutes >= endMinutes) {
            _endTime = TimeOfDay(
              hour: (startMinutes + 30) ~/ 60 % 24,
              minute: (startMinutes + 30) % 60,
            );
          }
        });
      }

      if (text.isNotEmpty && serviceOptions.isNotEmpty && _serviceOverlayEntry == null) {
        final filtered = _getFilteredServices(text);
        if (filtered.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showServiceDropdown();
          });
        }
      }
    });
  }

  Future<void> _loadCustomers({String? searchQuery}) async {
    if (isLoadingCustomers) return;

    setState(() {
      isLoadingCustomers = true;
    });

    try {
      final customers = await _tasksCubit.searchCustomers(searchQuery: searchQuery);

      debugPrint('Loaded ${customers.length} customers');

      final options = customers.map((customer) {
        final id = customer['_id']?.toString() ?? '';
        final name =
            customer['name']?.toString() ??
            '${customer['firstName'] ?? ''} ${customer['lastName'] ?? ''}'.trim();
        final avatar = customer['avatar']?.toString();
        final email = customer['email']?.toString() ?? '';
        final phone = customer['phone']?.toString() ?? '';

        String displayName = name;
        if (displayName.isEmpty) {
          displayName = email.isNotEmpty ? email : (phone.isNotEmpty ? phone : 'Unknown');
        }

        return UserOption(
          id: id,
          name: displayName,
          avatarUrl: avatar?.isNotEmpty == true ? avatar : null,
        );
      }).toList();

      final allOptions = [const UserOption(id: 'guest', name: 'Guest/Walk-in'), ...options];

      final idToNameMap = <String, String>{};
      final idToPhoneMap = <String, String>{};
      for (final option in allOptions) {
        idToNameMap[option.id] = option.name;
      }

      for (final customer in customers) {
        final id = customer['_id']?.toString() ?? '';
        final phone = customer['phone']?.toString() ?? '';
        if (id.isNotEmpty) {
          idToPhoneMap[id] = phone;
        }
      }

      if (mounted) {
        setState(() {
          customerOptions = allOptions;
          customerIdToNameMap = idToNameMap;
          customerIdToPhoneMap = idToPhoneMap;
          isLoadingCustomers = false;
        });
        debugPrint('Set ${allOptions.length} customer options (including guest)');
      }
    } catch (e) {
      debugPrint('Failed to load customers: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load customers: $e')));
        setState(() {
          customerOptions = [];
          isLoadingCustomers = false;
        });
      }
    }
  }

  Future<void> _loadEmployees() async {
    try {
      final user = _authRepository.getCachedUser();
      if (user == null || user.id.isEmpty) {
        return;
      }

      setState(() {
        isLoadingEmployees = true;
        // Keep current user as default option immediately.
        employeeOptions = [
          UserOption(
            id: user.id,
            name: user.displayNameOrGuest,
            avatarUrl: user.avatar.isNotEmpty ? user.avatar : null,
          ),
        ];
        selectedEmployeeIds = [user.id];
      });

      await _timesheetCubit.loadMembers(status: 'active');
      final members = _timesheetCubit.state.members;
      final options = _mapEmployeesToOptions(members);

      final hasCurrent = options.any((o) => o.id == user.id);
      final merged = hasCurrent ? options : [employeeOptions.first, ...options];

      if (mounted) {
        setState(() {
          employeeOptions = merged;
          selectedEmployeeIds = [user.id];
          isLoadingEmployees = false;
        });
        await _loadServicesForEmployee(user.id);
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          isLoadingEmployees = false;
        });
      }
    }
  }

  DateTime _roundUpToQuarterHour(DateTime dt) {
    final minute = dt.minute;
    final nextQuarter = ((minute / 15).ceil() * 15) % 60;
    final hourDelta = (minute > 45) ? 1 : 0;
    final rounded = DateTime(dt.year, dt.month, dt.day, dt.hour, nextQuarter);
    return rounded.add(Duration(hours: hourDelta));
  }

  bool get _isServiceActive {
    if (selectedServiceId == null) return false;
    final selectedService = serviceOptions.firstWhere(
      (s) => s['id'] == selectedServiceId,
      orElse: () => const <String, String>{},
    );
    final selectedServiceName = (selectedService['name'] ?? '').trim();
    if (selectedServiceName.isEmpty) return false;
    return _taskController.text.trim() == selectedServiceName;
  }

  int _activeServiceDurationMinutes() {
    if (!_isServiceActive) return 30;
    final selectedService = serviceOptions.firstWhere(
      (s) => s['id'] == selectedServiceId,
      orElse: () => const <String, String>{},
    );
    final raw = (selectedService['duration'] ?? '').trim();
    final parsed = int.tryParse(raw);
    return parsed ?? 30;
  }

  void _recalculateEndTimeForStart(TimeOfDay start) {
    if (_isServiceActive) {
      final duration = _activeServiceDurationMinutes();
      final startMinutes = start.hour * 60 + start.minute;
      final endMinutes = startMinutes + duration;
      setState(() {
        _endTime = TimeOfDay(hour: (endMinutes ~/ 60) % 24, minute: endMinutes % 60);
      });
      return;
    }

    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = _endTime.hour * 60 + _endTime.minute;
    if (startMinutes >= endMinutes) {
      setState(() {
        _endTime = TimeOfDay(
          hour: (startMinutes + 30) ~/ 60 % 24,
          minute: (startMinutes + 30) % 60,
        );
      });
    }
  }

  List<Map<String, String>> _getFilteredServices(String query) {
    if (query.isEmpty) return serviceOptions;
    final lowerQuery = query.toLowerCase();
    return serviceOptions
        .where((service) => (service['name'] ?? '').toLowerCase().contains(lowerQuery))
        .toList();
  }

  List<UserOption> _mapEmployeesToOptions(List<Map<String, dynamic>> employees) {
    return employees
        .map((e) {
          final id = (e['_id'] ?? e['id'] ?? '').toString();
          final first = (e['firstName'] ?? '').toString().trim();
          final last = (e['lastName'] ?? '').toString().trim();
          final displayName = (e['displayName'] ?? e['name'] ?? '').toString().trim();
          final email = (e['email'] ?? '').toString().trim();
          final phone = (e['phone'] ?? '').toString().trim();
          final avatar = (e['avatar'] ?? e['photo'] ?? '').toString().trim();

          var name = displayName.isNotEmpty ? displayName : ('$first $last').trim();
          if (name.isEmpty) {
            name = email.isNotEmpty ? email : (phone.isNotEmpty ? phone : 'Unknown');
          }

          return UserOption(
            id: id,
            name: name,
            avatarUrl: avatar.isNotEmpty ? avatar : null,
          );
        })
        .where((o) => o.id.isNotEmpty)
        .toList();
  }

  void _showServiceDropdown() {
    if (_serviceOverlayEntry != null) return;

    if (!mounted) return;

    final overlay = Overlay.of(context);
    final renderBox = _serviceInputKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    _serviceOverlayEntry = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: GestureDetector(
          onTap: () {
            _serviceOverlayEntry?.remove();
            _serviceOverlayEntry = null;
          },
          behavior: HitTestBehavior.translucent,
          child: Stack(
            children: [
              CompositedTransformFollower(
                link: _serviceLayerLink,
                showWhenUnlinked: false,
                offset: const Offset(0, 56),
                child: Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(10),
                  child: StatefulBuilder(
                    builder: (context, setOverlayState) {
                      final filteredServices = _getFilteredServices(_serviceSearchQuery);

                      return Container(
                        width: renderBox.size.width,
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.lightGrey),
                        ),
                        child: filteredServices.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  'No services found',
                                  style: TextStyle(color: AppColors.grey),
                                ),
                              )
                            : ListView(
                                shrinkWrap: true,
                                physics: const AlwaysScrollableScrollPhysics(),
                                children: filteredServices.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final service = entry.value;
                                  final serviceId = service['id'] ?? '';
                                  final serviceName = service['name'] ?? '';
                                  final isSelected = selectedServiceId == serviceId;
                                  final isLast = index == filteredServices.length - 1;

                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedServiceId = serviceId;
                                            _taskController.text = serviceName;
                                            _serviceSearchQuery = serviceName;

                                            final durationStr = service['duration'] ?? '0';
                                            final duration = int.tryParse(durationStr) ?? 30;
                                            final startMinutes =
                                                _startTime.hour * 60 + _startTime.minute;
                                            final endMinutes = startMinutes + duration;
                                            _endTime = TimeOfDay(
                                              hour: (endMinutes ~/ 60) % 24,
                                              minute: endMinutes % 60,
                                            );
                                          });
                                          _serviceOverlayEntry?.remove();
                                          _serviceOverlayEntry = null;
                                        },
                                        child: Container(
                                          color: isSelected
                                              ? AppColors.blue.withOpacity(0.1)
                                              : Colors.transparent,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 12,
                                          ),
                                          child: Row(
                                            children: [Expanded(child: Text(serviceName))],
                                          ),
                                        ),
                                      ),
                                      if (!isLast)
                                        Divider(
                                          height: 1,
                                          thickness: 1,
                                          color: AppColors.lightGrey,
                                        ),
                                    ],
                                  );
                                }).toList(),
                              ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    overlay.insert(_serviceOverlayEntry!);
  }

  Future<void> _loadServicesForEmployee(String employeeId) async {
    if (isLoadingServices) return;

    setState(() {
      isLoadingServices = true;
    });

    try {
      final services = await _tasksCubit.searchServices(
        employeeId: employeeId,
        keyword: null,
        limit: 50,
      );

      final options = services
          .map(
            (s) => {
              'id': s['_id']?.toString() ?? '',
              'name': s['name']?.toString() ?? '',
              'duration': s['duration']?.toString() ?? '',
            },
          )
          .where((m) => (m['id'] ?? '').isNotEmpty && (m['name'] ?? '').isNotEmpty)
          .toList();

      if (mounted) {
        setState(() {
          serviceOptions = options;
          isLoadingServices = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          serviceOptions = [];
          isLoadingServices = false;
        });
      }
    }
  }

  void _addSubTask() {
    setState(() {
      _subTaskControllers.add(TextEditingController());
      _subTaskIds.add(DateTime.now().millisecondsSinceEpoch.toString());
    });
  }

  void _removeSubTask(int index) {
    setState(() {
      _subTaskControllers[index].dispose();
      _subTaskControllers.removeAt(index);
      _subTaskIds.removeAt(index);
    });
  }

  @override
  void dispose() {
    _serviceOverlayEntry?.remove();
    _taskController.dispose();
    _notesController.dispose();
    for (var controller in _subTaskControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _pickNoteImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image == null) return;
      setState(() {
        _selectedPhotos.add(File(image.path));
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
      }
    }
  }

  void _removePhoto(int index) {
    setState(() {
      _selectedPhotos.removeAt(index);
    });
  }

  Future<void> _submitTask() async {
    final taskText = _taskController.text.trim();
    final subTasksText = _subTaskControllers
        .map((controller) => controller.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    if (taskText.isEmpty && subTasksText.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please enter a task or add a sub task')));
      }
      return;
    }

    final user = _authRepository.getCachedUser();
    final employeeId = selectedEmployeeIds.isNotEmpty
        ? selectedEmployeeIds.first
        : (user?.id ?? '');

    if (employeeId.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('User not found. Please login again.')));
      }
      return;
    }

    final startDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _startTime.hour,
      _startTime.minute,
    );
    final endDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _endTime.hour,
      _endTime.minute,
    );

    DateTime finalEndDateTime = endDateTime;
    if (endDateTime.isBefore(startDateTime) || endDateTime.isAtSameMomentAs(startDateTime)) {
      finalEndDateTime = endDateTime.add(const Duration(days: 1));
    }

    if (startDateTime.isBefore(DateTime.now())) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Start time cannot be in the past')));
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      List<String> photoNames = [];
      for (final photo in _selectedPhotos) {
        try {
          final photoName = await _tasksCubit.uploadPhoto(photo);
          photoNames.add(photoName);
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Failed to upload photo: $e')));
          }
        }
      }

      final subTasks = <Map<String, dynamic>>[];

      String? serviceIdToSend;
      if (selectedServiceId != null) {
        final selectedService = serviceOptions.firstWhere(
          (s) => s['id'] == selectedServiceId,
          orElse: () => const <String, String>{},
        );
        final selectedServiceName = (selectedService['name'] ?? '').trim();
        if (selectedServiceName.isNotEmpty && taskText.trim() == selectedServiceName) {
          serviceIdToSend = selectedServiceId;
        }
      }

      if (serviceIdToSend == null) {
        if (taskText.isNotEmpty) {
          subTasks.add({'name': taskText});
        }
      }

      for (final subTaskText in subTasksText) {
        subTasks.add({'name': subTaskText});
      }

      Map<String, String>? contactInfo;
      String? userId;

      if (selectedCustomerIds.isNotEmpty) {
        userId = selectedCustomerIds.first;
        if (userId == 'guest') {
          userId = null;
        } else {
          final phone = customerIdToPhoneMap[userId] ?? '';

          contactInfo = {if (phone.isNotEmpty) 'phone': phone};
        }
      }

      await _tasksCubit.addTask(
        employeeId: employeeId,
        userId: userId,
        subTasks: subTasks,
        serviceIds: serviceIdToSend != null ? [serviceIdToSend] : null,
        contactInfo: contactInfo,
        startAt: startDateTime,
        endAt: finalEndDateTime,
        notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
        photos: photoNames.isNotEmpty ? photoNames : null,
        branchId: null,
      );

      if (mounted) {
        _showSheetSnackBar('Task created successfully', backgroundColor: Colors.green);
        _tasksCubit.loadTasks();
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Failed to create task';
        if (e.toString().contains('TasksException')) {
          final parts = e.toString().split(':');
          if (parts.length > 1) {
            errorMessage = parts.sublist(1).join(':').trim();
          } else {
            errorMessage = e.toString();
          }
        } else {
          errorMessage = e.toString().replaceAll('Exception: ', '');
        }

        _showSheetSnackBar(errorMessage, backgroundColor: Colors.red);
        debugPrint('Task creation failed: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.95,
      minChildSize: 0.35,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return ScaffoldMessenger(
          key: _sheetMessengerKey,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Material(
              color: Colors.transparent,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 18, 10, 0),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Add Task',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: const Divider(height: 1, color: AppColors.lightGrey),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Task',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.grey,
                                  ),
                                ),
                                CompositedTransformTarget(
                                  link: _serviceLayerLink,
                                  child: Container(
                                    key: _serviceInputKey,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFFFFF),
                                      border: Border(
                                        bottom: BorderSide(
                                          color: AppColors.lightGrey,
                                          width: 1, // có thể chỉnh độ dày
                                        ),
                                      ),
                                    ),

                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller: _taskController,
                                            decoration: const InputDecoration(
                                              isDense: true,
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        if (serviceOptions.isNotEmpty)
                                          GestureDetector(
                                            onTap: () {
                                              if (_serviceOverlayEntry != null) {
                                                _serviceOverlayEntry!.remove();
                                                _serviceOverlayEntry = null;
                                              } else {
                                                _showServiceDropdown();
                                              }
                                            },
                                            child: const Icon(Icons.keyboard_arrow_down),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ...List.generate(_subTaskControllers.length, (index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: SvgPicture.asset(AppVector.arrowAlt),
                                    ),
                                    Expanded(
                                      child: TextField(
                                        controller: _subTaskControllers[index],
                                        decoration: InputDecoration(
                                          hintText: 'Type here',
                                          hintStyle: TextStyle(color: AppColors.grey),
                                          filled: true,
                                          fillColor: Colors.white,
                                          contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 14,
                                          ),
                                          border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppColors.lightGrey,
                                              width: 1,
                                            ),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppColors.lightGrey,
                                              width: 1,
                                            ),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppColors.blue,
                                              width: 1.2,
                                            ),
                                          ),
                                          suffixIcon: GestureDetector(
                                            onTap: () => _removeSubTask(index),
                                            child: Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: SvgPicture.asset(AppVector.trashRed),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            const SizedBox(height: 8),
                            OutlinedButton.icon(
                              onPressed: _addSubTask,
                              icon: const Icon(Icons.add, color: AppColors.black),
                              label: const Text(
                                'Add sub task',
                                style: TextStyle(color: AppColors.black),
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                side: BorderSide(color: AppColors.lightGrey),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            if (!_showCustomerField)
                              OutlinedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _showCustomerField = true;
                                  });
                                },
                                icon: const Icon(Icons.add, color: AppColors.black),
                                label: const Text(
                                  'Add customer',
                                  style: TextStyle(color: AppColors.black),
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  side: BorderSide(color: AppColors.lightGrey),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                              )
                            else
                              FieldSelect(
                                isOutLine: true,
                                label: 'Customer',
                                labelColor: AppColors.grey,
                                placeholder: isLoadingCustomers
                                    ? 'Loading customers...'
                                    : (customerOptions.isEmpty
                                          ? 'No customers found'
                                          : 'Please select customer'),
                                options: customerOptions
                                    .map(
                                      (opt) =>
                                          FieldSelectOption(value: opt.id, label: opt.name),
                                    )
                                    .toList(),
                                selectedValues: selectedCustomerIds,
                                multi: false,
                                onChanged: (newSelectedIds) {
                                  setState(() {
                                    selectedCustomerIds = newSelectedIds;
                                  });
                                },
                              ),
                            if (_showCustomerField &&
                                selectedCustomerIds.isNotEmpty &&
                                selectedCustomerIds.first != 'guest')
                              Builder(
                                builder: (context) {
                                  final selectedCustomerId = selectedCustomerIds.first;
                                  final customerPhone =
                                      customerIdToPhoneMap[selectedCustomerId] ?? '';
                                  if (customerPhone.isEmpty) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8, left: 8),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.warning_amber_rounded,
                                            color: Colors.red,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              'This customer does not have a mobile number.',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontStyle: FontStyle.italic,
                                                color: Colors.red[600],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            if (_showCustomerField &&
                                !isLoadingCustomers &&
                                customerOptions.isEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: TextButton(
                                  onPressed: () => _loadCustomers(),
                                  child: const Text('Retry loading customers'),
                                ),
                              ),
                            const SizedBox(height: 24),
                            FieldUserSelect(
                              labelColor: AppColors.grey,
                              isOutLine: true,
                              showDropdownIcon: true,
                              label: 'Assign',
                              placeholder: isLoadingEmployees
                                  ? 'Loading employees...'
                                  : (employeeOptions.isEmpty
                                        ? 'No employees found'
                                        : 'Please select employee'),
                              options: employeeOptions,
                              selectedIds: selectedEmployeeIds,
                              multi: false,
                              onChanged: (newSelectedIds) async {
                                if (newSelectedIds.isEmpty) return;
                                final newId = newSelectedIds.first;
                                setState(() {
                                  selectedEmployeeIds = [newId];
                                  selectedServiceId = null;
                                });
                                await _loadServicesForEmployee(newId);
                              },
                            ),

                            const SizedBox(height: 24),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: DateTimePicker(
                                    label: 'Start Date',
                                    labelColor: AppColors.grey,
                                    showIcons: false,
                                    isOutLine: true,
                                    date: _selectedDate,
                                    time: _startTime,
                                    onDateChanged: (newDate) {
                                      setState(() {
                                        _selectedDate = newDate;
                                      });
                                    },
                                    onTimeChanged: (newTime) {
                                      setState(() {
                                        _startTime = newTime;
                                      });
                                      _recalculateEndTimeForStart(newTime);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: DateTimePicker(
                                    label: 'End Date',
                                    labelColor: AppColors.grey,
                                    showIcons: false,
                                    isOutLine: true,
                                    date: _selectedDate,
                                    time: _endTime,
                                    minDate: _selectedDate,
                                    onDateChanged: (newDate) {
                                      setState(() {
                                        _selectedDate = newDate;
                                      });
                                    },
                                    onTimeChanged: _isServiceActive
                                        ? null
                                        : (newTime) {
                                            setState(() {
                                              final startMinutes =
                                                  _startTime.hour * 60 + _startTime.minute;
                                              final endMinutes =
                                                  newTime.hour * 60 + newTime.minute;
                                              if (endMinutes <= startMinutes) {
                                                _endTime = TimeOfDay(
                                                  hour: (startMinutes + 1) ~/ 60 % 24,
                                                  minute: (startMinutes + 1) % 60,
                                                );
                                              } else {
                                                _endTime = newTime;
                                              }
                                            });
                                          },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Notes',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.lightGrey),
                              ),
                              child: Stack(
                                children: [
                                  TextField(
                                    controller: _notesController,
                                    maxLines: null,
                                    expands: true,
                                    decoration: const InputDecoration(
                                      hintText: '',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.fromLTRB(14, 14, 48, 14),
                                    ),
                                  ),
                                  Positioned(
                                    right: 12,
                                    bottom: 12,
                                    child: GestureDetector(
                                      onTap: _pickNoteImage,
                                      child: SvgPicture.asset(
                                        AppVector.filePlus,
                                        width: 22,
                                        height: 22,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_selectedPhotos.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: List.generate(_selectedPhotos.length, (index) {
                                  return Stack(
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: AppColors.lightGrey),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.file(
                                            _selectedPhotos[index],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: GestureDetector(
                                          onTap: () => _removePhoto(index),
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.all(16),
                      child: BasicButton(
                        title: _isLoading ? 'Creating...' : 'Add Task',
                        height: 50,
                        onPressed: _isLoading ? () {} : _submitTask,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
