# ----------------- Packages -----------------

    using Pkg 

    Pkg.add("LightGraphs")
    Pkg.add("GraphRecipes")
    Pkg.add("Plots")
    Pkg.add("PlotlyJS")
    Pkg.add("Dates")

    using LightGraphs   
    using GraphRecipes 
    using Plots        
    using PlotlyJS   
    using Dates        

#########################################################
    # Begin of the main program
#########################################################

    plotlyjs()

# ----------------- Structures -----------------

    struct Node
        id::Int
        x::Int
        y::Int
    end

    mutable struct EdgeInfo
        edges::Vector{Tuple{Int, Int}}
    end
    struct Component
        id::Int
        start_node::Int
        end_node::Int
        details::String
    end
    mutable struct Circuit
        nodes::Vector{Node}
        components::Vector{Component}
        graph::SimpleGraph
    end

# ----------------- Other Functions -----------------

    include("help_functions.jl") 
    include("auxiliary_functions.jl")

# ----------------- Imported Modules -----------------

    using .Auxiliary_Functions: get_positive_integer_input
    using .Help_Functions: show_initial_greetings

# ----------------- IO Functions -----------------

    include("function_collect_nodes.jl")
    include("function_collect_edges.jl")
    include("function_collect_components.jl")
    include("function_draw_plot.jl")
    include("function_save_current_plot.jl")

# ----------------- Main -----------------

    function main()
   
        show_initial_greetings()
        
        circuit = Circuit([], [], SimpleGraph())
        edge_info = EdgeInfo([])

        node_count = get_positive_integer_input("How many nodes does your circuit have? ")

        # Collect the nodes
        collect_nodes_from_cmd(node_count, circuit)
        nodes_recap(circuit)
        draw_plot(circuit)

        # Collect the edges
        collect_edges_from_cmd(node_count, circuit, edge_info)
        edges_recap(edge_info)
        draw_plot(circuit)

        # Collect the components
        collect_components_from_cmd(circuit, edge_info)
        components_recap(circuit)
        draw_plot(circuit)

        save_current_plot()

        println("Press Enter to exit...")
        readline()

    end

# ----------------- Run -----------------

    main()