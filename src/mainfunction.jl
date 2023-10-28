
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

Version: 4.3
License: MIT License
        
Exported functions:
- `main()`: The main function of the program. It orchestrates the execution of the various modules that comprise the program, and provides the user with feedback and instructions as necessary.
"""
module MainFunction

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

        # Module_CircuitStructures.jl provides the data structures used by the Circuit Plotter Program.
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

        # Module_Auxiliary_Functions_Circuit_Recap.jl provides auxiliary functions for recapping the circuit.
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

            # Gather the particulars of the nodes.
            collect_nodes(circuit, edge_info)

            # Gather the particulars of the edges and of the components and provide feedback to the user.
            collect_edges(circuit, edge_info)

            # Recap the circuit.
            show_circuit_recap(circuit, edge_info)

            # Draw the circuit plot.
            draw_plot(circuit)

            # Ask the user whether to save the plot displayed before exiting the program.
            show_final_greetings_asking_whether_to_save_plot_displayed(circuit)
        end
end