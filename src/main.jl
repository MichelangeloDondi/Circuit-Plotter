# ==============================================================================
# ==============================================================================
# ==============================================================================
# ========================== Program Circuit Plotter ===========================
# ==============================================================================
# ==============================================================================
# ==============================================================================

"""
    Program: Circuit_Plotter

Author: Michelangelo Dondi
Date: 20-10-2023
Description:
    A user-friendly tool that allows the creation and visualization of electrical circuits.
    Users can define nodes, components, and their connections, with an end visualization
    rendered using the PlotlyJS backend for interactivity.

Version: 2.4
License: MIT License
"""

# ==============================================================================
# ============================ Required Packages ===============================
# ==============================================================================

    println("Installing necessary packages...")

    # Ensure that all necessary Julia packages are installed before execution.
    using Pkg

    Pkg.add("LightGraphs")    # For graph data structures    
    Pkg.add("GraphRecipes")   # For plotting the circuit
    Pkg.add("Plots")          # For plotting the circuit
    Pkg.add("PlotlyJS")       # Plotting backend for the Plots package

    # For graph data structures
    using LightGraphs

# ==============================================================================
# =========================== Imported Modules =================================
# ==============================================================================

    println("Including modules in main function...")

    # Module_CircuitStructures.jl provides the data structures used by the Circuit Plotter Program.
    include("Module_CircuitStructures.jl")
    using .CircuitStructures # Access the data structures

    # Module_Main_Function.jl provides the main function of the Circuit Plotter Program.
    include("Module_Main_Function.jl")
    using .Main_Function # Access the main function

# ==============================================================================
# ================================= Run Main ===================================
# ==============================================================================

    println("Running main function...")

    # Run the main function.
    main()
