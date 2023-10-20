"""
    module CircuitStructures

Author: Michelangelo Dondi
Date: 20-10-2023
Description:
    Dedicated to housing the data structures used by the Circuit Visualization Tool.
    This module simplifies the data structure definition process by providing a single file to call.

Version: 2.4
License: MIT License

Exported data structures:
- `Node`: A structure that encapsulates the details of a node.
- `EdgeInfo`: A structure that chronicles the connectivity between diverse nodes.
- `Component`: A structure that encapsulates the details of a component.
- `Circuit`: A structure that encapsulates the nodes, components, and their pictorial representation within the circuit.
"""
module CircuitStructures

    # ==============================================================================
    # ============================ Exported Data Structures ========================
    # ==============================================================================

    # For housing the data structures used by the Circuit Visualization Tool
    export Node, EdgeInfo, Component, Circuit

    # ==============================================================================
    # ============================ Required Packages ===============================
    # ==============================================================================

    # For graph representation of the circuit
    using LightGraphs
    
    """
    Node

    A structure that encapsulates the details of a node.
    """
    struct Node
    id::Int
    x::Int
    y::Int
    end

    """
    EdgeInfo

    A structure that chronicles the connectivity between diverse nodes.
    """
    mutable struct EdgeInfo
    edges::Vector{Tuple{Int, Int}}
    end

    """
    Component

    A structure that encapsulates the details of a component.
    """
    struct Component
    id::Int
    start_node::Int
    end_node::Int
    details::String
    end

    """
    Circuit

    A structure that encapsulates the nodes, components, and their pictorial
    representation within the circuit.
    """
    mutable struct Circuit
    nodes::Vector{Node}
    components::Vector{Component}
    graph::SimpleGraph
    end
end