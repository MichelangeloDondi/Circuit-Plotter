
# ==============================================================================
# ==============================================================================
# =========================== Module: MainFunction =============================
# ==============================================================================
# ==============================================================================

"""
    Module: MainFunction

Author: Michelangelo Dondi
Date: 28-10-2023
Description:
    Dedicated to housing the main function of the Circuit Visualization Tool.
    This module orchestrates the execution of the various modules that comprise the program,
    and provides the user with feedback and instructions as necessary.

Version: 4.5
License: MIT License
        
Exported functions:
- `main()`: The main function of the program. It orchestrates the execution of the various modules that comprise the program, and provides the user with feedback and instructions as necessary.
"""
module MainFunction

    # ==============================================================================
    # ============================== Exported Function =============================
    # ==============================================================================

        # main function of the program 
        export main
    
    # ==============================================================================
    # ============================= Exported Variables =============================
    # ==============================================================================

        # Use these variables to access the data structures used by the Circuit Plotter Program
        export circuit, edge_info

    # ==============================================================================
    # ============================== Required Packages =============================
    # ==============================================================================

        # For graph data structures
        using LightGraphs  

    # ==============================================================================
    # ============================== Included Modules ==============================
    # ==============================================================================

        # Module DataStructure provides the data structures used by the Circuit Plotter Program.
        include("datastructure.jl")
        using .DataStructure: EdgeInfo, Circuit # Access the data structures

        # Module Helping provides helper functions for the main program.
        include("functions_always_callable/helping.jl")
        using .Helping: show_initial_greetings # Greetings and instructions
        using .Helping: show_final_greetings_asking_whether_to_save_plot_displayed # Final greetings and whether to save the plot displayed before exiting the program

        # Module GatheringNodes provides functions to gather node details.
        include("nodes_management/gathering_nodes.jl")
        using .GatheringNodes: collect_nodes # Collect node details from the user

        # Module GatheringEdges provides functions for collecting edge details.
        include("edges_management/gathering_edges.jl")
        using .GatheringEdges: collect_edges # Collect edge details.

        # Module CircuitRecap provides auxiliary functions for recapping the circuit.
        include("functions_always_callable/circuit_recap.jl")
        using .CircuitRecap: show_circuit_recap # Recap the circuit
        
        # Module Plotting provides functions for drawing the current circuit plot.
        include("functions_always_callable/plotting.jl")
        using .Plotting: draw_plot # Draw the current circuit plot
        
        # Module Saving provides functions for saving the plot displayed.
        include("functions_always_callable/saving.jl")
        using .Saving: save_plot_displayed # Save the plot displayed
    
    # ==============================================================================
    # ========================= Initialize Data Structures =========================
    # ==============================================================================

        # Initialize the data structures that will house the circuit particulars.
        circuit = Circuit([], [], SimpleGraph())
        edge_info = EdgeInfo([])

    # ==============================================================================
    # ============================== Function: main() ==============================
    # ==============================================================================

        """
            main()

        The main function of the program. It orchestrates the execution of the
        various modules that comprise the program, and provides the user with
        feedback and instructions as necessary. The program starts by greeting
        the user and providing any necessary instructions or information. Then,
        the program enters a loop that allows the user to create as many circuits
        as desired. For each circuit, the program gathers the particulars of the
        nodes, then gathers the particulars of the edges and of the components,
        and provides feedback to the user. After the circuit is created, the
        program recaps the circuit, draws the circuit plot, and asks the user
        whether to create another circuit. If the user does not want to create
        another circuit, the program exits. Otherwise, the program starts over.
        Before exiting the program, the program asks the user whether to save the
        plot displayed.
            
        Parameters:
        - none
            
        Returns:
        - nothing
        """
        function main(circuit, edge_info)
            
            # Greet the user and provide any necessary instructions or information.
            show_initial_greetings()

            while true
                
                # Gather the particulars of the nodes.
                collect_nodes(circuit, edge_info)

                # Gather the particulars of the edges and of the components and provide feedback to the user.
                collect_edges(circuit, edge_info)

                # Recap the circuit.
                show_circuit_recap(circuit, edge_info)

                # Draw the circuit plot.
                draw_plot(circuit)

                println("""
                
                Do you want to create another circuit?\033[36m
                println("Type 'y' for yes or 'n' for no.
                println("If you type 'n', the program will exit.
                println("If you type 'y', or anything else, the program will start over.""")

                # Check whether the user wants to create another circuit.
                if readline(stdin) == "n"
                    break
                end
            end

            # Ask the user whether to save the plot displayed before exiting the program.
            show_final_greetings_asking_whether_to_save_plot_displayed(circuit)
        end
end