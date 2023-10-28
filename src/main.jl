
# ==============================================================================
# ==============================================================================
# ==============================================================================
# ========================= Program: Circuit-Plotter ===========================
# ==============================================================================
# ==============================================================================
# ==============================================================================

"""
Program: Circuit Plotter

Author: Michelangelo Dondi
Date: 28-10-2023
Description:
    A user-friendly tool that allows the creation and visualization of electrical circuits.
    Users can define nodes, components, and their connections, with an end visualization
    rendered using the PlotlyJS backend for interactivity.

Version: 4.4
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

    # mainfunction.jl provides the main function of the Circuit Plotter Program.
    include("mainfunction.jl")
    using .MainFunction # Access the main function

# ==============================================================================
# ===================== Function: main(circuit, edge_info) =====================
# ==============================================================================

    """
        Function: main(circuit, edge_info)

    Description:
        The main function of the program. It is called by the user to execute the program.
           
    Parameters:
    - circuit:     The circuit data structure, which is a LightGraphs.SimpleGraphs.SimpleGraphs object.
    - edge_info:   The edge information data structure, which is a LightGraphs.SimpleGraphs.SimpleGraphs object.
        
    Returns:
    - Nothing.
            
    Notes:
    - The function is structured as follows:
        - The user is welcomed to the program and the instructions are printed.
        - The user is asked to input the nodes of the circuit.
        - The user is asked to input the edges of the circuit.
        - The recaps of the circuit is printed.
        - The drawing of the circuit is printed.
        - The user is asked whether to save the circuit drawing.
        - The user is asked whether to exit the program or to start again.
    """
    main(circuit, edge_info)