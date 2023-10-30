    Program: Circuit-Plotter

A user-friendly tool that allows the creation and visualization of electrical circuits.
Users can define nodes, edges and their components, with an end visualization rendered using the PlotlyJS backend for interactivity.
The current state of the circuit can be drawn at any time and its plot can be saved at any time as well.

# Author: Michelangelo Dondi

# Last update: 30-10-2023

# Last version: 4.8

# License: MIT License

# Notes:
    - The program is structured in modules, each of which is described in the corresponding file in the 'src' directory.
    - The main function of the program is defined in module 'MainFunction' and it is invoked in the 'main.jl' file.
    - The program is written in Julia, a high-level, high-performance, dynamic programming language for numerical computing.
    - The program uses this color-coding system:
        - \033[31m (Red):     Errors and failures (e.g. wrong input, etc.) 
        - \033[32m (Green):   Success and confirmation (e.g. correct input, etc.)
        - \033[33m (Yellow):  Useful information (e.g. number of nodes already defined, etc.)
        - \033[36m (Cyan):    Instructions and comunications (e.g. "Press enter to continue", etc.)
        - \033[0m  (White):   Questions and separation lines (e.g. "Do you want to continue?", etc.)

# Examples:
  In directory circuit_drawings_examples you can find some example images of circuits drawn with this program.

# Test:
For testing purposes, run 'runtests.jl' file located in the 'test' directory. You can also modify the file to test only specific parts of the program, by commenting out the functions associated to other tests.

# How to run the program:
To use the program it is recommended to have Julia version 1.8 or higher. After downloading the program, simply run the main file or send it to the REPL. It is recommended to run the main file with IntelliJ IDEA Community Edition 2023.2.1 (or higher versions) instead of sending it to the REPL. There is in fact a minor bug that has been noticed sending the file to the REPL with Visual Studio Code (September 2023 version 1.83) with Windows 11. It is related to the internal state of the REPL and it consists in the fact that the first input given to the program is not considered. Nonetheless, a part from this, no other bugs have been reported.
