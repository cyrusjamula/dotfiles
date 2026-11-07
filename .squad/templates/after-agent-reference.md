# After Agent Reference

### After Agent Work

<!-- KNOWN PLATFORM BUGS: (1) "Silent Success" — ~7-10% of background spawns complete
     file writes but return no text. Mitigated by RESPONSE ORDER + filesystem checks.
     (2) "Server Error Retry Loop" — context overflow after fan-out. Mitigated by lean
     post-work turn + compact result presentation. -->

**Keep the post-work turn lean.** Collect and present compact results. Spawn Scribe
only when accepted durable decisions require merging, not merely because agents ran.
Scribe does not create session logs, orchestration logs, or specialist histories.

After each batch of agent work:

1. **Collect results** via `read_agent` (wait: true).

2. **Silent success detection** — when `read_agent` returns empty/no response:
   - Check filesystem: history.md modified? New decision inbox files? Output files created?
   - Files found → `"⚠️ {Name} completed (files verified) but response lost."` Treat as DONE.
   - No files → `"❌ {Name} failed — no work product."` Consider re-spawn.

3. **Show compact results:** `{emoji} {Name} — {1-line summary of what they did}`

4. **Spawn Scribe** (background, never wait) only for accepted durable decisions:

```
agent_type: "general-purpose"
mode: "background"
name: "scribe"
description: "Scribe: Merge accepted durable decisions"
prompt: |
  You are the Scribe. Read .squad/agents/scribe/charter.md.
  TEAM ROOT: {team_root}
  CURRENT_DATETIME: <resolved CURRENT_DATETIME literal>
  STATE_BACKEND: {state_backend}

  Tasks (in order):
  0. PRE-CHECK: Run `squad_state_health` when available. If state tools are unavailable,
     stop without mutating files or git state.
  0b. PRE-CHECK: Read `decisions.md` and list `decisions/inbox` with state tools.
  1. DECISION INBOX: Use `squad_state_list` and `squad_state_read` on `decisions/inbox`,
     merge only accepted durable decisions into `decisions.md` with `squad_state_write`,
     and deduplicate. Before splicing an inbox body beneath an `###` entry, DEMOTE
     its headings so its shallowest heading lands at `####`. Preserve relative structure.
  2. VERIFY: Re-read `decisions.md` and confirm every merged entry is present before
     deleting its inbox source with `squad_state_delete`.
  3. GIT COMMIT: Do not commit mutable squad state. If non-state repo files changed,
     report them for coordinator handling.

  Runtime state tools own persistence. Never switch branches, push note refs, reset
  `.squad/`, or commit mutable squad state from this prompt.
  Do not create logs or modify specialist histories.

  Never speak to user. End with plain text summary after all tool calls.
```

5. **Immediately assess:** Does anything trigger follow-up work? Launch it NOW.

6. **Ralph check:** If Ralph is active (see Ralph — Work Monitor), after chaining any follow-up work, IMMEDIATELY run Ralph's work-check cycle (Step 1). Do NOT stop. Do NOT wait for user input. Ralph keeps the pipeline moving until the board is clear.
