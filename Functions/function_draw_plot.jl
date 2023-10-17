#########################################################
    # Begin of the drawing functions
#########################################################

function draw_plot(circuit::Circuit)
    # Plot nodes as black circles
    Plots.scatter([node.x for node in circuit.nodes], [node.y for node in circuit.nodes], markersize=28, markercolor=:lightblue, label=false)
    
    display_current_plot(circuit)
end

# Displays the current plot of the circuit
function display_current_plot(circuit::Circuit)
    
    # Initialize plot with desired attributes
    plot!(title="", xlabel="X", ylabel="Y", grid=true, linecolor=:blue, antialias=true, frame=:box)
    
    # Determine the number of nodes, edges, and components
    N_n = nv(circuit.graph)
    N_e = ne(circuit.graph)
    N_c = length(circuit.components)

    node_term = N_n == 1 ? "node" : "nodes"
    edge_term = N_e == 1 ? "edge" : "edges"
    component_term = N_c == 1 ? "component" : "components"

    title!("Circuit with $(N_n) $node_term, $(N_e) $edge_term and $(N_c) $component_term")

    # Draw the edges first if the graph exists and has edges
    if :graph in fieldnames(typeof(circuit)) && ne(circuit.graph) > 0
        adj_matrix = adjacency_matrix(circuit.graph)
        graphplot!(adj_matrix, x=[node.x for node in circuit.nodes], y=[node.y for node in circuit.nodes], nodecolor=:transparent, nodealpha = 0.3, nodeshape=:circle, nodesize=0, linecolor=:blue, linewidth=2, curves=false)
    end
    
    # Draw the nodes
    scatter!([node.x for node in circuit.nodes], [node.y for node in circuit.nodes], markersize=28, markercolor=:lightblue, label=false)

    # Annotate the nodes and components
    annotate_nodes(circuit)
    annotate_components(circuit)

    adjust_plot_limits!(circuit)

    display(plot!())
end

# Annotates the nodes of the circuit
function annotate_nodes(circuit::Circuit)
    for node in circuit.nodes
        annotate!(
            node.x,
            node.y,
            text("<b>N"*string(node.id)*"<br>("*string(node.x)*","*string(node.y)*")</b>", 9, :center, :red, "Tahoma")
        )
    end
end

# Annotates the components of the circuit
function annotate_components(circuit::Circuit)
    for component in circuit.components
        mid_x = (circuit.nodes[component.start_node].x + circuit.nodes[component.end_node].x) / 2
        mid_y = (circuit.nodes[component.start_node].y + circuit.nodes[component.end_node].y) / 2

        Plots.scatter!([mid_x], [mid_y], shape=:circle, markersize=40, markercolor=:white, markerstrokecolor=:black, markerstrokewidth=2, label=false)
        annotate!(mid_x, mid_y, text("E"*string(component.id)*"<br><br>(N"*string(component.start_node)*"->N"*string(component.end_node)*")</b>", 9, :center, :darkgreen, "Tahoma"))
        annotate!(mid_x, mid_y, text("<b>"*string(component.details)*"</b>", 14, :center, :darkgreen, "Tahoma"))
    end
end

# Adjusts the plot limits to fit the circuit
function adjust_plot_limits!(circuit::Circuit)
    phi = 1.61803398875
    edge_fraction = 1/(2*phi)
    padding_x = edge_fraction*(maximum([node.x for node in circuit.nodes])-minimum([node.x for node in circuit.nodes]))
    padding_y = edge_fraction*(maximum([node.y for node in circuit.nodes])-minimum([node.y for node in circuit.nodes]))
    padding = max(padding_x, padding_y)

    if (maximum([node.x for node in circuit.nodes])-(minimum([node.x for node in circuit.nodes]))) < (maximum([node.y for node in circuit.nodes])-(minimum([node.y for node in circuit.nodes])))
        plot!(size=(618, 1000))
    else
        plot!(size=(1000, 618))
    end

    xlims!(minimum([node.x for node in circuit.nodes]) - padding, maximum([node.x for node in circuit.nodes]) + padding)
    ylims!(minimum([node.y for node in circuit.nodes]) - padding, maximum([node.y for node in circuit.nodes]) + padding)
end