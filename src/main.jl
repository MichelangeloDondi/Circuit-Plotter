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

    Pkg.add("LightGraphs")    # Data structure to represent electrical circuits as graphs    
    Pkg.add("GraphRecipes")   # Plotting backend for the LightGraphs package
    Pkg.add("Plots")          # Plotting package that utilizes the GraphRecipes backend
    Pkg.add("PlotlyJS")       # Plotting backend for the Plots package

    using LightGraphs  # Data structure to represent electrical circuits as graphs

# ==============================================================================
# ============================= Data Structures ================================
# ==============================================================================
    
    println("Defining data structures...")

    # For accessing the data structures 
    include("Module_CircuitStructures.jl")
    using .CircuitStructures

# ==============================================================================
# ==================== Module Main_Function inclusion ==========================
# ==============================================================================

    println("Including main function...")
    include("Module_Main_Function.jl")
    using .Main_Function

# ==============================================================================
# ================================= Run Main ===================================
# ==============================================================================

    println("Running main function...")
    # Run the main function.
    main()
