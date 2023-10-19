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
Date: 19-10-2023
Description:
    A user-friendly tool that allows the creation and visualization of electrical circuits.
    Users can define nodes, components, and their connections, with an end visualization
    rendered using the PlotlyJS backend for interactivity.

Version: 2.2
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
    Pkg.add("Dates")          # For generating timestamped filenames
    
    using LightGraphs  # Data structure to represent electrical circuits as graphs

# ==============================================================================
# ============================= Data Structures ================================
# ==============================================================================
    
    println("Defining data structures...")

    """
        Node

    A structure that encapsulates the details of a node.
    """
    struct Node
        id::Int
        x::Int
        y::Int
    end

    """
        EdgeInfo

    A structure that chronicles the connectivity between diverse nodes.
    """
    mutable struct EdgeInfo
        edges::Vector{Tuple{Int, Int}}
    end

    """
        Component

    A structure that encapsulates the details of a component.
    """
    struct Component
        id::Int
        start_node::Int
        end_node::Int
        details::String
    end

    """
        Circuit

    A structure that encapsulates the nodes, components, and their pictorial
    representation within the circuit.
    """
    mutable struct Circuit
        nodes::Vector{Node}
        components::Vector{Component}
        graph::SimpleGraph
    end

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
