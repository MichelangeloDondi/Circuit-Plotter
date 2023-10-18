module Help_Functions

    # ----------------- Exported Functions -----------------

        export show_initial_greetings
        export show_help

    # ----------------- Internal Functions -----------------

        # show_instructions()

        # Show the instructions
        function show_instructions()

            println()
            println("Instructions:")
            println()
            println("1. You will be guided to input nodes, edges and components of your circuit.")
            println("2. Type 'help' at any prompt to view again these instructions and to see further documentation.")
            println("3. Type 'exit' at any prompt to terminate the program.")
            println()
            println("Notes:")
            println()
            println("- The program will generate a visualization of the circuit.")
            println("- The visualization will be saved in the 'Images' folder.")
            println("- The name of the image contains the current date and time of the program execution.")
            println("- This way you can easily keep track of your images and avoid overwriting them.")
            println("- The program will automatically stop if it encounters an error.")
            println("- If you encounter any issues, please contact support.")
            println()

        end

        # Show the initial greetings and instructions
        function show_initial_greetings()
            println()
            println("-----------------------------------------------")
            println()
            println("Welcome to the Electrical Circuit Visualization Tool!")
            println("Follow the prompts to create and visualize your circuit.")
            println()
            println("-----------------------------------------------")
            println()
            # List of instructions
            show_instructions()
            println()
            println("-----------------------------------------------")
            println()
            println("You can now start creating your circuit!")
            println()
        end

        # Shows the help message
        function show_help()

            println()
            println("---------------------------------------------------")
            println("                       HELP                        ")
            println("---------------------------------------------------")
            println()
            println("Welcome to the Circuit Drawing Program!")
            println()
            println("---------------------------------------------------")
            println("                   INTRODUCTION                    ")
            println("---------------------------------------------------")
            println()
            println("This program allows you to draw a circuit.")
            println("The program has been designed having in mind electrical circuits, but other circuits and graphs can be drawn as well.")
            println("First, you will be asked to input the coordinates of the nodes.") 
            println("Secondly, you will be asked to input the edges of the circuit.")
            println("Then, you will be asked to input the components of the circuit.")
            println("Finally, the program will generate a visualization of the circuit.\n")
            println()
            println("---------------------------------------------------")
            println("                 NODE COORDINATES                ")
            println("---------------------------------------------------")
            println()
            println("The coordinates of the nodes must be integer numbers.")
            println()
            println("---------------------------------------------------")
            println("                       EDGES                       ")
            println("---------------------------------------------------")
            println()
            println("The edges are defined either by their own indexes and by the indixes of the nodes they connect.")
            println("For example, the if the first edge that has been defined is between nodes N1 and N2, it will be E1(N1->N2).")
            println("The oriented edge between nodes N1 and N2 is defined as E1(N1->N2).")
            println()
            println("---------------------------------------------------")
            println("                     COMPONENTS                    ")
            println("---------------------------------------------------")
            println()
            println("You can add components to the edges of the circuit.")
            println("If you choose to add a component, you will be asked to enter the details of the component (i.e. C1=50[nF]).")
            println("The program will ask you for each edge if you want to add a component.")
            println("If you choose not to add a component, the edge will be considered to be a section of wire.")
            println("Note that no more then one component can be added for each edge.\n")
            println("To add more than one component between two nodes, you can add dummy nodes between them.")
            println()
            println("---------------------------------------------------")
            println("                   VISUALIZATION                  ")
            println("---------------------------------------------------")
            println()
            println("The program will generate a visualization of the circuit.")
            println("The visualization will be saved in the 'Images' folder.")
            println("The name of the image contains the current date and time of the program execution.")
            println("This way you can easily keep track of your images and avoid overwriting them.")
            println()
            # List of instructions
            show_instructions()
            println("---------------------------------------------------")
            println("                   END OF HELP                     ")
            println("---------------------------------------------------")
        end
end