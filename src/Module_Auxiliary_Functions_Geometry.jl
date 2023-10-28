# ==============================================================================
# ==============================================================================
# ================== Module: Auxiliary_Functions_Geometry ======================
# ==============================================================================
# ==============================================================================

"""
    Module Auxiliary_Functions_Geometry

Author: Michelangelo Dondi
Date: 28-10-2023
Description:
    Dedicated to housing the geometry functions used by the Circuit Visualization Tool.
    This module simplifies the geometry process by providing a single file to call.

Version: 4.2
License: MIT License

Exported functions:
- `overlapping_edges(new_edge, existing_edges, nodes)`: Checks if `new_edge` overlaps with any edge in `existing_edges`.
"""
module Auxiliary_Functions_Geometry

    # ==============================================================================
    # =========================== Exported Function ================================
    # ==============================================================================
        
        # Invoke this function to check whether a new edge is overlapping for a finite length with an existing edge.
        export overlapping_edges 

    # ==============================================================================
    # ======================= function overlapping_edges ===========================
    # ==============================================================================

        """
            overlapping_edges(new_edge, existing_edges, nodes) -> Vector{Tuple{Int, Tuple{Int, Int}}}

        Checks if `new_edge` overlaps with any edge in `existing_edges`.

        Parameters:
        - new_edge: the edge to check for overlap
        - existing_edges: the edges to check against
        - nodes: the nodes of the circuit

        Returns:
        - Vector{Tuple{Int, Tuple{Int, Int}}}: a vector of tuples containing the index of the overlapping edge and the overlapping edge itself
        - empty vector: if no overlap is detected
        """
        function overlapping_edges(new_edge, existing_edges, nodes)
            A, B = (nodes[new_edge[1]].x, nodes[new_edge[1]].y), (nodes[new_edge[2]].x, nodes[new_edge[2]].y)
            return [(index, edge) for (index, edge) in enumerate(existing_edges) if _do_overlap(A, B, (nodes[edge[1]].x, nodes[edge[1]].y), (nodes[edge[2]].x, nodes[edge[2]].y))]
        end

    # ==============================================================================
    # ---------------------------- function _do_overlap ----------------------------
    # ==============================================================================
            
        """
        _do_overlap(p1, q1, p2, q2) -> Bool

        Determines if segments (p1, q1) and (p2, q2) overlap.

        Returns:
        - true: if segments (p1, q1) and (p2, q2) overlap
        - false: otherwise
        """
        function _do_overlap(p1, q1, p2, q2)
            if _orientation(p1, q1, p2) != 0 || _orientation(p1, q1, q2) != 0
                return false
            end
            return any(_strictly_internal_to_segment(p1, p, q1) for p in [p2, q2]) ||
                any(_strictly_internal_to_segment(p2, p, q2) for p in [p1, q1])
        end

    # ------------------------------------------------------------------------------
    # ---------------------------- function _orientation ---------------------------
    # ------------------------------------------------------------------------------

        """
            _orientation(p, q, r) -> Int

        Determines the orientation of triplet (p, q, r).
        Returns:
        - 0: if collinear
        - 1: if clockwise
        - 2: if counterclockwise
        """
        function _orientation(p, q, r)
            val = (q[2] - p[2]) * (r[1] - q[1]) - (q[1] - p[1]) * (r[2] - q[2])
            return val == 0 ? 0 : (val > 0 ? 1 : 2)
        end

    # ------------------------------------------------------------------------------
    # ------------------- function _strictly_internal_to_segment -------------------
    # ------------------------------------------------------------------------------

        """
            _strictly_internal_to_segment(A, B, C)  -> Bool

        Checks if point B is strictly inside the segment AC.

        Returns:
        - true: if point B is strictly internal to the segment AC
        - false: otherwise
        """
            # Returns true if point B is strictly internal to the segment AC.
            function _strictly_internal_to_segment(A, B, C)
                # Check for a horizontal segment
                if A[2] == C[2] && A[2] == B[2]
                    return min(A[1], C[1]) < B[1] < max(A[1], C[1])
                end
            
                # Check for a vertical segment
                if A[1] == C[1] && A[1] == B[1]
                    return min(A[2], C[2]) < B[2] < max(A[2], C[2])
                end
            
                # General case
                x_within = min(A[1], C[1]) < B[1] < max(A[1], C[1])
                y_within = min(A[2], C[2]) < B[2] < max(A[2], C[2])
                return x_within && y_within
            end
end
