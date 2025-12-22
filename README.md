# TinyForge OS

**TinyForge OS** is a fun, experimental, Python-like environment written in pure **Assembly**.  
It’s *not* a real operating system — it’s a **tiny sandbox that behaves like one**, designed to explore how high-level language concepts can work in a low-level world.

---

## What is TinyForge?

TinyForge is a minimalist environment that mimics a scripting experience similar to Python —  
but everything under the hood runs in **ASM**.  
It’s built for curiosity, learning, and a bit of geeky fun.

Think of it as:
> “What if Python was written in Assembly and ran on a pretend OS?”

---

## Features

- **Python-like syntax simulation**  
  TinyForge interprets commands that *look* like Python, but executes them directly in ASM.  

- **Small & fast**  
  Written almost entirely in low-level assembly — no external dependencies.  

- **Educational playground**  
  Great for learning about parsing, interpretation, and OS fundamentals in a fun, minimal setting.  

- **Fake OS shell**  
  You can "run" fake commands, store variables, and print outputs like a tiny terminal-based OS.

---

## Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/mehmedaltug/TinyForge-OS.git
   cd TinyForge-OS
   make
   ```
2. Use as you would like:
   - You can acccess variables via $[1-9]
   - Use commands such as add, set or dec to change variable values
   - Use print statements to print your variables or use them in any other means
   - Use help command to further learn other possible commands
