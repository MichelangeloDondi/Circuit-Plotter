
# ==============================================================================
# ==============================================================================
# ========================== Module_Main_Function.jl ===========================
# ==============================================================================
# ==============================================================================

"""
    Module: Main_Function

Author: Michelangelo Dondi
Date: 23-10-2023
Description:
    Dedicated to housing the main function of the Circuit Visualization Tool.
    This module simplifies the main function definition process by providing a single file to call.

Version: 3.2
License: MIT License
        
Exported functions:
- `main()`: The main function of the program. It orchestrates the execution of the various modules that comprise the program, and provides the user with feedback and instructions as necessary.
"""
module Main_Function

    # ==============================================================================
    # ============================ Exported Function ===============================
    # ==============================================================================

        # main function of the program 
        export main
    
    # ==============================================================================
    # =========================== Exported Variables ===============================
    # ==============================================================================

        # Use these variables to access the data structures used by the Circuit Plotter Program
        export circuit, edge_info

    # ==============================================================================
    # ============================ Required Packages ===============================
    # ==============================================================================

        # For graph data structures
        using LightGraphs  

    # ==============================================================================
    # ============================== Included Modules ==============================
    # ==============================================================================

        # config.txt provides the configuration of the program.
        #include("config.txt")

        # Module_CircuitStructures.jl provides the data structures used by the Circuit Plotter Program.
        include("Module_Circuit_Structures.jl")
        using .Circuit_Structures: Node, EdgeInfo, Circuit, Component # Access the data structures

        # Module_Helping.jl provides helper functions for the main program.
        include("Module_Helping.jl")
        using .Helping: show_initial_greetings # Greetings and instructions
        using .Helping: show_final_greetings_asking_whether_to_save_plot_displayed # Final greetings and whether to save the plot displayed before exiting the program

        # Module_Gathering_Nodes.jl provides functions for collecting node details.
        include("Module_Gathering_Nodes.jl")
        using .Gathering_Nodes: collect_nodes_from_cmd # Collect node details from the user

        # Module_Gathering_Edges_And_Components.jl provides functions for collecting edge details and component details.
        include("Module_Gathering_Edges_And_Components.jl")
        using .Gathering_Edges_And_Components: collect_edges_and_components_from_cmd # Collect edge details and component details from the user

        # Module_Auxiliary_Functions_Circuit_Recap.jl provides auxiliary functions for recapping the circuit.
        include("Module_Auxiliary_Functions_Circuit_Recap.jl")
        using .Auxiliary_Functions_Circuit_Recap: show_circuit_recap # Recap the circuit
        
        # Module_Plotting.jl provides functions for drawing the current circuit plot.
        include("Module_Plotting.jl")
        using .Plotting: draw_plot # Draw the current circuit plot
        
        # Module_Saving.jl provides functions for saving the plot displayed.
        include("Module_Saving.jl")
        using .Saving: save_plot_displayed # Save the plot displayed
    
    # ==============================================================================
    # ========================= Initialize Data Structures =========================
    # ==============================================================================

        # Initialize the data structures that will house the circuit particulars.
        circuit = Circuit([], [], SimpleGraph())
        edge_info = EdgeInfo([])
           
    # ==============================================================================
    # =========================== Auxiliary Functions ==============================
    # ==============================================================================

        """
            read_configuration(file_path::String) -> Tuple{Node[], Tuple{Int, Int}[], Component[]}
            
        Reads the configuration from the file specified by the file path.

        Parameters:
        - file_path: The path to the file from which to read the configuration.

        Returns:
        - nodes: The nodes of the circuit.
        - edges: The edges of the circuit.
        - components: The components of the circuit.
        
        # Example:
        ```
        nodes, edges, components = read_configuration("config.txt")
        ```
        
        # Notes:
        - The file must be formatted as follows:
            - The first line must be "NODES".
            - The second line must be "EDGES".
            - The third line must be "COMPONENTS".
            - The fourth line must be "ID,X,Y".
            - The fifth line must be "StartNode,EndNode".
            - The sixth line must be "ID,StartNode,EndNode,Details".
            - The seventh line onwards must contain the node, edge, and component details, respectively.
        """

        function read_configuration(file_path::String)
            nodes = Node[]
            components = Component[]
            edges = Tuple{Int, Int}[]
        
            mode = nothing
            open(file_path, "r") do file
                for line in eachline(file)
                    line = strip(line)
                    if line == "NODES"
                        mode = :node
                    elseif line == "EDGES"
                        mode = :edge
                    elseif line == "COMPONENTS"
                        mode = :component
                    elseif mode == :node && line != "ID,X,Y"
                        id, x, y = split(line, ",")
                        push!(nodes, Node(parse(Int, id), parse(Int, x), parse(Int, y)))
                    elseif mode == :edge && line != "StartNode,EndNode"
                        start_node, end_node = split(line, ",")
                        push!(edges, (parse(Int, start_node), parse(Int, end_node)))
                    elseif mode == :component && line != "ID,StartNode,EndNode,Details"
                        id, start_node, end_node, details = split(line, ",")
                        push!(components, Component(parse(Int, id), parse(Int, start_node), parse(Int, end_node), details))
                    end
                end
            end
        
            return nodes, edges, components
        end

    # ==============================================================================
    # =============================== Main Function ================================
    # ==============================================================================

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
        function main(circuit, edge_info)
            
            # Greet the user and provide any necessary instructions or information.
            show_initial_greetings()

            print("Print working directory: ", pwd())

            config_path = joinpath(dirname(@__FILE__), "config.txt")
            nodes, edges, components = read_configuration(config_path)

            # Add nodes to the circuit
            circuit.nodes = nodes

            # Add edges to the edge_info
            edge_info.edges = edges

            # Add components to the circuit
            circuit.components = components

            # Construct the SimpleGraph based on the edges
            g = SimpleGraph(maximum(edge for edge in edges))
            for edge in edges
                add_edge!(g, edge[1], edge[2])
            end
            circuit.graph = g

            # Recap the circuit.
            show_circuit_recap(circuit, edge_info)

            # Draw the circuit plot.
            draw_plot(circuit)

            # Ask the user whether to save the plot displayed before exiting the program.
            show_final_greetings_asking_whether_to_save_plot_displayed(circuit)
        end

        #=
        function main(circuit, edge_info)
            
            # Greet the user and provide any necessary instructions or information.
            show_initial_greetings()

            # Initialize the file path to nothing.
            file_path = nothing 

            # Prompt the user for the file path if they want to read the configuration from a file.
            while true

                # Prompt the user for whether they want to read the configuration from a file.
                print("Do you want to read the configuration from a file? (y/n): ")
                input = readline()
                    
                # If the user wants to read the configuration from a file, prompt them for the file path.    
                if input == "y"
                    print("Enter the file path: ")
                    file_path = readline()
                    break

                # If the user does not want to read the configuration from a file, collect the nodes and edges from command line.
                elseif input == "n"

                    # Collect the nodes from the user.
                    collect_nodes_from_cmd(circuit)

                    # Collect the edges and components from the user.
                    collect_edges_and_components_from_cmd(circuit, edge_info)
                    break
                end
            end

            # If the user wants to read the configuration from a file, read the configuration from the file.
            if file_path !== nothing
                nodes, edges = read_configuration(file_path)
                circuit.nodes = nodes
                circuit.edges = edges
            end

            # Recap the circuit.
            show_circuit_recap(circuit, edge_info)

            # Draw the circuit plot.
            draw_plot(circuit)

            # Ask the user whether to save the plot displayed before exiting the program.
            show_final_greetings_asking_whether_to_save_plot_displayed(circuit)
        end
        =#
end