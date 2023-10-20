# ==============================================================================
# ==============================================================================
# ========================== Module_Plotting.jl ================================
# ==============================================================================
# ==============================================================================

"""
    Module: Plotting

Author: Michelangelo Dondi
Date: 20-10-2023
Description:
    A module dedicated to visually representing electrical circuits. This module provides
    core functionalities for plotting the circuit components and its design. It integrates
    with the main Circuit Plotter to provide an end-to-end circuit visualization tool.

Version: 2.5
License: MIT License
        
Exported functions:
- `draw_plot(circuit::Circuit)`: Invoke this function to visualize a given circuit.
"""
module Plotting

    # ==============================================================================
    # ============================= Exported Function ==============================
    # ==============================================================================

        # Invoke this function to visualize a given circuit.
        export draw_plot 

    # ==============================================================================
    # =========================== Imported Data Structure ==========================
    # ==============================================================================

        # For housing the data structures used by the Circuit Plotter Program
        import Main: Circuit, Node
        
    # ==============================================================================
    # ============================== Required Packages =============================
    # ==============================================================================
        
        # For plotting the circuit
        using PlotlyJS # Interactive plotting library
        using Plots: scatter, scatter!, plotlyjs, plot, plot!, title!, xlabel!, ylabel!, xlims!, ylims!, annotate!, sizehint!, size, text # Scatter plots to represent nodes
        using LightGraphs     # Graph representation of the circuit
        using GraphRecipes    # For plotting graph structures
     
    # ==============================================================================
    # ============================== Constants =====================================
    # ==============================================================================

        # Constants that define visual properties for the circuit visualization.
        const NODE_SIZE = 25            # Size of the nodes
        const NODE_COLOR = :skyblue     # Color of the nodes
        const NODE_FONT_SIZE = 9        # Font size for node annotations
        const EDGE_WIDTH = 2            # Width of the edges
        const EDGE_FONT_SIZE = 9        # Font size for edge annotations
        const COMPONENT_SIZE = 50       # Size of the component marker
        const COMPONENT_FONT_SIZE = 12  # Font size for component annotations
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
    # ============================= function draw_plot =============================
    # ==============================================================================

        """
            draw_plot(circuit::Circuit) 

        Invoke this function to visualize a given circuit. This function sets up the basic
        visualization parameters and then integrates helper functions to plot nodes, edges,
        and components of the circuit.
            
        # Arguments
        - `circuit::Circuit`: A representation of the circuit to visualize.
        """
        function draw_plot(circuit::Circuit)
            println("\nPlease wait while the circuit is being visualized...")
            p = scatter([], [], markersize=NODE_SIZE, markercolor=NODE_COLOR, label=false)  # Start with an empty plot
            _prepare_and_display_plot(p, circuit)
        end 

    # ==============================================================================
    # --------------------- function _prepare_and_display_plot ---------------------
    # ==============================================================================

        """
            _prepare_and_display_plot(p, circuit::Circuit)

        This function prepares the plot object for visualization by configuring its
        properties and adding nodes, edges, and components to it. It then displays
        the plot to the user.

        # Arguments
        - `p`: The plot object to be modified.
        - `circuit::Circuit`: Data structure representing the circuit.
        """
        function _prepare_and_display_plot(p, circuit::Circuit)
            _set_plot_title(p, circuit)
            _set_plot_labels(p, circuit)
            _add_edges_to_plot(p, circuit)
            _add_nodes_to_plot(p, circuit)
            _annotate_nodes_on_plot(p, circuit)
            _annotate_components_on_plot(p, circuit)
            _optimize_plot_dimensions(p, circuit)
            display(p)
        end
    
    # ------------------------------------------------------------------------------
    # ------------------------- function _set_plot_title ---------------------------
    # ------------------------------------------------------------------------------

        """
            _set_plot_title(p, circuit::Circuit)

        Sets the title of the plot object.

        # Arguments
        - `p`: The plot object to be modified.
        - `circuit::Circuit`: Data structure representing the circuit.
        """
        function _set_plot_title(p, circuit::Circuit)
            N_n = nv(circuit.graph)
            N_e = ne(circuit.graph)
            N_c = length(circuit.components)
            title_text = "Circuit with $N_n node" * (N_n != 1 ? "s" : "") * ", $N_e edge" * (N_e != 1 ? "s" : "") * " and $N_c component" * (N_c != 1 ? "s" : "") * "      "
            title!(p, title_text)
        end
    
    # ------------------------------------------------------------------------------
    # ------------------------- function _set_plot_labels --------------------------
    # ------------------------------------------------------------------------------

        """
            _set_plot_labels(p, circuit::Circuit)

        Sets the labels of the plot object.

        # Arguments
        - `p`: The plot object to be modified.
        - `circuit::Circuit`: Data structure representing the circuit.
        """
        function _set_plot_labels(p, circuit::Circuit)
            xlabel!(p, "X")
            ylabel!(p, "Y")
        end
    
    # ------------------------------------------------------------------------------
    # ----------------------- function _add_edges_to_plot --------------------------
    # ------------------------------------------------------------------------------

        """
            _add_edges_to_plot(p, circuit::Circuit)

        Adds edges to the plot object.

        # Arguments 
        - `p`: The plot object to be modified.
        - `circuit::Circuit`: Data structure representing the circuit.
        """
        function _add_edges_to_plot(p, circuit::Circuit)
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
    # ----------------------- function _add_nodes_to_plot --------------------------
    # ------------------------------------------------------------------------------

        """
            _add_nodes_to_plot(p, circuit::Circuit)

        Adds nodes to the plot object.

        # Arguments
        - `p`: The plot object to be modified.
        - `circuit::Circuit`: Data structure representing the circuit.
        """
        function _add_nodes_to_plot(p, circuit::Circuit)
            scatter!(p, [node.x for node in circuit.nodes], [node.y for node in circuit.nodes],
                    markersize=NODE_SIZE, markercolor=NODE_COLOR, markeralpha=ALPHA, label=false)
        end

    # ------------------------------------------------------------------------------
    # ---------------------- function _annotate_nodes_on_plot ----------------------
    # ------------------------------------------------------------------------------

        """
            _annotate_nodes_on_plot(p, circuit::Circuit)

        Adds annotations to the plot object for each node.

        # Arguments
        - `p`: The plot object to be modified.
        - `circuit::Circuit`: Data structure representing the circuit.
        """
        function _annotate_nodes_on_plot(p, circuit::Circuit)
            for node in circuit.nodes
                annotate!(p, node.x, node.y,
                        text("<b>N$(node.id)<br>($(node.x),$(node.y))</b>", NODE_FONT_SIZE, :center, :red, FONT))
            end
        end
    
    # ------------------------------------------------------------------------------
    # ------------------------- _annotate_components_on_plot -----------------------
    # ------------------------------------------------------------------------------

        """
            _annotate_components_on_plot(p, circuit::Circuit)

        Adds annotations to the plot object for each component.

        # Arguments
        - `p`: The plot object to be modified.
        - `circuit::Circuit`: Data structure representing the circuit.
        """
        function _annotate_components_on_plot(p, circuit::Circuit)
            for component in circuit.components
                _mark_component_position(p, circuit, component)
                _label_component_details(p, circuit, component)
            end
        end
    
    # ===================== function _mark_component_position ======================

        """
            _mark_component_position(p, circuit::Circuit, component)

        Marks the midpoint of a component on the plot object.

        # Arguments
        - `p`: The plot object to be modified.
        - `circuit::Circuit`: Data structure representing the circuit.
        - `component`: The component to be marked.
        """
        function _mark_component_position(p, circuit::Circuit, component)
            mid_x, mid_y = _calculate_midpoint_of_component(circuit, component)
            scatter!(p, [mid_x], [mid_y], markersize=COMPONENT_SIZE, markercolor=:white,
                    markerstrokecolor=:black, markeralpha=ALPHA, markerstrokewidth=2, label=false)
        end
    
    
    # ----------------- function _calculate_midpoint_of_component ------------------

        """
            _calculate_midpoint_of_component(circuit::Circuit, component)

        Calculates the midpoint of a component.

        # Arguments
        - `circuit::Circuit`: Data structure representing the circuit.
        - `component`: The component to be marked.

        # Returns
        - `mid_x`: The X coordinate of the midpoint.
        - `mid_y`: The Y coordinate of the midpoint.
        """
        function _calculate_midpoint_of_component(circuit::Circuit, component)
            mid_x = (circuit.nodes[component.start_node].x + circuit.nodes[component.end_node].x) / 2
            mid_y = (circuit.nodes[component.start_node].y + circuit.nodes[component.end_node].y) / 2
            return mid_x, mid_y
        end

    # ===================== function _label_component_details ======================

        """
            _label_component_details(p, circuit::Circuit, component)

        Adds annotations to the plot object for a component.

        # Arguments
        - `p`: The plot object to be modified.
        - `circuit::Circuit`: Data structure representing the circuit.
        - `component`: The component to be labeled.
        """
        function _label_component_details(p, circuit::Circuit, component)
            mid_x, mid_y = _calculate_midpoint_of_component(circuit, component)
            annotate!(p, mid_x, mid_y, text("<b>E$(component.id)<br><br>(N$(component.start_node)⟶N$(component.end_node))</b>", EDGE_FONT_SIZE, :center, :darkgreen, "Tahoma"))
            annotate!(p, mid_x, mid_y, text("<b>$(component.details)</b>", COMPONENT_FONT_SIZE, :center, :dodgerblue, FONT))
        end

        # ------------------------------------------------------------------------------
        # -------------------- function _optimize_plot_dimensions ----------------------
        # ------------------------------------------------------------------------------

            """
                _optimize_plot_dimensions(p, circuit::Circuit)

            Optimizes the plot dimensions and axis limits based on the circuit's data for enhanced clarity.

            # Arguments
            - `p`: The plot object to be modified.
            - `circuit::Circuit`: Data structure representing the circuit.

            This function dynamically adjusts the dimensions of the plot and its axis limits.
            It calculates appropriate padding based on the circuit's nodes, ensuring no node
            is too close to the plot's border. Additionally, it checks the range of x and y coordinates
            to determine the plot's layout (portrait or landscape) for best fit.
            """
            function _optimize_plot_dimensions(p, circuit::Circuit)
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
                edge_fraction = 1 / (2 * phi)

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