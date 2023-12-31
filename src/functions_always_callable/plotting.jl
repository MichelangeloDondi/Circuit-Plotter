# ==============================================================================
# ==============================================================================
# ============================== Module: Plotting ==============================
# ==============================================================================
# ==============================================================================

"""
    Module: Plotting

Author: Michelangelo Dondi
Date: 30-10-2023
Description:
    This module provides the functions to visualize a circuit. It uses the PlotlyJS
    backend for interactivity. The module is invoked by the main of Circuit Plotter
    Program and by Module HandlingSpecialInput.

Version: 4.8
License: MIT License
        
Included modules:
- 'DataStructure' provides the data structures used by the Circuit Plotter Program.

Required packages:
- For plotting the circuit
    - `PlotlyJS`:      Interactive plotting library
    - `Plots`:         Scatter plots to represent nodes
    - `LightGraphs`:   Graph representation of the circuit
    - `GraphRecipes`:  For plotting graph structures

Constants:

    # Constants that define visual properties for the circuit visualization.
    const NODE_SIZE = 20            # Size of the nodes
    const NODE_COLOR = :skyblue     # Color of the nodes
    const NODE_FONT_SIZE = 6        # Font size for node annotations
    const EDGE_WIDTH = 2            # Width of the edges
    const EDGE_FONT_SIZE = 6        # Font size for edge annotations
    const COMPONENT_SIZE = 30       # Size of the component marker
    const COMPONENT_FONT_SIZE = 9  # Font size for component annotations
    const ALPHA = 0.92              # Transparency of the nodes and components
    const FONT = "Tahoma"           # Font for the annotations
    const FONT_COLOR = :black       # Font color for the annotations
    const PHI = 1.61803398875       # Golden ratio
    const TITLE_WIDTH = 500         # Width of the plot title

Exported functions:
- `draw_plot(circuit)`: Invoke this function to visualize a given circuit.
    
Notes:
- Function 'draw_circuit(circuit)' is called by the function 'main(circuit, edge_info)' defined in
    module 'MainFunction'.
- Function 'draw_circuit(circuit)' is called by the function '_handle_special_input(circuit, edge_info)' 
    defined in module 'HandlingSpecialInput'.
"""
module Plotting

    # ==============================================================================
    # ============================= Exported Function ==============================
    # ==============================================================================

        # Invoke this function at any time to visualize the current state of the circuit.
        export draw_plot 

    # ==============================================================================
    # ============================== Included Modules ==============================
    # ==============================================================================

        # Module 'DataStructure' provides the data structures used by the Circuit Plotter Program.
        include("../data_structure.jl")
        using .DataStructure: Node, Circuit # Access the data structures
        
    # ==============================================================================
    # ============================== Required Packages =============================
    # ==============================================================================
        
        # For plotting the circuit
        using PlotlyJS # Interactive plotting library
        using Plots: scatter, scatter!, plotlyjs, plot!, title!, xlabel!, ylabel!, xlims!, ylims!, annotate!, sizehint!, size, text # Scatter plots to represent nodes
        using LightGraphs     # Graph representation of the circuit
        using GraphRecipes    # For plotting graph structures

    # ==============================================================================
    # ================================= Constants ==================================
    # ==============================================================================

        # Constants that define visual properties for the circuit visualization.
        const NODE_SIZE = 20            # Size of the nodes
        const NODE_COLOR = :skyblue     # Color of the nodes
        const NODE_FONT_SIZE = 6        # Font size for node annotations
        const EDGE_WIDTH = 2            # Width of the edges
        const EDGE_FONT_SIZE = 6        # Font size for edge annotations
        const COMPONENT_SIZE = 30       # Size of the component marker
        const COMPONENT_FONT_SIZE = 9  # Font size for component annotations
        const ALPHA = 0.92              # Transparency of the nodes and components
        const FONT = "Tahoma"           # Font for the annotations
        const FONT_COLOR = :black       # Font color for the annotations
        const PHI = 1.61803398875       # Golden ratio
        const TITLE_WIDTH = 500         # Width of the plot title

    # ==============================================================================
    # ============================== Plotting Backend ==============================
    # ==============================================================================

        # Set plotting backend to PlotlyJS for an interactive visualization experience.
        plotlyjs()
    
    # ==============================================================================
    # ======================== Function: draw_plot(circuit) ========================
    # ==============================================================================

        """
            draw_plot(circuit) 

        This function visualizes a given circuit. It uses the PlotlyJS backend for interactivity. 
        The plot is interactive. The user can zoom in and out, pan, and hover over nodes and
        components to see their details. If an error occurs, the function provides feedback.

        Parameters:
        - `circuit`: Data structure representing the circuit.
            
        Returns:
        - nothing
        
        Notes: 
        - The function is invoked by the main of Circuit Plotter Program and by Module HandlingSpecialInput.
        - Empty plots cannot be displayed.
        """
        function draw_plot(circuit)

            # Provide feedback to the user
            println("\n\033[36mPlease wait while the circuit is being visualized...\033[0m")

            # Create an empty plot
            p = scatter([], [], markersize=NODE_SIZE, markercolor=NODE_COLOR, label=false) 

            # Try to visualize the circuit
            try
                    
                # Prepare and display the plot
                _prepare_and_display_plot(p, circuit)
                    
            # If an error occurs, provide feedback to the user and return
            catch

                # Provide feedback to the user and return
                println("""
                \033[31m
                An error occurred while visualizing the circuit.
                \033[33m
                Consider that even if empty plots can be saved, they can not be displayed.
                \033[36m
                Check if the circuit is valid and try again.
                If the problem persists, please contact the developer.\033[0m""")
                return
            end

            # Provide feedback to the user
            println("\033[32mCircuit visualization complete. \n")
            println("\033[33mYou can now interact with the plot.\033[0m")
        end

    # ==============================================================================
    # --------------- Function: _prepare_and_display_plot(p, circuit) --------------
    # ==============================================================================

        """
            _prepare_and_display_plot(p, circuit)

        This function prepares the plot object for visualization by configuring its
        properties and adding nodes, edges, and components to it. It then displays
        the plot to the user and provides feedback.

        Parameters:
        - `p`: The plot object to be modified.
        - `circuit`: Data structure representing the circuit.

        Returns:
        - nothing
            
        Notes:
        - This function is only used by the function 'draw_plot(circuit)'.
        """
        function _prepare_and_display_plot(p, circuit)
            _set_plot_labels(p)
            _set_plot_title(p, circuit)
            _add_edges_to_plot(p, circuit)
            _add_nodes_to_plot(p, circuit)
            _annotate_nodes_on_plot(p, circuit)
            _annotate_components_on_plot(p, circuit)
            _optimize_plot_dimensions(p, circuit)
            display(p)  
        end
    
    # ------------------------------------------------------------------------------
    # ------------------- Function: _set_plot_labels(p, circuit) -------------------
    # ------------------------------------------------------------------------------

        """
            _set_plot_labels(p, circuit)

        Sets the labels of the plot object.

        Parameters:
        - `p`: The plot object to be modified.
        - `circuit`: Data structure representing the circuit.

        Returns:
        - nothing

        Notes:
        - This function is only used by the function '_prepare_and_display_plot(p, circuit)'.   
        """
        function _set_plot_labels(p)
            xlabel!(p, "X")
            ylabel!(p, "Y")
        end

    # ------------------------------------------------------------------------------
    # ------------------- Function: _set_plot_title(p, circuit) --------------------
    # ------------------------------------------------------------------------------

        """
            _set_plot_title(p, circuit)

        Sets the title of the plot object.

        Parameters:
        - `p`: The plot object to be modified.
        - `circuit`: Data structure representing the circuit.

        Returns:
        - nothing

        Notes:
        - This function is only used by the function '_prepare_and_display_plot(p, circuit)'.
        """
        function _set_plot_title(p, circuit)
            N_n = nv(circuit.graph)
            N_e = ne(circuit.graph)
            N_c = length(circuit.components)
            title_text = "Circuit with $N_n node" * (N_n != 1 ? "s" : "") * ", $N_e edge" * (N_e != 1 ? "s" : "") * " and $N_c component" * (N_c != 1 ? "s" : "") * "      "
            title!(p, title_text)
        end

    # ------------------------------------------------------------------------------
    # ----------------- Function: _add_edges_to_plot(p, circuit) -------------------
    # ------------------------------------------------------------------------------

        """
            _add_edges_to_plot(p, circuit)

        Adds edges to the plot object.

        Parameters:
        - `p`: The plot object to be modified.
        - `circuit`: Data structure representing the circuit.

        Returns:
        - nothing

        Notes:
        - This function is only used by the function '_prepare_and_display_plot(p, circuit)'.
        - This function uses the GraphRecipes package to plot the edges of the circuit.   
        """
        function _add_edges_to_plot(p, circuit)
            if hasfield(typeof(circuit), :graph) && ne(circuit.graph) > 0
                adj_matrix = adjacency_matrix(circuit.graph)
                graphplot!(p, adj_matrix,
                        x = [node.x for node in circuit.nodes],
                        y = [node.y for node in circuit.nodes],
                        nodecolor = :transparent,
                        nodeshape = :circle,
                        nodesize = 0,
                        linewidth = EDGE_WIDTH,
                        curves = false)
            end
        end

    # ------------------------------------------------------------------------------
    # ----------------- Function: _add_nodes_to_plot(p, circuit) -------------------
    # ------------------------------------------------------------------------------

        """
            _add_nodes_to_plot(p, circuit)

        Adds nodes to the plot object.

        Parameters:
        - `p`: The plot object to be modified.
        - `circuit`: Data structure representing the circuit.

        Returns:
        - nothing

        Notes:
        - This function is only used by the function '_prepare_and_display_plot(p, circuit)'.
        """
        function _add_nodes_to_plot(p, circuit)
            scatter!(p, [node.x for node in circuit.nodes], [node.y for node in circuit.nodes],
                    markersize=NODE_SIZE, markercolor=NODE_COLOR, markeralpha=ALPHA, label=false)
        end

    # ------------------------------------------------------------------------------
    # ---------------- Function: _annotate_nodes_on_plot(p, circuit) ---------------
    # ------------------------------------------------------------------------------

        """
            _annotate_nodes_on_plot(p, circuit)

        Adds annotations to the plot object for each node.

        Parameters:
        - `p`: The plot object to be modified.
        - `circuit`: Data structure representing the circuit.

        Returns:
        - nothing
            
        Notes:
        - This function is only used by the function '_prepare_and_display_plot(p, circuit)'.
        """
        function _annotate_nodes_on_plot(p, circuit)
            for node in circuit.nodes
                annotate!(p, node.x, node.y,
                        text("<b>N$(node.id)<br>($(node.x),$(node.y))</b>", NODE_FONT_SIZE, :center, :red, FONT))
            end
        end
    
    # ------------------------------------------------------------------------------
    # ------------- Function: _annotate_components_on_plot(p, circuit) -------------
    # ------------------------------------------------------------------------------

        """
            _annotate_components_on_plot(p, circuit)

        Adds annotations to the plot object for each component.

        Parameters:
        - `p`: The plot object to be modified.
        - `circuit`: Data structure representing the circuit.

        Returns:
        - nothing
            
        Notes:
        - This function is only used by the function '_prepare_and_display_plot(p, circuit)'.
        """
        function _annotate_components_on_plot(p, circuit)
            for component in circuit.components
                _mark_component_position(p, circuit, component)
                _label_component_details(p, circuit, component)
            end
        end
    
    # ========= Function: _mark_component_position(p, circuit, component) ==========

        """
            _mark_component_position(p, circuit, component)

        Marks the midpoint of a component on the plot object.

        Parameters:
        - `p`: The plot object to be modified.
        - `circuit`: Data structure representing the circuit.
        - `component`: The component to be marked.

        Returns:
        - nothing

        Notes:
        - This function is only used by the function '_annotate_components_on_plot(p, circuit)'.
        """
        function _mark_component_position(p, circuit, component)
            mid_x, mid_y = _calculate_midpoint_of_component(circuit, component)
            scatter!(p, [mid_x], [mid_y], markersize=COMPONENT_SIZE, markercolor=:white,
                    markerstrokecolor=:black, markeralpha=ALPHA, markerstrokewidth=2, label=false)
        end
    
    
    # ------- Function: _calculate_midpoint_of_component(circuit, component) -------

        """
            _calculate_midpoint_of_component(circuit, component)

        Calculates the midpoint of a component.

        Parameters:
        - `circuit`: Data structure representing the circuit.
        - `component`: The component to be marked.

        Returns:
        - `mid_x`: The X coordinate of the midpoint.
        - `mid_y`: The Y coordinate of the midpoint.

        Notes:
        - This function is only used by the function '_mark_component_position(p, circuit, component)'.
        """
        function _calculate_midpoint_of_component(circuit, component)
            mid_x = (circuit.nodes[component.start_node].x + circuit.nodes[component.end_node].x) / 2
            mid_y = (circuit.nodes[component.start_node].y + circuit.nodes[component.end_node].y) / 2
            return mid_x, mid_y
        end

    # ========= Function: _label_component_details(p, circuit, component) ==========

        """
            _label_component_details(p, circuit, component)

        Adds annotations to the plot object for a component.

        Parameters:
        - `p`: The plot object to be modified.
        - `circuit`: Data structure representing the circuit.
        - `component`: The component to be labeled.

        Returns:
        - nothing
            
        Notes:
        - This function is only used by the function '_annotate_components_on_plot(p, circuit)'.
        """
        function _label_component_details(p, circuit, component)
            mid_x, mid_y = _calculate_midpoint_of_component(circuit, component)
            annotate!(p, mid_x, mid_y, text("<b>E$(component.id)<br><br>(N$(component.start_node)⟶N$(component.end_node))</b>", EDGE_FONT_SIZE, :center, :darkgreen, "Tahoma"))
            annotate!(p, mid_x, mid_y, text("<b>$(component.details)</b>", COMPONENT_FONT_SIZE, :center, :dodgerblue, FONT))
        end

    # ------------------------------------------------------------------------------
    # ------------- Function: _optimize_plot_dimensions(p, circuit) ----------------
    # ------------------------------------------------------------------------------

        """
            _optimize_plot_dimensions(p, circuit)

        Optimizes the plot dimensions and axis limits based on the circuit's data for enhanced clarity.
        This function dynamically adjusts the dimensions of the plot and its axis limits.
        It calculates appropriate padding based on the circuit's nodes, ensuring no node
        is too close to the plot's border. Additionally, it checks the range of x and y coordinates
        to determine the plot's layout (portrait or landscape) for best fit. Finally, it sets the
        plot's dimensions and axis limits accordingly.

        Parameters:
        - `p`: The plot object to be modified.
        - `circuit`: Data structure representing the circuit.

        Returns:
        - nothing

        Notes:
        - This function is only used by the function '_prepare_and_display_plot(p, circuit)'.
        """
        function _optimize_plot_dimensions(p, circuit)

            # Extract X and Y coordinates of nodes
            x_coords = [node.x for node in circuit.nodes]
            y_coords = [node.y for node in circuit.nodes]
            
            # Handle the special case of a single node
            if length(x_coords) == 1
                padding = 1.0  # arbitrary padding for single node
                xlims!(p, x_coords[1] - padding, x_coords[1] + padding)
                ylims!(p, y_coords[1] - padding, y_coords[1] + padding)
                return
            end

            # Golden ratio for aesthetic padding calculation
            phi = 1.61803398875
            edge_fraction = 1 / (4 * phi)

            # Calculate padding for X and Y axes based on node positions
            padding_x = edge_fraction * (maximum(x_coords) - minimum(x_coords))
            padding_y = edge_fraction * (maximum(y_coords) - minimum(y_coords))

            # Check if all nodes are aligned vertically or horizontally, and adjust padding accordingly to avoid zero range
            if maximum(x_coords) == minimum(x_coords)  # Nodes aligned vertically
                padding_x = 1.0  # arbitrary padding for vertical alignment
            elseif maximum(y_coords) == minimum(y_coords)  # Nodes aligned horizontally
                padding_y = 1.0  # arbitrary padding for horizontal alignment
            end

            # Use the largest padding for both axes for consistent appearance
            padding = max(padding_x, padding_y)

            # number of nodes = length(x_coords) = length(y_coords) = nv(circuit.graph)
            image_shortside = 200 * (nv(circuit.graph))^0.6 # arbitrary scaling factor for image size
            image_longside = PHI * image_shortside # golden ratio

            # Determine the orientation of the plot based on the ranges of X and Y coordinates
            if (maximum(x_coords) - minimum(x_coords)) < (maximum(y_coords) - minimum(y_coords))
                plot!(p, size=(max(TITLE_WIDTH, image_shortside), image_longside), sizehint=(max(TITLE_WIDTH, image_shortside), image_longside))
                xlims!(p, minimum(x_coords) - padding, maximum(x_coords) + padding)
                ylims!(p, minimum(y_coords) - padding, maximum(y_coords) + padding)
            else
                plot!(p, size=(max(TITLE_WIDTH, image_longside), image_shortside), sizehint=(max(TITLE_WIDTH, image_longside), image_shortside))
                xlims!(p, minimum(x_coords) - padding, maximum(x_coords) + padding)
                ylims!(p, minimum(y_coords) - padding, maximum(y_coords) + padding)
            end
        end
end