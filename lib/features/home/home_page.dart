import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wemu_team_app/core/di/injection.dart';
import 'package:wemu_team_app/generated/localizations.dart';
import 'package:wemu_team_app/widgets/button/basic_button.dart';
import 'package:wemu_team_app/widgets/card/summary_card.dart';
import 'package:wemu_team_app/core/configs/assets/app_images.dart';
import 'package:wemu_team_app/core/configs/theme/app_colors.dart';
import 'package:wemu_team_app/features/login/domain/repositories/auth_repository.dart';
import 'package:wemu_team_app/features/profile/pages/profile_overview_page.dart';
import 'package:wemu_team_app/features/tasks/presentation/bloc/tasks_cubit.dart';
import 'package:wemu_team_app/features/tasks/presentation/bloc/tasks_state.dart';
import 'package:wemu_team_app/models/user_profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isClockedIn = false;
  UserProfile? _user;
  late final TasksCubit _tasksCubit;

  void _openProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ProfileOverviewPage()),
    );
  }

  // Activity list (empty = show empty state)
  final List<Map<String, String>> activities = [
    {
      'title': '📝 Task updated (ID 10000)',
      'description': 'Shave with Jay has been updated to 10:30 am.',
      'time': 'Just now',
    },
    {
      'title': '❌ Task canceled (ID 12111)',
      'description': 'Haircut with Jane has been canceled.',
      'time': '30 min ago',
    },
  ];

  @override
  void initState() {
    super.initState();
    _user = getIt<AuthRepository>().getCachedUser();
    _tasksCubit = getIt<TasksCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final now = DateTime.now();
      final weekStart = _getStartOfWeek(now);
      final weekEnd = _getEndOfWeek(now);
      _tasksCubit.loadTaskSummary(fromDate: weekStart, toDate: weekEnd, type: 'weekly');
      _tasksCubit.loadWeeklyHours(date: now);
    });
  }

  DateTime _getStartOfWeek(DateTime date) {
    final weekday = date.weekday; // 1 = Monday, 7 = Sunday
    final startDate = DateTime(date.year, date.month, date.day)
        .subtract(Duration(days: weekday - 1));
    return DateTime(startDate.year, startDate.month, startDate.day, 0, 0, 0, 0);
  }

  DateTime _getEndOfWeek(DateTime date) {
    final weekday = date.weekday; // 1 = Monday, 7 = Sunday
    final daysToAdd = 7 - weekday;
    final endDate = DateTime(date.year, date.month, date.day)
        .add(Duration(days: daysToAdd));
    return DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59, 999);
  }

  String _greetingForHour(AppLocalizations l10n, int hour) {
    if (hour < 12) {
      return l10n.homeGreetingMorning;
    }
    if (hour < 18) {
      return l10n.homeGreetingAfternoon;
    }
    return l10n.homeGreetingEvening;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final greeting = _greetingForHour(l10n, DateTime.now().hour);
    final nameToShow = _user?.displayNameOrGuest ?? 'Guest';
    final avatarUrl = _user?.avatar ?? '';
    final ImageProvider avatarProvider = avatarUrl.isNotEmpty
        ? NetworkImage(avatarUrl)
        : const AssetImage(AppImages.avatar);

    return BlocProvider.value(
      value: _tasksCubit,
      child: BlocBuilder<TasksCubit, TasksState>(
        builder: (context, tasksState) {
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        pinned: true,
                        floating: false,
                        snap: false,
                        backgroundColor: Colors.white,
                        elevation: 0,
                        expandedHeight: 250,
                        collapsedHeight: kToolbarHeight,
                        automaticallyImplyLeading: false,
                        flexibleSpace: LayoutBuilder(
                          builder: (context, constraints) {
                            final t = (constraints.maxHeight - kToolbarHeight) /
                                (240 - kToolbarHeight);
                            final collapsed = t < 0.15;

                            return FlexibleSpaceBar(
                              collapseMode: CollapseMode.pin,
                              titlePadding: const EdgeInsetsDirectional.only(
                                start: 16,
                                bottom: 12,
                                end: 16,
                              ),
                              title: collapsed
                                  ? Row(
                                      children: [
                                        GestureDetector(
                                          onTap: _openProfile,
                                          child: CircleAvatar(
                                            radius: 14,
                                            backgroundImage: avatarProvider,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            nameToShow,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: AppColors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : const SizedBox.shrink(),
                              background: Padding(
                                padding: const EdgeInsets.only(
                                  left: 24,
                                  right: 24,
                                  top: 62,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      greeting,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: AppColors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            nameToShow,
                                            style: const TextStyle(
                                              fontSize: 46,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.black,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: _openProfile,
                                          child: CircleAvatar(
                                            radius: 28,
                                            backgroundImage: avatarProvider,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Builder(
                                      builder: (context) {
                                        final now = DateTime.now();
                                        final weekStart = _getStartOfWeek(now);
                                        final weekEnd = _getEndOfWeek(now);
                                        const months = [
                                          'Jan',
                                          'Feb',
                                          'Mar',
                                          'Apr',
                                          'May',
                                          'Jun',
                                          'Jul',
                                          'Aug',
                                          'Sep',
                                          'Oct',
                                          'Nov',
                                          'Dec'
                                        ];
                                        final startStr =
                                            '${weekStart.day} ${months[weekStart.month - 1]}';
                                        final endStr =
                                            '${weekEnd.day} ${months[weekEnd.month - 1]}';
                                        return Text(
                                          '$startStr - $endStr',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: AppColors.black,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        sliver: SliverToBoxAdapter(
                          child: Column(
                            children: [
                              const SizedBox(height: 12),
                              SummaryCard(
                                title: 'Earnings',
                                value: tasksState.summary != null
                                    ? '\$${tasksState.summary!.earnings.toStringAsFixed(2)}'
                                    : '\$0.00',
                                backgroundColor: AppColors.primaryGreen,
                                titleStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.black,
                                ),
                                valueStyle: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: SummaryCard(
                                      title: 'Hours',
                                      value: '${tasksState.weeklyHours}',
                                      backgroundColor: AppColors.primaryPurple,
                                      titleStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      valueStyle: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 11),
                                  Expanded(
                                    child: SummaryCard(
                                      title: 'Tasks',
                                      value: tasksState.summary != null
                                          ? '${tasksState.summary!.totalServices}'
                                          : '0',
                                      backgroundColor: AppColors.yellow,
                                      titleStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      valueStyle: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        sliver: SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              SizedBox(height: 15),
                              Text(
                                'Activities',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.grey,
                                ),
                              ),
                              SizedBox(height: 4),
                            ],
                          ),
                        ),
                      ),
                      if (activities.isEmpty)
                        const SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('📭', style: TextStyle(fontSize: 34)),
                                SizedBox(height: 8),
                                Text(
                                  'No recent activity to show.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          sliver: SliverList.separated(
                            itemCount: activities.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final activity = activities[index];
                              return Container(
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      activity['title'] ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      activity['description'] ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      activity['time'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      const SliverToBoxAdapter(child: SizedBox(height: 24)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                  child: _isClockedIn
                      ? Row(
                          children: [
                            Expanded(
                              child: BasicButton(
                                title: 'Take a break',
                                height: 50,
                                backgroundColor: AppColors.gray,
                                textColor: AppColors.black,
                                onPressed: () {
                                  // TODO: handle break
                                },
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: BasicButton(
                                height: 50,
                                backgroundColor: AppColors.orange,
                                textColor: AppColors.white,
                                onPressed: () {
                                  setState(() => _isClockedIn = false);
                                },
                                child: RichText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Clock out ',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      TextSpan(
                                        text: '(3h & 12m)',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : BasicButton(
                          title: 'Clock In',
                          height: 50,
                          onPressed: () {
                            setState(() => _isClockedIn = true);
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
