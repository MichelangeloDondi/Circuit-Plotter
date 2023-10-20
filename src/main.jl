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

Version: 2.5
License: MIT License
"""

# ==============================================================================
# ============================ Required Packages ===============================
# ==============================================================================

    # Ensure necessary packages are added and used.
    using Pkg

    for package in [
        "LightGraphs",   # For graph data structures
        "GraphRecipes",  # For plotting the circuit (the graph)
        "Plots",         # For plotting the circuit (labels, etc.)
        "PlotlyJS"       # Plotting backend for interactivity
        ]

        # Try to load the packages
        try
            eval(Meta.parse("using $package"))

        # If any of the packages is not installed, install it
        catch
            Pkg.add(package)
            eval(Meta.parse("using $package"))
        end
    end

# ==============================================================================
# ============================== Imported Modules ==============================
# ==============================================================================

    # Module_CircuitStructures.jl provides the data structures used by the Circuit Plotter Program.
    include("Module_Circuit_Structures.jl")
    using .Circuit_Structures # Access the data structures

    # Module_Main_Function.jl provides the main function of the Circuit Plotter Program.
    include("Module_Main_Function.jl")
    using .Main_Function # Access the main function

# ==============================================================================
# ================================== Run Main ==================================
# ==============================================================================

    # Run the main function.
    main()
