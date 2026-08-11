import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _apiKeyController = TextEditingController();
  final TextEditingController _contextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = context.read<AppProvider>();
    _apiKeyController.text = provider.apiKey;
    _contextController.text = provider.meetingContext;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    
    // Ghost Mode applies a semi-transparent, compact, dark theme
    final isGhost = provider.isGhostMode;

    return Scaffold(
      backgroundColor: isGhost ? const Color(0xFF0F172A).withOpacity(0.85) : const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.visibility_off_rounded, color: isGhost ? Colors.redAccent : const Color(0xFF38BDF8)),
            const SizedBox(width: 8),
            Text(isGhost ? 'GhostAssist (Stealth Mode)' : 'GhostAssist AI - Interview & Meeting Assistant', 
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(isGhost ? Icons.fullscreen_rounded : Icons.filter_none_rounded, color: Colors.white70),
            tooltip: 'Toggle Ghost / Stealth Window',
            onPressed: () => provider.toggleGhostMode(),
          ),
          IconButton(
            icon: const Icon(Icons.settings_rounded, color: Colors.white70),
            onPressed: () => _showSettingsDialog(context),
          ),
        ],
      ),
      body: Row(
        children: [
          // Left panel: Live Prompts & AI Response (Main working area)
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Context Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      children: [
                        const Icon(Icons.psychology_rounded, color: Color(0xFF38BDF8), size: 20),
                        const SizedBox(width: 12),
                        Text('Current Context: ${provider.meetingContext}', style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
                        const Spacer(),
                        TextButton(
                          onPressed: () => _showSettingsDialog(context),
                          child: const Text('Change', style: TextStyle(color: Color(0xFF38BDF8))),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // AI Response Box (The "Ghost" Teleprompter)
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFF38BDF8).withOpacity(0.3)),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text('💡 Instant AI Answer / Talking Points', style: TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold, fontSize: 14)),
                                const Spacer(),
                                if (provider.aiResponse.isNotEmpty)
                                  IconButton(
                                    icon: const Icon(Icons.copy_rounded, color: Colors.white54, size: 18),
                                    onPressed: () {
                                      // Copy to clipboard logic
                                    },
                                  ),
                              ],
                            ),
                            const Divider(color: Colors.white12, height: 24),
                            SelectableText(
                              provider.aiResponse.isEmpty ? 'Type an interview question below or use voice listening to get instant AI answers...' : provider.aiResponse,
                              style: TextStyle(color: Colors.white, fontSize: isGhost ? 18 : 16, height: 1.6),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Input Bar for simulated hearing / typing question
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _questionController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Type question heard in meeting or interview...',
                            hintStyle: const TextStyle(color: Colors.white38),
                            filled: true,
                            fillColor: const Color(0xFF1E293B),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          ),
                          onSubmitted: (val) {
                            if (val.trim().isNotEmpty) {
                              provider.askAI(val);
                              _questionController.clear();
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      FilledButton.icon(
                        onPressed: () {
                          if (_questionController.text.trim().isNotEmpty) {
                            provider.askAI(_questionController.text);
                            _questionController.clear();
                          }
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF38BDF8),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        icon: const Icon(Icons.send_rounded),
                        label: const Text('Ask AI', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Right panel: Meeting Notes & History (Hidden in extreme Ghost mode)
          if (!isGhost) ...[
            Container(width: 1, color: Colors.white12),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('📝 Meeting Notes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.delete_sweep_rounded, color: Colors.white54, size: 20),
                          onPressed: () => provider.clearNotes(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: provider.notes.isEmpty
                          ? const Center(child: Text('Questions & Answers will be saved here automatically.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white38, fontSize: 13)))
                          : ListView.builder(
                              itemCount: provider.notes.length,
                              itemBuilder: (context, index) {
                                final note = provider.notes[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(child: Text('Q: ${note['question']}', style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold, fontSize: 12))),
                                          Text(note['time']!, style: const TextStyle(color: Colors.white38, fontSize: 10)),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(note['answer']!, maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final provider = context.read<AppProvider>();
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          title: const Text('GhostAssist Settings', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _apiKeyController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'OpenAI API Key', labelStyle: TextStyle(color: Colors.white60)),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _contextController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Interview / Meeting Context', labelStyle: TextStyle(color: Colors.white60)),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                provider.setApiKey(_apiKeyController.text);
                provider.setContext(_contextController.text);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
