
# ==============================================================================
# ==============================================================================
# ==============================================================================
# ========================== Program Circuit Plotter ===========================
# ==============================================================================
# ==============================================================================
# ==============================================================================

"""
    Circuit Plotter Program

Author: Michelangelo Dondi
Date: 28-10-2023
Description:
    A user-friendly tool that allows the creation and visualization of electrical circuits.
    Users can define nodes, components, and their connections, with an end visualization
    rendered using the PlotlyJS backend for interactivity.

Version: 4.1
License: MIT License

Notes:
- The program is structured in modules, each of which is described in the corresponding file.
- The main module is Module_Main_Function.jl, which contains the main function of the program.
- The program is written in Julia, a high-level, high-performance, dynamic programming language for numerical computing.
- The program uses this color-coding system:
    - \033[31m (Red):     Errors and failures (e.g. wrong input, etc.) 
    - \033[32m (Green):   Success and confirmation (e.g. correct input, etc.)
    - \033[33m (Yellow):  Useful information (e.g. number of nodes already defined, etc.)
    - \033[36m (Cyan):    Instructions and comunications (e.g. "Press enter to continue", etc.)
    - \033[0m  (White):   Other
"""

# ==============================================================================
# ============================ Required Packages ===============================
# ==============================================================================

    # Ensure necessary packages are added and used.
    using Pkg

    # List of packages to be installed and loaded
    for package in [
        "LightGraphs",   # For graph data structures
        "GraphRecipes",  # For plotting the circuit (the graph)
        "Plots",         # For plotting the circuit (labels, etc.)
        "PlotlyJS"       # Plotting backend for interactivity
        ]

        # Try to load the packages
        try 
            
            # Load the package
            eval(Meta.parse("using $package"))

        # If any of the packages is not installed, install it
        catch
            
            # Install the package
            Pkg.add(package)        

            # Load the package
            eval(Meta.parse("using $package"))
        end
    end

# ==============================================================================
# ============================== Included Modules ==============================
# ==============================================================================

    # Module_Main_Function.jl provides the main function of the Circuit Plotter Program.
    include("Module_Main_Function.jl")
    using .Main_Function # Access the main function

# ==============================================================================
# ================================== Run Main ==================================
# ==============================================================================

    # Run the main function.
    main(circuit, edge_info)