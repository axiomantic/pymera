# 🐍💀👑 The Pymera

*A cursed chimera of Python and Nim stitched together with syntax hacks — an unholy program that shouldn't exist but does.*

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

The file has 13 numbered components that create the dual-language structure, outlined below.

### Components 1-5: The 😈 Unholy Python Block

```python
#!/usr/bin/env python3
#[ 1. Nim: 🚫 forbidden block comment begin
# 2. Python: 😈 unholy main block begin
# ... Python code ...
# 3. Python: 😈 unholy main block end
[# 4. Python: 🤮 abhorrent list begin
]# # 5. Nim: 🚫 forbidden block comment end, Python: 🤮 abhorrent list end
```

**What Nim sees:**
- **1:** `#[` → Start of a **🚫 forbidden block comment**
- **2-4:** Everything until the matching `]#` → Commented out (all Python code)
- **5:** `]#` → End of forbidden block comment

**What Python sees:**
- **1:** `#[` → Just a line comment ending with `[`
- **2-3:** The executable Python code
- **4:** `[` → Start of an empty list literal
- **5:** `]#` → End of list, followed by `#` comment

### Components 6-8: The 🔥 Blasphemous Transition

```python
#[ 6. Nim: 🔥 blasphemous block comment begin
""" 7. Python: ⚠️ heretical multi-line string begin
]# # 8. Nim: 🔥 blasphemous block comment end
```

**What Nim sees:**
- **6:** `#[` → Start of another **🔥 blasphemous block comment**
- **7:** The `"""` is inside the comment, so it's ignored
- **8:** `]#` → End of blasphemous block comment

**What Python sees:**
- **6:** `#[` → Just a comment
- **7:** `"""` → Start of a **⚠️ heretical multi-line string literal**
- **8:** `]#` → Still inside the multi-line string

### Components 9-10: The ✨ Glorious Nim Block

```nim
# 9. Nim: ✨ glorious main block begin
... Nim code ...
# 10. Nim: ✨ glorious main block end
```

**What Nim sees:**
- **9-10:** ✨ Executable Nim code. Imports, echo statements, a Fibonacci function.

**What Python sees:**
- **9-10:** Still inside the multi-line string from 7, so this is ignored string data

### Components 11-13: The 💀 Cursed Closing

```python
#[ # 11. Nim: 💀 cursed block comment begin
"""[0 # 12. Python: ⚠️ heretical multi-line string end + 🤢 wretched zero-index begin
]# # 13. Nim: 💀 cursed block comment end, Python: 🤢 wretched zero-index end
```

**What Nim sees:**
- **11:** `#[` → Start of another **💀 cursed block comment**
- **12:** The `"""[0` is inside the comment, so it's ignored
- **13:** `]#` → End of cursed block comment

**What Python sees:**
- **11:** `#[` → Just a comment
- **12:** `"""` → End of the ⚠️ heretical multi-line string, `[0` → 🤢 Wretched zero-index into the string (returns first character)
- **13:** `]#` → End of indexing, followed by comment

The `"""[0]#` is a complete Python expression (indexing a string literal), but since it's not assigned or used, it's just ignored.

## Formatter Compatibility

### Python Formatters

The Python code passes **ruff** and **black** linting and formatting validation (for black, after commit [https://github.com/psf/black/commit/b895a73fd4997657a80f2f3f2785c5d496739f6e](b895a73)).

The dual-language syntax blocks are marked with `# fmt: off` and `# fmt: on` to prevent reformatting that would break the syntax hacks.

### Nim Formatters

The Nim code passes **nph** formatting and validation after commit ().

The dual-language syntax blocks are marked with `#!fmt: off` and `#!fmt: on` to prevent reformatting that would break the syntax hacks.

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
