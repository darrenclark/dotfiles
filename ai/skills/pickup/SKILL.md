---
name: pickup
description: Pick up work for a handoff doc
disable-model-invocation: true
allowed-tools: Bash(ls -l ~/tmp/handoffs), Read(~/tmp/handoffs/**)
argument-hint: "[slug]"
---

The 

1. Find the handoff doc(s):
    - Find all docs: `ls -l ~/tmp/handoffs`
    - If no arguments were provided, choose the most recent file AND ask the user to confirm.
    - If an exact filename is provided, use only that doc
    - Otherwise, fuzzy match based on the arguments
        - Example: "fix loading indicator" would match slugs like "fix-loading-indicator" and "loading-indicator-fixes"
        - Prefer docs closer to today's date
        - If multiple parts exist, load them sequentially. i.e.:  `2025-10-09-refactor-api-client.md`, `2025-10-10-refactor-api-client-part-2.md`
            - The doc without a part-X suffix is the first one
            - Docs are only considered part of a series if their dates are close to each other - a few weeks difference at most

2. Read the handoff doc(s) and proceed
