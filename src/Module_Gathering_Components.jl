# ==============================================================================
# ==============================================================================
# ===================== Module_Gathering_Components.jl =========================
# ==============================================================================
# ==============================================================================

"""
    Module: Gathering_Components

Author: Michelangelo Dondi
Date: 20-10-2023
Description:
    Dedicated to collecting components within the circuit.
    This module simplifies the collection process by providing a single function to call.   

Version: 2.4
License: MIT License

Exported functions:     
- `gather_components(circuit::Circuit, edge_info::EdgeInfo)`: 
        Strategically procures intricate details linked to the components within the
        circuit by engaging the user. The gathered specifics are seamlessly integrated
        into the `circuit` structure. To further aid clarity, an overview of the
        components is presented, leading to the circuit's visual representation
        integrating the newest additions.
"""
module Gathering_Components

    # ==============================================================================
    # ========================== Exported Function =================================
    # ==============================================================================

        # Invoke this function to gather the components
        export gather_components

    # ==============================================================================
    # ======================== Imported Data Structure =============================
    # ==============================================================================

        # For accessing the data structures 
        include("Module_CircuitStructures.jl")
        using .CircuitStructures

        # For housing the data structures used by the Circuit Visualization Tool
        import Main: Circuit, EdgeInfo, Component

    # ==============================================================================
    # ============================ Required Packages ===============================
    # ==============================================================================
        
        # For graph representation of the circuit
        using LightGraphs 

    # ==============================================================================
    # =========================== Imported Modules =================================
    # ==============================================================================  
        
        # For assisting the user
        include("Module_Helping.jl") 
        using .Helping: show_help  

        # For drawing the circuit
        include("Module_Plotting.jl")
        using .Plotting: draw_plot

    # ==============================================================================
    # ======================== function gather_components ==========================
    # ==============================================================================

        """
            gather_components(circuit::Circuit, edge_info::EdgeInfo) -> nothing

        Strategically procures intricate details linked to the components within the
        circuit by engaging the user. The gathered specifics are seamlessly integrated
        into the `circuit` structure. To further aid clarity, an overview of the
        components is presented, leading to the circuit's visual representation
        integrating the newest additions.

        Parameters:
        - circuit: The fundamental structure congregating nodes, components, and their 
                illustrative essence within the circuit.
        - edge_info: An organized structure cataloging the connectivity between diverse nodes.

        Returns:
        - nothing
        """
        function gather_components(circuit::Circuit, edge_info::EdgeInfo)
            collect_components_from_cmd(circuit, edge_info)
            components_recap(circuit)
            draw_plot(circuit)
        end

    # ==============================================================================
    # ================== function collect_components_from_cmd ======================
    # ==============================================================================

        """
            collect_components_from_cmd(circuit::Circuit, edge_info::EdgeInfo)

        Sequentially gathers component details from the user.
        """
        function collect_components_from_cmd(circuit::Circuit, edge_info::EdgeInfo)
            for idx in 1:length(edge_info.edges)
                _handle_edge_component(idx, circuit, edge_info)
            end
        end

        # ==============================================================================
        # ======================== Helper Functions ====================================
        # ==============================================================================

            """
                _handle_edge_component(idx::Int, circuit::Circuit, edge_info::EdgeInfo) -> nothing

            Handles the user input for a single component on a single edge.

            Parameters:
            - idx: The index of the edge in the `edge_info` structure.
            - circuit: The primary structure amalgamating nodes, components, and their 
                    illustrative representation within the circuit.
            - edge_info: The structure encapsulating the edges in the circuit.
                
            Returns:
            - nothing
            """
            function _handle_edge_component(idx::Int, circuit::Circuit, edge_info::EdgeInfo)
                decision = _ask_user_choice("\n--- Edge E$idx (N$(edge_info.edges[idx][1]) -> N$(edge_info.edges[idx][2])) ---\nAdd a component? (y/n/help/exit): ")

                if decision == "y"
                    component_details = _get_component_details()
                    push!(circuit.components, Main.Component(idx, edge_info.edges[idx][1], edge_info.edges[idx][2], component_details))
                end
            end

            """
                _ask_user_choice(prompt::String)::String 

            Prompts the user for a choice and validates it.

            Parameters:
            - prompt: The message to display to the user.
                
            Returns:
            - The user's choice.
                
            Raises:
            - Invalid choice: If the user's choice is not one of the available options.
            """
            function _ask_user_choice(prompt::String)::String
                while true
                    println(prompt)
                    flush(stdout)
                    decision = readline()

                    if decision in ["y", "n", "help", "exit"]
                        if decision == "help"
                            show_help()
                        elseif decision == "exit"
                            println("Exiting...")
                            exit(0)
                        else
                            return decision
                        end
                    else
                        println("Invalid choice. Please retry.")
                    end
                end
            end
                
            """
                _get_component_details()::String    

            Prompts the user for component details and validates them.

            Returns:
            - The component detail.
                
            Raises:
            - Invalid input: If the user's input is not valid.
            """
            function _get_component_details()::String
                println("Provide component details (e.g. 'R1 = 10 [Ω]'):")
                return readline()
                #flush(stdout)
                #return _get_input("", _validate_component_details)
            end

            # ==============================================================================
            # ================================ Component Recap =============================
            # ==============================================================================
            
            """
                components_recap(circuit::Circuit) -> nothing

            Displays a recap of the components in the circuit.

            Parameters:
            - circuit: The primary structure amalgamating nodes, components, and their 
                    illustrative representation within the circuit.

            Returns:
            - nothing

            Notes:
            - The recap is displayed in the console.

            Example:
            - Component C1 on Edge E1 (N1 -> N2): "R1 = 10 [Ω]".
            - Component C2 on Edge E2 (N2 -> N3): "R2 = 20 [Ω]".
            - Component C3 on Edge E3 (N3 -> N4): "R3 = 30 [Ω]".
            - Component C4 on Edge E4 (N4 -> N1): "R4 = 40 [Ω]".
            """
            function components_recap(circuit::Circuit)
                println("\n--- Components Overview ---")
                for comp in circuit.components
                    println("Component C$(comp.id) on Edge E$(comp.id) (N$(comp.start_node) -> N$(comp.end_node)): \"$(comp.details)\".")
                end
            end
end            
