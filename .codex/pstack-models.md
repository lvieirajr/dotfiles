# pstack model configuration

Per-role model overrides for pstack skills in Codex. These values override the defaults in each skill. Delete a role line to use its skill default. `inherit-parent` and `auto` omit the model override; alias entries still count toward a panel's fan-out. Model values may carry an effort suffix, such as `gpt-6.1-sol @high`. Entries without a suffix use `default effort`. `session` requires the current turn's effort metadata; if unavailable, choose an explicit effort before dispatching. Available effort levels in this session: low, medium, high, xhigh, max, ultra. `session hook: off` disables the plugin's routing mandate; otherwise it stays on.

User rule (2026-10-30): effort caps per model. GPT-6 Astra (gpt-6-astra) never runs above medium effort; GPT-6.1 Sol (gpt-6.1-sol) never runs above high effort; GPT-6.1 Terra (gpt-6.1-terra) and GPT-6 Luna (gpt-6-luna) never run above xhigh effort. These are ceilings, not targets: pick the effort the job needs as usual (session level, role @level, poteto-mode's raise or lower), and only if that lands above the model's cap, drop it to the cap. Never raise effort toward the cap. Apply the cap after all task effort adjustments, before dispatching.

feature, refactoring: gpt-6.1-terra
bug-fix: gpt-6.1-sol
perf-issue: gpt-6.1-sol
hillclimb: gpt-6.1-sol
judgment and prose: gpt-6.1-sol
strongest judgment: gpt-6-astra
how explorer: gpt-6.1-sol
how explainer: gpt-6.1-sol
why investigators: gpt-6.1-sol
why synthesizer: gpt-6.1-sol
reflect tooling: gpt-6.1-sol
reflect judgment, divergent, synthesizer: gpt-6.1-sol
arena runners: gpt-6.1-sol, gpt-6-astra, gpt-6.1-terra, gpt-6-luna
arena cross-judge pool: gpt-6.1-sol, gpt-6-astra, gpt-6.1-terra, gpt-6-luna
swarm workers: gpt-6.1-sol
architect runners: gpt-6.1-sol, gpt-6-astra, gpt-6.1-terra, gpt-6-luna
interrogate reviewers: gpt-6.1-sol, gpt-6-astra, gpt-6.1-terra, gpt-6-luna

default effort: session
session hook: on
