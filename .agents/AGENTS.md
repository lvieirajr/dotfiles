# AGENTS.md

Guidelines to reduce common LLM coding mistakes. Apply alongside project-specific instructions.

These guidelines bias toward correctness, simplicity, and small diffs over speed.
For trivial tasks, use judgment.

Project-specific instructions and established repository conventions take precedence
over these defaults unless explicitly asked to change them.


## 1. Tooling

For new projects or when no existing project convention applies, prefer the following.
Do not migrate an existing project's tooling solely to match these preferences unless explicitly asked to.

Development environment:
- Use [mise-en-place](https://mise.jdx.dev/) to:
  - Control tool and dependency versions
  - Set up environment variables
  - Configure the development environment
  - Manage project tasks

Python:
- Use [uv](https://docs.astral.sh/uv/) for dependency management and packaging
- Use [pytest](https://docs.pytest.org/en/stable/) for testing
- Use [ruff](https://docs.astral.sh/ruff/) for linting and formatting
- Prefer [ty](https://docs.astral.sh/ty/) for type checking
- Use [mypy](https://mypy.readthedocs.io/en/stable/) when already established by the project or otherwise required

TypeScript / JavaScript:
- Prefer TypeScript for new code
- Use [bun](https://bun.sh/) for dependency management and task execution
- Use [biome](https://biomejs.dev/) for linting and formatting
- Use [tsc](https://www.typescriptlang.org/) for type checking


## 2. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State assumptions when they materially affect the solution.
- If multiple reasonable interpretations exist, surface them rather than silently choosing one.
- If a simpler approach exists, say so.
- Push back when the requested approach introduces unnecessary complexity or risk.
- If important information is missing and cannot be inferred safely from the repository, ask.

Do not ask questions about details that can be resolved safely by inspecting the codebase.


## 3. Simplicity First

**Write the minimum code necessary to solve the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No flexibility or configurability that wasn't requested.
- Don't add defensive handling for scenarios with no realistic failure mode.
- Prefer straightforward code to clever code.
- If the implementation is substantially larger than the problem warrants, simplify it.

Ask yourself: "Would a senior engineer consider this overcomplicated?" If yes, simplify.


## 4. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't improve adjacent code, comments, or formatting unrelated to the task.
- Don't refactor unrelated code.
- Match the existing project's conventions unless explicitly asked to change them.
- If you notice unrelated problems or dead code, mention them rather than changing them.

When your changes create orphans:
- Remove imports, variables, functions, or files made unused by your changes.
- Don't remove pre-existing dead code unless asked.

Every changed line should have a clear relationship to the requested task.


## 5. Goal-Driven Execution

**Define success criteria. Work until they are verified.**

Transform tasks into verifiable goals:
- "Add validation" → add tests for invalid inputs, then make them pass.
- "Fix the bug" → reproduce the bug with a test when practical, then make it pass.
- "Refactor X" → establish existing behavior, refactor, then verify behavior is unchanged.

For multi-step tasks, use a brief plan when it adds clarity:

```text
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Prefer executing and verifying over repeatedly asking for confirmation when the goal is clear.


## 6. Verification

**Never claim something works unless it was verified.**

Before finishing:
- Run the most relevant tests for the changed behavior.
- Run applicable linting, formatting, and type checks when practical.
- Check the resulting diff for unrelated changes.
- If a check cannot be run, say so explicitly.
- Report what was actually verified, not what should theoretically work.

Do not silently ignore failing checks.

---

These guidelines are working if:
- Diffs contain fewer unrelated changes.
- Solutions require fewer rewrites due to overengineering.
- Important ambiguity is surfaced before implementation.
- Existing repository conventions are respected.
- Completed work comes with concrete verification.
