# =============================================================================
# =============================================================================
# =========================== Module: DataStructure ===========================
# =============================================================================
# =============================================================================

"""
    Module: DataStructure

Dedicated to housing the data structures used by the Circuit Plotter Program.
This module simplifies the data structure definition process by providing a single file to call.

# Author: Michelangelo Dondi

# Date: 29-10-2023

# Version: 4.7

# License: MIT License

# Required packages:
    - `LightGraphs`: For graph data structures
    - `Parameters`: For defining data structures (e.g. 'Node(id=1, x=1, y=1)' instead of 'Node(1, 1, 1)')

# Included modules:
    - None

# Exported data structures:
    - `Node`: A structure that encapsulates the details of a node.
    - `EdgeInfo`: A structure that chronicles the connectivity between diverse nodes.
    - `Component`: A structure that encapsulates the details of a component.
    - `Circuit`: A structure that encapsulates the nodes, components, and their pictorial representation within the circuit.

# Notes:
    - This module is included in almost all other modules.
"""
module DataStructure

    # ==============================================================================
    # =========================== Exported Data Structure ==========================
    # ==============================================================================

        # For housing the data structures used by the Circuit Plotter Program
        export Node, EdgeInfo, Component, Circuit

    # ==============================================================================
    # ============================= Required Packages ==============================
    # ==============================================================================

        # For graph data structures
        using LightGraphs

        # For defining data structures (e.g. 'Node(id=1, x=1, y=1)' instead of 'Node(1, 1, 1)')
        using Parameters

    # ==============================================================================
    # ============================ Data Structure: Node ============================
    # ==============================================================================

        """
            mutable struct: Node

        A structure that encapsulates the details of a node.

        # Fields:
            - `id`: The unique identifier of the node.
            - `x`:  The x-coordinate of the node.
            - `y`:  The y-coordinate of the node.

        # Notes:
            - This structure is mutable because the coordinates of the nodes are updated when the user moves them.
            - This structure is defined using the `Parameters` package, which allows for the use of named arguments.
        """
        @with_kw mutable struct Node
            id::Int
            x::Int
            y::Int
        end

    # ==============================================================================
    # ========================== Data Structure: EdgeInfo ==========================
    # ==============================================================================

        """
            struct: EdgeInfo

        A structure that chronicles the connectivity between diverse nodes. 

        # Fields:
            - `edges`: A vector of tuples, where each tuple contains the unique identifiers of the nodes that are connected by an edge.

        # Notes:
            - This structure is not mutable because the edges are not updated after they are defined.
            - This structure is defined using the `Parameters` package, which allows for the use of named arguments.
        """
        @with_kw struct EdgeInfo
            edges::Vector{Tuple{Int, Int}}
        end
        
    # ==============================================================================
    # =========================== Data Structure: Component ========================
    # ==============================================================================

        """
            struct: Component

        A structure that encapsulates the details of a component.
                
        # Fields:
            - `id`: The unique identifier of the component.
            - `start_node`: The unique identifier of the node from which the component originates.
            - `end_node`: The unique identifier of the node at which the component terminates.
            - `details`: A string that describes the component.

        # Notes:
            - This structure is not mutable because the components are not updated after they are defined.
            - This structure is defined using the `Parameters` package, which allows for the use of named arguments.
        """
        @with_kw struct Component
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

        Notes:
            - This structure is mutable because the nodes can be modified or deleted by the user.
            - This structure is defined using the `Parameters` package, which allows for the use of named arguments.
        """
        @with_kw mutable struct Circuit
            nodes::Vector{Node}
            components::Vector{Component}
            graph::SimpleGraph
        end
end