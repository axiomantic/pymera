# 🐍💀👑 The Pymera

*A cursed chimeric ouroboros of Python and Nim stitched together with syntax hacks — an unholy program that shouldn't exist but does.*

## The Forbidden Question

**Can a single file be both valid Python 3 _and_ valid Nim code?**

Yes, indeed. The same file can contain two completely different programs that execute independently depending on whether the file is invoked with the `nim` compiler or `python` interpreter. No `eval` or metaprogramming necessary.

In this proof-of-concept, the Python side installs Nim if missing, then invokes itself with the nim compiler. The Nim side runs a Fibonacci demo. Same file, different programs.

Check out [`pymera.nim`](./pymera.nim):

```bash
# Run it with Python:
python pymera.nim
# Output: Python detects/installs Nim, then re-executes with Nim

# Compile and run it with Nim:
nim c -r pymera.nim
# Output: Nim prints Fibonacci numbers
```

## How It Works

The trick is exploiting comment syntax differences. A single-line comment `#[` in Python is the start of a block-comment in Nim.

The file has 14 numbered components that create the dual-language structure, outlined below.

### Components 1-6: The 😈 Unholy Python Block

```python
#!/usr/bin/env python3

# 1. Strategic use of `fmt: off/on` protects dual-language syntax from some formatters
# fmt: off

# 2. Nim: 🚫 forbidden block comment begin
#[

# 3. Python: 😈 unholy main block begin
# fmt: on

... Python code that detects/installs Nim goes here ...

# 4. Python: 😈 unholy main block end

# fmt: off

# 5. Python: 🤮 abhorrent list begin
[

# 6. Nim: 🚫 forbidden block comment end, Python: 🤮 abhorrent list end
]#
```

**What Nim sees:**
- **2:** `#[` → Start of a **🚫 forbidden block comment**
- **3-5:** Everything until the matching `]#` → Commented out (all Python code)
- **6:** `]#` → End of forbidden block comment

**What Python sees:**
- **1:** `fmt: off` protects the dual-language syntax boundaries
- **2:** `#[` → Just a line comment ending with `[`
- **3-4:** The executable Python code (with `fmt: on` for safe formatting)
  - Checks if Nim is installed
  - If not, detects package manager (brew/apt/apk) and auto-installs Nim + build tools
  - Re-executes itself with Nim compiler
- Then `fmt: off` again protects the syntax below
- **5:** `[` → Start of an empty list literal
- **6:** `]#` → End of list, followed by `#` comment

### Components 7-9: The 🔥 Blasphemous Transition

```python
# 7. Nim: 🔥 blasphemous block comment begin
#[

# 8. Python: ⚠️ heretical multi-line string begin
"""

# 9. Nim: 🔥 blasphemous block comment end
]#
```

**What Nim sees:**
- **7:** `#[` → Start of another **🔥 blasphemous block comment**
- **8:** The `"""` is inside the comment, so it's ignored
- **9:** `]#` → End of blasphemous block comment

**What Python sees:**
- **7:** `#[` → Just a comment
- **8:** `"""` → Start of a **⚠️ heretical multi-line string literal**
- **9:** `]#` → Still inside the multi-line string

### Components 10-11: The ✨ Glorious Nim Block

```nim
# 10. Nim: ✨ glorious main block begin

import strutils, os

echo "🎯 Now running in Nim!"
echo "✓ Successfully bootstrapped from Python to Nim"

... Fibonacci demo code goes here ...

# 11. Nim: ✨ glorious main block end
```

**What Nim sees:**
- **10-11:** ✨ Executable Nim code. Imports, echo statements, a Fibonacci function.

**What Python sees:**
- **10-11:** Still inside the multi-line string from 8, so this is ignored string data

### Components 12-14: The 💀 Cursed Closing

```python
# 12. Nim: 💀 cursed block comment begin
#[

# 13. Python: ⚠️ heretical multi-line string end + 🤢 wretched zero-index begin
"""[0

# 14. Nim: 💀 cursed block comment end, Python: 🤢 wretched zero-index end
]#
```

**What Nim sees:**
- **12:** `#[` → Start of another **💀 cursed block comment**
- **13:** The `"""[0` is inside the comment, so it's ignored
- **14:** `]#` → End of cursed block comment

**What Python sees:**
- **12:** `#[` → Just a comment
- **13:** `"""` → End of the ⚠️ heretical multi-line string, `[0` → 🤢 Wretched zero-index into the string (returns first character)
- **14:** `]#` → End of indexing, followed by comment

The `"""[0]#` is a complete Python expression (indexing a string literal), but since it's not assigned or used, it's just ignored.

## Formatter Compatibility

The Python code passes **Ruff** linting and formatting validation. However, **Black** is incompatible because it inserts a space after `#` in comments, turning `#[` into `# [`, which breaks the Nim block comment syntax.

## Beyond Python: POSIX Shell

Our approach works with **Nim + any language** that supports:

1. Comment lines beginning with `#`
2. Any kind of block comment or block string syntax

So we also have [`shymera.nim`](./shymera.nim) — a POSIX shell script that is also a Nim program! The shell version uses Nim's `#[...]#` block comments to hide shell code, and a heredoc `<<'EOF'...EOF` (which acts like a block string) to hide Nim code from the shell.

The file can be safely validated with **shellcheck** and formatted with **shfmt** due to strategic use of `shellcheck disable`.

## (Horrible) Use Cases

### 1. **Zero-Setup Single-File Distribution**

Ship a Nim program as a single `.nim` file that runs with Python. If Nim isn't installed, the scripting layer auto-installs it:
- Detects system package manager (brew/apt/apk)
- Installs Nim and build dependencies
- Re-executes itself with Nim

Someone with or without Nim just runs `python your_app.nim` and it works.

### 2. **Cross-Language Testing**

Python sets up fixtures, then delegates to Nim for performance-critical execution. Same file with sections optimized for each language's strengths.

### 3. **Environment Flexibility**

Single file adapts to what's available:
- Python-only environment → slow implementation
- Nim environment → fast implementation of same code


## Why Does This Abomination Exist?

Because we can! Your scientists were so preoccupied with whether they could, they didn't stop to think if they should. While the practical applications are questionable, it was fun to think through! I doubt I am the first to notice this chimeric possibility with Nim, but this was done as an entertaining exercise, so I didn't want to search for prior art.
