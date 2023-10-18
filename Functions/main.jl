"""
    Author: Michelangelo Dondi
    Description: A tool that allows the user to draw a circuit and visualize it.
    Version: 1.2
    License: MIT License
    Title: Circuit Plotter
"""

# ----------------- Packages -----------------

    using Pkg # For adding packages

    Pkg.add("LightGraphs")
    Pkg.add("GraphRecipes")
    Pkg.add("Plots")
    Pkg.add("PlotlyJS")
    Pkg.add("Dates")

    using LightGraphs   # For graph data structure
    using GraphRecipes  # For plotting graphs
    using Plots         # For plotting
    using PlotlyJS      # For plotting
    using Dates         # For date and time

#########################################################
    # Begin of the main program
#########################################################

    # Set the backend to PlotlyJS
    plotlyjs()

# ----------------- Structures -----------------

    # Node structure
    struct Node
        id::Int
        x::Int
        y::Int
    end

    # Edge information structure
    mutable struct EdgeInfo
        edges::Vector{Tuple{Int, Int}}
    end

    # Component structure
    struct Component
        id::Int
        start_node::Int
        end_node::Int
        details::String
    end

    # Circuit structure
    mutable struct Circuit
        nodes::Vector{Node}
        components::Vector{Component}
        graph::SimpleGraph
    end

# ----------------- Other Functions -----------------

    # help functions (initial greetings and instructions are also included here)
    include("help_functions.jl") # contains module Help_Functions

    # Auxiliary functions (functions that are used by other functions)
    include("auxiliary_functions.jl") # contains module Auxiliary_Functions

# ----------------- Imported Modules -----------------

    # Auxiliary functions from auxiliary_functions.jl
    using .Auxiliary_Functions: get_positive_integer_input

    # Help functions from help_functions.jl
    using .Help_Functions: show_initial_greetings

# ----------------- IO Functions -----------------

    # User input for node coordinates
    include("function_collect_nodes.jl")

    # User input for edge information
    include("function_collect_edges.jl")

    # User input for circuit components
    include("function_collect_components.jl")

    # Display the circuit status
    include("function_draw_plot.jl")

    # Save the visualization of the circuit
    include("function_save_current_plot.jl")

# ----------------- Main -----------------

    function main()
        
        # Initial greetings and instructions
        show_initial_greetings()
        
        # Initialize the main circuit and edge information structures
        circuit = Circuit([], [], SimpleGraph())
        edge_info = EdgeInfo([])

        # User input for number of nodes 
        node_count = get_positive_integer_input("How many nodes does your circuit have? ")

        # Node input from the user
        collect_nodes_from_cmd(node_count, circuit)
        # Providing feedback to the user about the nodes that have been inserted
        nodes_recap(circuit)
        draw_plot(circuit)

        # Edge input from the user
        collect_edges_from_cmd(node_count, circuit, edge_info)
        # Providing feedback to the user about the edges that have been inserted
        edges_recap(edge_info)
        draw_plot(circuit)

        # Component input from the user
        collect_components_from_cmd(circuit, edge_info)
        # Providing feedback to the user about the components that have been inserted
        components_recap(circuit)
        draw_plot(circuit)

        # Save the visualization of the circuit
        save_current_plot()

        println("Press Enter to exit...")
        readline()

    end

# ----------------- Run -----------------

    main()