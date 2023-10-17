function save_current_plot()
    # Set the working directory to the directory of the script
    cd(@__DIR__)
    cd("..")

    # Create the Images directory if it doesn't exist
    if !isdir("Images")
        mkdir("Images")
    end

    Plots.savefig("Images\\circuit_plot.png")
    println("Circuit plot saved as 'Images\\circuit_plot.png'.")
end