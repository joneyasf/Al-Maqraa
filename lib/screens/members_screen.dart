import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../widgets/app_scope.dart';

/// قائمة أعضاء المقرأة: الدور، الحضور، عدد الصفحات.
/// كل الأرقام مشرقية افتراضيًا من AppState.
class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _addMember() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    AppScope.read(context).live.addMember(name);
    _nameController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    final app = scope.app;
    final live = scope.live;
    return AnimatedBuilder(
      animation: Listenable.merge([app, live]),
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'الأعضاء (${app.fmt(live.members.length)})',
              style: amiri(size: 24, bold: true),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  itemCount: live.members.length,
                  itemBuilder: (context, i) {
                    final m = live.members[i];
                    final isCurrent = i == live.currentReaderIndex;
                    return Card(
                      color: AppColors.card(context),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: isCurrent
                              ? AppColors.gold
                              : AppColors.border(context),
                          width: isCurrent ? 2 : 1,
                        ),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: m.isSheikh
                              ? AppColors.gold
                              : AppColors.emerald,
                          child: Text(
                            m.name.characters.first,
                            style: cairo(
                              size: 17,
                              weight: 800,
                              color: m.isSheikh
                                  ? AppColors.deepGreen
                                  : Colors.white,
                            ),
                          ),
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                m.name,
                                style: cairo(
                                  size: 17,
                                  weight: 800,
                                  color: AppColors.text(context),
                                ),
                              ),
                            ),
                            if (isCurrent)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.gold,
                                  borderRadius: BorderRadius.circular(99),
                                ),
                                child: Text(
                                  'يقرأ الآن',
                                  style: cairo(
                                    size: 12,
                                    weight: 800,
                                    color: AppColors.deepGreen,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        subtitle: Text(
                          '${m.role} — حضور ${app.fmt(m.streak)} ليالٍ — ${app.fmt(m.pagesRead)} صفحة',
                          style: cairo(size: 13),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (m.handRaised)
                              const Icon(
                                Icons.pan_tool_rounded,
                                color: AppColors.gold,
                              ),
                            Checkbox(
                              value: m.present,
                              onChanged: (_) =>
                                  live.toggleMemberPresent(i),
                            ),
                            if (!m.isSheikh)
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline_rounded,
                                  size: 20,
                                ),
                                onPressed: () => live.removeMember(i),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'اسم عضو جديد',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => _addMember(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _addMember,
                      child: const Text('إضافة'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
