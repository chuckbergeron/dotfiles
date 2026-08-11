---
name: feedback_prose_no_semicolons_or_em_dashes
description: In prose, avoid semicolons and em dashes — use periods, commas, or shorter sentences instead
metadata:
  type: feedback
---

In **prose** (chat replies, PR descriptions, docs, comments, commit messages, UI copy, error strings), do not use semicolons or em dashes. Use a period, comma, or two short sentences instead.

This does not apply to required code syntax (e.g. `;` ending JavaScript/TypeScript statements, `for` loop headers, CSS).

**Semicolons:** Split into two sentences or use a comma.
- Avoid: `We fixed the CTA; it was failing silently.`
- Use: `We fixed the CTA. It was failing silently.`

**Em dashes:** Use a period, comma, colon, or parentheses instead of `—` or ` -- `.
- Avoid: `Slot returns null — the button never renders.`
- Use: `Slot returns null. The button never renders.`

Hyphens in compound words (`next-intl`, `well-known`) are fine.

**Why:** User preference for cleaner, simpler prose punctuation.
**How to apply:** Always — applies to all written output, not just code.
