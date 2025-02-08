# ListStack-SMAL
================

This project involves the implementation of a stack data structure using linked lists in **SMAL**, an assembly language designed for the **Hawk CPU architecture** by Douglas Jones. This project was completed as part of the **CS:2630 Computer Organization** course at the **University of Iowa** in the **Spring 2024** semester. It leverages dynamic memory management with `MALLOC` and `FREE`, while incorporating exception handling for stack overflow and underflow conditions.

---

## Features
- **Polymorphism:** Demonstrates stack operations across multiple subclasses (`arraystack`, `liststack`), inheriting from the abstract `stack` class.
- **Dynamic Memory Management:** Linked list stack implementation dynamically allocates and deallocates nodes using `MALLOC` and `FREE`.
- **Exception Handling:** Custom exceptions handle stack overflow and underflow errors.
- **Demo Program:** The project includes a demonstration where "Hello, World!" is constructed by pushing and popping data from multiple stacks.
- **Machine Code:** Object (`.o`) files generated from this project showcase machine-level code, available for inspection.

---

## My Contributions
- Developed the **linked list stack** implementation in `liststack.a`.
- Implemented core stack operations (`push`, `pop`, `empty`) with dynamic memory allocation.
- Added custom exception handling for robust error management.
- Tested and debugged the integration of the linked list stack with the main demo program.

---

## Build and Run Instructions
To build and run the demo program:
1. Navigate to the project directory.
2. Run the following command:
   ```sh
   make demo
   ```
   This will compile and run the demo program. The output will demonstrate polymorphic stack behavior.

---

## Project Structure
- **README.md:** Project documentation (this file).
- **Makefile:** Automates the build process.
- **main.a:** Demo program showcasing polymorphic stack operations.
- **stack.h:** Interface for the abstract stack class (no implementation).
- **arraystack.h:** Interface for the array-based stack subclass.
- **arraystack.a:** Implementation of the array-based stack subclass.
- **liststack.h:** Interface for the linked list stack subclass.
- **liststack.a:** **(Implemented by me)** Linked list stack implementation.

---

## Known Issues
- The array stack constructor would benefit from a parameter to set the stack's capacity. This would allow each instance of the array stack to have a customizable size limit.

---

## Technologies
- **Language:** SMAL (assembly)
- **Architecture:** Hawk CPU (designed by Douglas Jones)
- **Tools:** Makefile, Hawk Emulator
