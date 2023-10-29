# ==============================================================================
# ==============================================================================
# ======================== Module: OverlappingCheck ============================
# ==============================================================================
# ==============================================================================

"""
    Module OverlappingCheck

Dedicated to providing functions for checking if a new edge overlaps with any existing edge.
This module simplifies the geometry process by providing a single file to call.

# Author: Michelangelo Dondi

# Date: 29-10-2023

# Version: 4.7

# License: MIT License

# Required packages:
    - None

# Included modules:
    - None

# Exported functions:
    - Function `overlapping_edges(new_edge, existing_edges, nodes)` checks if edge `new_edge` 
        overlaps with any edge in `existing_edges`.

# When are the exported functions invoked?
    - Function `overlapping_edges(new_edge, existing_edges, nodes)` is invoked by the function 
        `add_edge_to_circuit(node1::Int, node2::Int, edge_info, circuit)::Bool` in module 
        'GatheringEdges' when a new edge is added to the circuit.

# Notes:
    - This module provides functions for checking if a new edge overlaps with any existing edge.
"""
module OverlappingCheck

    # ==============================================================================
    # =========================== Exported Function ================================
    # ==============================================================================
        
        # Invoke this function to check whether a new edge is overlapping for a finite length with an existing edge.
        export overlapping_edges 

    # ==============================================================================
    # === Function: overlapping_edges(new_edge, existing_edges, nodes)::Vector{Tuple{Int, Tuple{Int, Int}}} ===
    # ==============================================================================

        """
            overlapping_edges(new_edge, existing_edges, nodes)::Vector{Tuple{Int, Tuple{Int, Int}}}

        Checks if `new_edge` overlaps with any edge in `existing_edges`.

        # Parameters:
            - new_edge: the edge to check for overlap
            - existing_edges: the edges to check against
            - nodes: the nodes of the circuit

        Returns:
            - Vector{Tuple{Int, Tuple{Int, Int}}}: a vector of tuples containing the index of the 
                overlapping edge and the overlapping edge itself
            - empty vector: if no overlap is detected

        Notes:
            - This function is exported.
            - This function is used by the function `add_edge_to_circuit(node1::Int, node2::Int, edge_info, circuit)::Bool` 
                in module 'GatheringEdges'.
        """
        function overlapping_edges(new_edge, existing_edges, nodes)::Vector{Tuple{Int, Tuple{Int, Int}}}
            A, B = (nodes[new_edge[1]].x, nodes[new_edge[1]].y), (nodes[new_edge[2]].x, nodes[new_edge[2]].y)
            return [(index, edge) for (index, edge) in enumerate(existing_edges) if _do_overlap(A, B, (nodes[edge[1]].x, nodes[edge[1]].y), (nodes[edge[2]].x, nodes[edge[2]].y))]
        end

    # ==============================================================================
    # ---------------- Function: _do_overlap(p1, q1, p2, q2)::Bool -----------------
    # ==============================================================================
            
        """
            _do_overlap(p1, q1, p2, q2)::Bool

        Determines if segments (p1, q1) and (p2, q2) overlap.

        # Parameters:
            - p1: the first point of the first segment
            - q1: the second point of the first segment
            - p2: the first point of the second segment
            - q2: the second point of the second segment

        # Returns:
            - true: if segments (p1, q1) and (p2, q2) overlap
            - false: otherwise

        # Function logic:
            - Check if the segments (p1, q1) and (p2, q2) overlap or not.
            - They overlap if and only if one of the following conditions is true:
                - General case: 
                    - p1, q1 and p2 are collinear and p2 lies on segment (p1, q1) or q2 lies on segment (p1, q1)
                    - p1, q1 and q2 are collinear and p2 lies on segment (p1, q1) or q2 lies on segment (p1, q1)
                    - p2, q2 and p1 are collinear and p1 lies on segment (p2, q2) or q1 lies on segment (p2, q2)
                    - p2, q2 and q1 are collinear and p1 lies on segment (p2, q2) or q1 lies on segment (p2, q2)
                - Special cases:
                    - p1, q1 and p2 are collinear and p2 lies on segment (p1, q1) or q2 lies on segment (p1, q1)
                    - p1, q1 and q2 are collinear and p2 lies on segment (p1, q1) or q2 lies on segment (p1, q1)
                    - p2, q2 and p1 are collinear and p1 lies on segment (p2, q2) or q1 lies on segment (p2, q2)
                    - p2, q2 and q1 are collinear and p1 lies on segment (p2, q2) or q1 lies on segment (p2, q2)
            - The function `_strictly_internal_to_segment(A, B, C)::Bool` is used to check if a point B is strictly internal to the segment AC.
            - The function `_orientation(p, q, r)::Int` is used to determine the orientation of triplet (p, q, r).
        
        # When is this function invoked?
            - This function is invoked by the function 
                `overlapping_edges(new_edge, existing_edges, nodes)::Vector{Tuple{Int, Tuple{Int, Int}}}`
                in module 'OverlappingCheck'.

        # Notes:
            - This function is not exported.
        """
        function _do_overlap(p1, q1, p2, q2)::Bool

            # Find the four orientations needed for general and special cases 
            if _orientation(p1, q1, p2) != 0 || _orientation(p1, q1, q2) != 0

                # General case
                return false
            end

            # Special Cases (p1, q1, p2) and (p1, q1, q2) are collinear and p2 lies on segment (p1, q1) 
            # or q2 lies on segment (p1, q1) or p1 lies on segment (p2, q2) or q1 lies on segment (p2, q2) 
            return any(_strictly_internal_to_segment(p1, p, q1) for p in [p2, q2]) ||
                any(_strictly_internal_to_segment(p2, p, q2) for p in [p1, q1])
        end

    # ------------------------------------------------------------------------------
    # -------------------- Function: _orientation(p, q, r)::Int --------------------
    # ------------------------------------------------------------------------------

        """
            _orientation(p, q, r)::Int

        Determines the orientation of triplet of points (p, q, r).

        # Parameters:
            - p: the first point of the triplet
            - q: the second point of the triplet
            - r: the third point of the triplet

        # Returns:
            - 0: if collinear
            - 1: if clockwise
            - 2: if counterclockwise

        # Function logic:
            - Compute the determinant of the matrix
            - Return 0 if collinear, 1 if clockwise, 2 if counterclockwise

        # When is this function invoked?
            - This function is invoked by the function `_do_overlap(p1, q1, p2, q2)::Bool` in module 'OverlappingCheck'.

        # Notes:
            - This function is not exported.
        """
        function _orientation(p, q, r)::Int

            # Compute the determinant of the matrix
            val = (q[2] - p[2]) * (r[1] - q[1]) - (q[1] - p[1]) * (r[2] - q[2])

            # Return 0 if collinear, 1 if clockwise, 2 if counterclockwise
            return val == 0 ? 0 : (val > 0 ? 1 : 2)
        end

    # ------------------------------------------------------------------------------
    # ----------- Function: _strictly_internal_to_segment(A, B, C)::Bool -----------
    # ------------------------------------------------------------------------------

        """
            _strictly_internal_to_segment(A, B, C)::Bool

        Checks if point B is strictly inside the segment AC.

        # Parameters:
            - A: the first point of the segment
            - B: the point to check
            - C: the second point of the segment

        # Returns:
            - true: if point B is strictly internal to the segment AC
            - false: otherwise

        # Function logic:
            - Check if point B is strictly internal to the segment AC.
            - If the segment is horizontal, check if B is on the line AC.
            - If the segment is vertical, check if B is on the line AC.
            - If the segment is neither horizontal nor vertical, check if B is on the line AC.

        # When is this function invoked?
            - This function is invoked by the function `_do_overlap(p1, q1, p2, q2)::Bool` in module 'OverlappingCheck'.

        # Notes:
            - This function is not exported.
        """
            # Returns true if point B is strictly internal to the segment AC.
            function _strictly_internal_to_segment(A, B, C)::Bool

                # Check for a horizontal segment
                if A[2] == C[2] && A[2] == B[2]

                    # Return true if B is on the line AC, false otherwise
                    return min(A[1], C[1]) < B[1] < max(A[1], C[1])
            
                # Check for a vertical segment
                elseif A[1] == C[1] && A[1] == B[1]

                    # Return true if B is on the line AC, false otherwise
                    return min(A[2], C[2]) < B[2] < max(A[2], C[2])

                # General case
                else
            
                    # Check if B is on the line AC, false otherwise
                    x_within = min(A[1], C[1]) < B[1] < max(A[1], C[1])
                    y_within = min(A[2], C[2]) < B[2] < max(A[2], C[2])

                    # Return true if B is on the line AC
                    return x_within && y_within
                end
            end
end
