module Auxiliary_Functions

    # ----------------- Exported Functions -----------------

        export get_positive_integer_input, overlapping_edges

    #########################################################
    # Begin of the auxiliary functions
    #########################################################

        # Returns the orientation of the ordered triplet (p, q, r)
        function orientation(p, q, r)
            val = (q[2] - p[2]) * (r[1] - q[1]) - (q[1] - p[1]) * (r[2] - q[2])
            if val == 0 return 0  # collinear
                return val > 0 ? 1 : 2  # clock or counterclock wise
            end
        end

        # Returns true if point B is strictly internal to the segment defined by points A and C
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

        # Returns true if the line segments p1q1 and p2q2 overlap
        function doOverlap(p1, q1, p2, q2)
            # If the lines are not collinear, they either don't overlap or overlap at a single point
            if orientation(p1, q1, p2) != 0 || orientation(p1, q1, q2) != 0
                return false
            end
        
            # If the lines are collinear, check if they share more than one point
            if strictlyInternalToSegment(p1, p2, q1) || strictlyInternalToSegment(p1, q2, q1) || 
                strictlyInternalToSegment(p2, p1, q2) || strictlyInternalToSegment(p2, q1, q2)
                return true
            end
        
            return false
        end

        # Returns a list of tuples containing the index and edge of each overlapping edge
        function overlapping_edges(new_edge, existing_edges, nodes)
            A = (nodes[new_edge[1]].x, nodes[new_edge[1]].y)
            B = (nodes[new_edge[2]].x, nodes[new_edge[2]].y)
            overlaps = []
            for (index, edge) in enumerate(existing_edges)
                C = (nodes[edge[1]].x, nodes[edge[1]].y)
                D = (nodes[edge[2]].x, nodes[edge[2]].y)
                if doOverlap(A, B, C, D)
                    push!(overlaps, (index, edge))
                end
            end
            return overlaps
        end

        # Ask the user for an integer
        function get_integer_input(prompt::String)
            while true
                print(prompt)
                flush(stdout)
                input = readline()
    
                if input == "help"
                    show_help()
                    continue
                elseif input == "exit"
                    println("Exiting the program.")
                    exit(0)
                end
    
                try
                    return parse(Int, input)
                catch
                    println("\nInvalid input. Ensure you're entering a valid integer.")
                end
            end
        end

        # Ask the user for a positive integer
        function get_positive_integer_input(prompt::String)
            while true
    
                integer = get_integer_input(prompt)
    
                if integer > 0
                    return integer
                else
                    println("\nInvalid input. Ensure you're entering a positive integer.")
                end
            end
        end
end


