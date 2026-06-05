class TodoModel {
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
    return [
      TodoModel(
        id: '1',
        title: 'GM/GE Branch Visit Task',
        dueDate: '06/01/2026',
        section: 'draft',
        badges: ['Request', 'Store Visits (GM/GE)', 'Draft'],
        assignedTo: 'From Boxer Support',
      ),
      TodoModel(
        id: '2',
        title: 'Morning Low Stock Scan Compliance',
        dueDate: 'Yesterday',
        section: 'draft',
        badges: ['Form', 'Stock management', 'Pending validation'],
        dueTime: 'Due today at 10:30 PM',
        priority: 'compliance',
        subtitle: '115 - Burgersfort 2 - Dirk Breytenbach',
      ),
      TodoModel(
        id: '3',
        title: 'Evening Reconciliation Report',
        dueDate: 'Today',
        section: 'upcoming',
        badges: ['Report', 'Urgent'],
        priority: 'request',
      ),
    ];
  }
}
