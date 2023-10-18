# ==============================================================================
# ==============================================================================
# ==============================================================================
# ======================== Program Circuit Plotter =============================
# ==============================================================================
# ==============================================================================
# ==============================================================================

"""
    Program Circuit Plotter

Author: Michelangelo Dondi
Date: 18-10-2023
Description:
    A user-friendly tool that allows the creation and visualization of electrical circuits.
    Users can define nodes, components, and their connections, with an end visualization
    rendered using the PlotlyJS backend for interactivity.

Version: 2.0
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

    A structure that encapsulates the particulars of a node.
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

    A structure that encapsulates the particulars of a component.
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
# =========================== Imported Modules ===============================
# ==============================================================================

    println("Defining imported modules...")

    # Module_Helping.jl provides helper functions for the main program.
    include("Module_Helping.jl")
    using .Helping: show_initial_greetings # Greetings and instructions

    # Module_Gathering_Nodes.jl: Provides functions for collecting node details.
    include("Module_Gathering_Nodes.jl")
    using .Gathering_Nodes: gather_nodes # Collect node details from the user

    # Module_Gathering_Edges.jl: Provides functions for collecting edge details.
    include("Module_Gathering_Edges.jl")
    using .Gathering_Edges: gather_edges # Collect edge details from the user

    # Module_Gathering_Components.jl: Provides functions for collecting component details.
    include("Module_Gathering_Components.jl")
    using .Gathering_Components: gather_components # Collect component details from the user

    # Module_Plotting.jl: Provides functions for drawing the current circuit plot.
    include("Module_Plotting.jl")
    using .Plotting: draw_plot # Draw the current circuit plot

    # Module_Saving.jl: Provides functions for saving the current plot.
    include("Module_Saving.jl")
    using .Saving: save_current_plot # Save the current plot

# ==============================================================================
# ============================== Main Function ================================
# ==============================================================================
     
    println("Defining main function...")
    """
        main() -> nothing   

    The main function of the program. It orchestrates the execution of the
    various modules that comprise the program, and provides the user with
    feedback and instructions as necessary.
        
    Parameters:
    - none
        
    Returns:
    - nothing
    """
    function main()
        
        # Greet the user and provide any necessary instructions or information.
        show_initial_greetings()

        # Initialize the data structures that will house the circuit particulars.
        circuit = Circuit([], [], SimpleGraph())
        edge_info = EdgeInfo([])

        # Gather the particulars of the nodes and provide feedback to the user.
        gather_nodes(circuit)

        # Gather the particulars of the edges and provide feedback to the user.
        gather_edges(circuit, edge_info)

        # Gather the particulars of the components and provide feedback to the user.
        gather_components(circuit, edge_info)

        # Save the visual representation of the user-defined circuit.
        save_current_plot()

        # Exit the program.
        println("Press Enter to exit...")
        readline()
    end

# ==============================================================================
# ================================= Run Main ==================================
# ==============================================================================

    println("Running main function...")
    main()
