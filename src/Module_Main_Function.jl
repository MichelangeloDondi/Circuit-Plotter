
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

        # Module_CircuitStructures.jl provides the data structures used by the Circuit Plotter Program.
        include("Module_Circuit_Structures.jl")
        using .Circuit_Structures: EdgeInfo, Circuit # Access the data structures

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
            collect_nodes_from_cmd(circuit, edge_info)

            # Gather the particulars of the edges and of the components and provide feedback to the user.
            collect_edges_and_components_from_cmd(circuit, edge_info)

            # Recap the circuit.
            show_circuit_recap(circuit, edge_info)

            # Draw the circuit plot.
            draw_plot(circuit)

            # Ask the user whether to save the plot displayed before exiting the program.
            show_final_greetings_asking_whether_to_save_plot_displayed(circuit)
        end
end