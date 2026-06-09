import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/config/app_text_styles.dart';
import '../../data/models/todo_model.dart';
import '../bloc/create_todo_bloc.dart';
import '../bloc/create_todo_event.dart';
import '../bloc/create_todo_state.dart';
import '../widgets/create_todo_date_time_field_widget.dart';
import '../widgets/create_todo_priority_selector_widget.dart';
import '../widgets/create_todo_section_selector_widget.dart';
import '../widgets/create_todo_subtitle_field_widget.dart';
import '../widgets/create_todo_title_field_widget.dart';

class CreateTodoScreen extends StatefulWidget {
  const CreateTodoScreen({super.key});

  @override
  State<CreateTodoScreen> createState() => _CreateTodoScreenState();
}

class _CreateTodoScreenState extends State<CreateTodoScreen> {
  late TextEditingController _titleController;
  late TextEditingController _subtitleController;
  String _selectedSection = TodoModel.sectionDraft;
  String? _selectedPriority;
  String? _selectedDueDate;
  String? _selectedDueTime;
  final List<String> _selectedBadges = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _subtitleController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  void _handleCreateTodo() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.createTodoTitleRequired),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    context.read<CreateTodoBloc>().add(
      CreateTodoRequested(
        title: _titleController.text,
        subtitle: _subtitleController.text.isEmpty
            ? null
            : _subtitleController.text,
        section: _selectedSection,
        badges: _selectedBadges,
        dueDate: _selectedDueDate,
        dueTime: _selectedDueTime,
        priority: _selectedPriority,
      ),
    );
  }

  void _resetForm() {
    context.read<CreateTodoBloc>().add(const ResetCreateTodoForm());
    _titleController.clear();
    _subtitleController.clear();
    setState(() {
      _selectedSection = TodoModel.sectionDraft;
      _selectedPriority = null;
      _selectedDueDate = null;
      _selectedDueTime = null;
      _selectedBadges.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateTodoBloc, CreateTodoState>(
      listener: (context, state) {
        if (state is CreateTodoSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppStrings.createTodoSuccessMessage),
              backgroundColor: AppColors.success,
              duration: const Duration(seconds: 2),
            ),
          );
          // Navigate back after delay
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              Navigator.pop(context, state.todo);
            }
          });
        } else if (state is CreateTodoError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppStrings.createTodoTitle,
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          backgroundColor: AppColors.surface,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.textPrimary),
        ),
        body: BlocBuilder<CreateTodoBloc, CreateTodoState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title Field
                  CreateTodoTitleFieldWidget(controller: _titleController),
                  const SizedBox(height: 20),

                  // Subtitle Field
                  CreateTodoSubtitleFieldWidget(
                    controller: _subtitleController,
                  ),
                  const SizedBox(height: 20),

                  // Section Selector
                  CreateTodoSectionSelectorWidget(
                    selectedSection: _selectedSection,
                    onSectionChanged: (section) {
                      setState(() {
                        _selectedSection = section;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  // Priority Selector
                  CreateTodoPrioritySelectorWidget(
                    selectedPriority: _selectedPriority,
                    onPriorityChanged: (priority) {
                      setState(() {
                        _selectedPriority = priority;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  // Date and Time Fields
                  CreateTodoDateTimeFieldWidget(
                    dueDate: _selectedDueDate,
                    dueTime: _selectedDueTime,
                    onDateChanged: (date) {
                      setState(() {
                        _selectedDueDate = date;
                      });
                    },
                    onTimeChanged: (time) {
                      setState(() {
                        _selectedDueTime = time;
                      });
                    },
                  ),
                  const SizedBox(height: 32),

                  // Create Button
                  ElevatedButton.icon(
                    onPressed: state is CreateTodoLoading
                        ? null
                        : _handleCreateTodo,
                    icon: state is CreateTodoLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.textPrimary,
                              ),
                            ),
                          )
                        : const Icon(Icons.check_circle),
                    label: Text(
                      state is CreateTodoLoading
                          ? AppStrings.creating
                          : AppStrings.createTodoButtonLabel,
                      style: AppTextStyles.titleMedium,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      disabledBackgroundColor: AppColors.textSecondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Reset Button
                  OutlinedButton.icon(
                    onPressed: state is CreateTodoLoading ? null : _resetForm,
                    icon: const Icon(Icons.refresh),
                    label: Text(
                      AppStrings.reset,
                      style: AppTextStyles.titleMedium,
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: AppColors.primary, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
}
