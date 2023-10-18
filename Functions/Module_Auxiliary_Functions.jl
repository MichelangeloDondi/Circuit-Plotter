# ==============================================================================
# ==============================================================================
# =================== Module Auxiliary_Functions_Geometry ======================
# ==============================================================================
# ==============================================================================

"""
    Module Auxiliary_Functions_Geometry

Author: Michelangelo Dondi
Date: 18-10-2023
Description:
    Dedicated to housing the geometry functions used by the Circuit Visualization Tool.
    This module simplifies the geometry process by providing a single file to call.

Version: 2.0
License: MIT License

Exported functions:
- `get_positive_integer_input(prompt::String)`: Prompts the user for a positive integer input.
- `overlapping_edges(new_edge, existing_edges, nodes)`: Checks if `new_edge` overlaps with any edge in `existing_edges`.
"""
module Auxiliary_Functions_Geometry

    # Invoke this function to check whether a new edge is overlapping for a finite length with an existing edge.
    export overlapping_edges # Edge overlap detection

    # ==============================================================================
    # ========================== Geometry Functions ================================
    # ==============================================================================

        """
            orientation(p, q, r) -> Int

        Determines the orientation of triplet (p, q, r).
        Returns:
        - 0: if collinear
        - 1: if clockwise
        - 2: if counterclockwise
        """
        function orientation(p, q, r)
            val = (q[2] - p[2]) * (r[1] - q[1]) - (q[1] - p[1]) * (r[2] - q[2])
            return val == 0 ? 0 : (val > 0 ? 1 : 2)
        end

        """
            strictlyInternalToSegment(A, B, C)  -> Bool

        Checks if point B is strictly inside the segment AC.

        Returns:
        - true: if point B is strictly internal to the segment AC
        - false: otherwise
        """
            # Returns true if point B is strictly internal to the segment AC.
            function strictlyInternalToSegment(A, B, C)
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

        """
            doOverlap(p1, q1, p2, q2) -> Bool

        Determines if segments (p1, q1) and (p2, q2) overlap.

        Returns:
        - true: if segments (p1, q1) and (p2, q2) overlap
        - false: otherwise
        """
        function doOverlap(p1, q1, p2, q2)
            if orientation(p1, q1, p2) != 0 || orientation(p1, q1, q2) != 0
                return false
            end
            return any(strictlyInternalToSegment(p1, p, q1) for p in [p2, q2]) ||
                any(strictlyInternalToSegment(p2, p, q2) for p in [p1, q1])
        end

        """
            overlapping_edges(new_edge, existing_edges, nodes) -> Vector{Tuple{Int, Tuple{Int, Int}}}

        Checks if `new_edge` overlaps with any edge in `existing_edges`.

        Returns:
        - Vector{Tuple{Int, Tuple{Int, Int}}}: a vector of tuples containing the index of the overlapping edge and the overlapping edge itself
        - empty vector: if no overlap is detected
        """
        function overlapping_edges(new_edge, existing_edges, nodes)
            A, B = (nodes[new_edge[1]].x, nodes[new_edge[1]].y), (nodes[new_edge[2]].x, nodes[new_edge[2]].y)
            return [(index, edge) for (index, edge) in enumerate(existing_edges) if doOverlap(A, B, (nodes[edge[1]].x, nodes[edge[1]].y), (nodes[edge[2]].x, nodes[edge[2]].y))]
        end
end

# ==============================================================================
# ==============================================================================
# =================== Module Auxiliary_Functions_Geometry ======================
# ==============================================================================
# ==============================================================================

"""
    Module Auxiliary_Functions_Input_Validation

Author: Michelangelo Dondi
Date: 02-10-2023
Description: 
    Dedicated to housing the input validation functions used by the Circuit Visualization Tool.
    This module simplifies the input validation process by providing a single file to call.

Version: 2.0
License: MIT License

Exported functions:
- `get_positive_integer_input(prompt::String)`: Prompts the user for a positive integer input.
"""
module Auxiliary_Functions_Input_Validation

    # Invoke this function to obtain a positive integer input
    export get_positive_integer_input # User input validation

    # ==============================================================================
    # =========================== Imported Modules ===============================
    # ==============================================================================

        # For user assistance during input
        include("Module_Helping.jl")
        using .Helping: show_help

    # ==============================================================================
    # ========================= Input Validation Functions ==========================
    # ==============================================================================

        """

            get_positive_integer_input(prompt::String) -> Int

        Prompts the user for a positive integer input.

        Returns:
        - Int: the positive integer input   
        """
        function _get_input(prompt::String, validation::Function)
            while true
                print(prompt)
                flush(stdout)
                input = readline()
                if input == "help"
                    show_help()
                elseif input == "exit"
                    println("Exiting the program.")
                    exit(0)
                else
                    val = validation(input)
                    if val !== nothing
                        return val
                    end
                end
            end
        end


        """

            _validate_integer(input::String) -> Int

        Validates if `input` is a valid integer.

        Returns:
        - Int: the integer value of `input`
        - nothing: if `input` is not a valid integer
        """
        _validate_integer(input) = try parse(Int, input) catch nothing end

        """

            get_integer_input(prompt::String) -> Int

        Prompts the user for an integer input.

        Returns:
        - Int: the integer input
        """
        function get_integer_input(prompt::String)
            return _get_input(prompt, _validate_integer)
        end

        """

            get_positive_integer_input(prompt::String) -> Int

        Prompts the user for a positive integer input.  

        Returns:    
        - Int: the positive integer input
        """
        function get_positive_integer_input(prompt::String)
            val = get_integer_input(prompt)
            while val <= 0
                println("\nEnsure you're entering a positive integer.")
                val = get_integer_input(prompt)
            end
            return val
        end
end
