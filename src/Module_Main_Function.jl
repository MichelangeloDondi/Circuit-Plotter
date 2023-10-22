
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

Version: 2.7
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
    # ========================= Imported Data Structure ============================
    # ==============================================================================
        
        # For housing the data structures used by the Circuit Plotter Program
        import Main: Circuit, EdgeInfo
    
    # ==============================================================================
    # ============================ Required Packages ===============================
    # ==============================================================================

        # For graph data structures
        using LightGraphs  

    # ==============================================================================
    # ============================== Included Modules ==============================
    # ==============================================================================

        # Module_Helping.jl provides helper functions for the main program.
        include("Module_Helping.jl")
        using .Helping: show_initial_greetings # Greetings and instructions

        # Module_Gathering_Nodes.jl provides functions for collecting node details.
        include("Module_Gathering_Nodes.jl")
        using .Gathering_Nodes: gather_nodes # Collect node details from the user

        # Module_Gathering_Edges_And_Components.jl provides functions for collecting edge details and component details.
        include("Module_Gathering_Edges_And_Components.jl")
        using .Gathering_Edges_And_Components: gather_edges_and_components # Collect edge details and component details from the user

        # Module_Plotting.jl provides functions for drawing the current circuit plot.
        include("Module_Plotting.jl")
        using .Plotting: draw_plot # Draw the current circuit plot
        
        # Module_Saving.jl provides functions for saving the plot displayed.
        include("Module_Saving.jl")
        using .Saving: save_plot_displayed # Save the plot displayed

    # ==============================================================================
    # ============================== Main Function =================================
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
        function main()
            
            # Greet the user and provide any necessary instructions or information.
            show_initial_greetings()

            # Initialize the data structures that will house the circuit particulars.
            circuit = Circuit([], [], SimpleGraph())
            edge_info = EdgeInfo([])

            # Gather the particulars of the nodes and provide feedback to the user.
            gather_nodes(circuit)

            # Gather the particulars of the edges and of the components and provide feedback to the user.
            gather_edges_and_components(circuit, edge_info)

            # Draw the circuit plot.
            draw_plot(circuit)

            # Save the visual representation of the user-defined circuit.
            save_plot_displayed(circuit)

            # Exit the program after the user presses Enter.
            println("Press Enter to exit...")
            readline()
        end
end