---
name: handoff
description: Generate a handoff doc for use before compaction or starting a new chat
disable-model-invocation: true
allowed-tools: Bash(mkdir -p ~/tmp/handoffs), Bash(ls ~/tmp/handoffs), Bash(mkdir -p ~/tmp/handoffs && ls ~/tmp/handoffs), Read(~/tmp/handoffs/**), Write(~/tmp/handoffs/**)
argument-hint: "[optional instructions...]"
---

Write a Markdown doc for handing off your work in progress.

1. Get existing handoff doc names: `ls ~/tmp/handoffs`
    - If the directory doesn't exist: `mkdir -p ~/tmp/handoffs`
    - File names are today's date and a slug: `YYYY-MM-DD-slug.md`

2. Generate a short, unique slug that describes the work in progress
    - examples: "add-word-count-to-article-page", "refactor-api-client", "fix-loading-race-condition", etc.
    - if a similar slug exists for a recent date and feature, you can append "part-X". i.e. "refactor-api-client-part-2", "refactor-api-client-part-3", etc.

3. Generate a handoff doc:
    - Overall goal of work
    - Current progress towards that goal
    - Next steps
    - Key decisions, including code patterns being used
    - Critical files
    - If arguments provided to skill, tailor doc based on those

4. Write it to the `~/tmp/handoffs` folder
