# ----------------- Required Packages -----------------

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

# ----------------- Functions -----------------

    include("auxiliary_functions.jl")
    include("function_collect_nodes.jl")
    include("function_collect_edges.jl")
    include("function_collect_components.jl")
    include("function_draw_plot.jl")
    include("function_save_current_plot.jl")

# ----------------- Main -----------------

    function main()
   
        println()
        println("Welcome to the program Circuit Plotter!")
        println()
        println("You will be guided to input nodes, edges and components of your circuit.")
        println("The program will then plot your circuit.")
        println("The plot will be automatically saved as a .png file in the 'Images' folder.")
        println()
        
        circuit = Circuit([], [], SimpleGraph())
        edge_info = EdgeInfo([])

        node_count = get_positive_integer_input("How many nodes does your circuit have? ")

        collect_nodes_from_cmd(node_count, circuit)
        collect_edges_from_cmd(node_count, circuit, edge_info)
        collect_components_from_cmd(circuit, edge_info)

        draw_plot(circuit)

        save_current_plot()
    end

# ----------------- Run -----------------

    main()