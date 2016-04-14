include("SA.jl")
# using ProfileView
# Function to be run from the command line
# Profile.clear()
# @profile SA.optimize(ARGS)
SA.optimize("") #garbage run to get things into memory
SA.optimize(ARGS)
# ProfileView.view()
