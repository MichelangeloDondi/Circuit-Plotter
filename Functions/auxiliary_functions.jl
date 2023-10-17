function get_integer_input(prompt::String)
    while true
        print(prompt)
        flush(stdout)
        input = readline()

        try
            return parse(Int, input)
        catch
            println("\nInvalid input. Ensure you're entering a valid integer.")
        end
    end
end

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
