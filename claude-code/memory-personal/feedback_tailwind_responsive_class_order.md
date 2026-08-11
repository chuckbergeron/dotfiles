---
name: feedback_tailwind_responsive_class_order
description: Keep each Tailwind breakpoint variant immediately after its base utility, not separated by unrelated classes
metadata:
  type: feedback
---

When writing or refactoring Tailwind CSS in `className` (and `cn()`) strings, place each breakpoint variant immediately after the base utility it overrides. Do not insert unrelated classes between them.

- Good: `text-5xl sm:text-6xl`
- Bad: `text-5xl max-w-xl sm:text-6xl`
- Good: `max-w-lg sm:max-w-2xl text-5xl sm:text-6xl` (two pairs, each internally contiguous)
- Good: `px-4 md:px-6 py-10 md:py-14`

Apply the same rule to spacing, layout, and other utility families with `sm:` / `md:` / `lg:` / `xl:` / `2xl:` variants. Arbitrary breakpoints (`max-[380px]:`, `min-[…]:`) follow the same pattern.

If Prettier or a Tailwind sort extension reorders classes and breaks these pairs, fix the string to restore adjacency. This rule takes precedence over strict plugin ordering for readability.

**Why:** User preference for readability — keeping a base/variant pair together makes it easier to scan what changes at each breakpoint.
**How to apply:** Any time writing or editing Tailwind `className` strings.
