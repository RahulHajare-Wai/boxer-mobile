import '../../../../core/constants/app_strings.dart';

class TodoModel {
  static const String sectionDraft = 'draft';
  static const String sectionUpcoming = 'upcoming';

  static const String priorityCompliance = 'compliance';
  static const String priorityRequest = 'request';
  static const String priorityStoreVisit = 'store_visit';

  final String id;
  final String title;
  final String? subtitle;
  final String section; // 'draft', 'upcoming', 'completed'
  final List<String> badges;
  final String? dueDate;
  final String? dueTime;
  final String? priority; // 'compliance', 'request', 'store_visit'
  final String? assignedTo;

  const TodoModel({
    required this.id,
    required this.title,
    this.subtitle,
    required this.section,
    this.badges = const [],
    this.dueDate,
    this.dueTime,
    this.priority,
    this.assignedTo,
  });

  // Static sample data
  static List<TodoModel> getSampleTodos() {
    // NOTE: sample strings come from AppStrings (shared constants)
    return [
      TodoModel(
        id: '1',
        title: AppStrings.todoTitleBranchVisit,
        dueDate: AppStrings.todoDueDateBranchVisit,
        section: sectionDraft,
        badges: [
          AppStrings.todoBadgeRequest,
          AppStrings.todoBadgeStoreVisitsGmGe,
          AppStrings.todoBadgeDraft,
        ],
        assignedTo: AppStrings.todoAssignedFromSupport,
      ),
      TodoModel(
        id: '2',
        title: AppStrings.todoTitleLowStockScan,
        dueDate: AppStrings.todoDueYesterday,
        section: sectionDraft,
        badges: [
          AppStrings.todoBadgeForm,
          AppStrings.todoBadgeStockManagement,
          AppStrings.todoBadgePendingValidation,
        ],
        dueTime: AppStrings.todoDueTimeToday1030,
        priority: priorityCompliance,
        subtitle: AppStrings.todoSubtitleBurgersfort,
      ),
      TodoModel(
        id: '3',
        title: AppStrings.todoTitleReconciliation,
        dueDate: AppStrings.todoDueToday,
        section: sectionUpcoming,
        badges: [AppStrings.todoBadgeReport, AppStrings.todoBadgeUrgent],
        priority: priorityRequest,
      ),
    ];
  }
}
