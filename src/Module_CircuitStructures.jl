"""
    module CircuitStructures

Author: Michelangelo Dondi
Date: 20-10-2023
Description:
    Dedicated to housing the data structures used by the Circuit Visualization Tool.
    This module simplifies the data structure definition process by providing a single file to call.

Version: 2.5
License: MIT License

Exported data structures:
- `Node`: A structure that encapsulates the details of a node.
- `EdgeInfo`: A structure that chronicles the connectivity between diverse nodes.
- `Component`: A structure that encapsulates the details of a component.
- `Circuit`: A structure that encapsulates the nodes, components, and their pictorial representation within the circuit.
"""
module Circuit_Structures

    # ==============================================================================
    # ============================ Exported Data Structures ========================
    # ==============================================================================

        # For housing the data structures used by the Circuit Plotter Program
        export Node, EdgeInfo, Component, Circuit

    # ==============================================================================
    # ============================ Required Packages ===============================
    # ==============================================================================

        # For graph data structures
        using LightGraphs

    # ==============================================================================
    # =============================== Data Structure Node ==========================
    # ==============================================================================

        """
            struct: Node

        A structure that encapsulates the details of a node.

        Fields:
        - `id`: The unique identifier of the node.
        - `x`: The x-coordinate of the node.
        - `y`: The y-coordinate of the node.
        """
        struct Node
            id::Int
            x::Int
            y::Int
        end

    # ==============================================================================
    # =========================== Data Structure EdgeInfo ==========================
    # ==============================================================================

        """
            mutable struct: EdgeInfo

        A structure that chronicles the connectivity between diverse nodes. 

        Fields:
        - `edges`: A vector of tuples, where each tuple contains the unique identifiers of the nodes that are connected by an edge.
        """
        mutable struct EdgeInfo
            edges::Vector{Tuple{Int, Int}}
        end
        
    # ==============================================================================
    # ========================== Data Structure Component ==========================
    # ==============================================================================

        """
            struct: Component

        A structure that encapsulates the details of a component.
                
        Fields:
        - `id`: The unique identifier of the component.
        - `start_node`: The unique identifier of the node from which the component originates.
        - `end_node`: The unique identifier of the node at which the component terminates.
        - `details`: A string that describes the component.
        """
        struct Component
            id::Int
            start_node::Int
            end_node::Int
            details::String
        end

    # ==============================================================================
    # =========================== Data Structure Circuit ===========================
    # ==============================================================================

        """
            mutable struct: Circuit

        A structure that encapsulates the nodes, components, and their pictorial
        representation within the circuit.
                
        Fields:
        - `nodes`: A vector of nodes.
        - `components`: A vector of components.
        - `graph`: A graph that represents the connectivity between the nodes.
        """
        mutable struct Circuit
            nodes::Vector{Node}
            components::Vector{Component}
            graph::SimpleGraph
        end
end