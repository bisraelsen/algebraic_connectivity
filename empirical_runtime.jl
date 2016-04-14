include("SA.jl")
using HDF5

# n_lst = collect(8000:100:15000)
n_lst = collect(10000)
e_lst = 3*n_lst
reps = 1
t = zeros(length(n_lst),reps)

dt = replace(string(now()),"T","_")
dt = replace(dt,":","_")
dt = replace(dt,"-","_")
fname = string("emp_results_",dt)

# junk run to get everyhting in memory, not sure how to fix this yet.
SA.optimize()
# now start the real testing
for i = 1:length(n_lst)
    ARGS = Array(UTF8String,7)
    ARGS[1] = "--simple_graph"
    ARGS[2] = @sprintf("-n=%d",n_lst[i])
    ARGS[3] = @sprintf("-e=%d",e_lst[i])
    ARGS[4] = "-i=500"
    ARGS[5] = "-r=0.5"
    ARGS[6] = "--out_folder=empirical_results"
    ARGS[7] = "--no_console_output"
    for j = 1:reps
        @printf("Run %d trial %d, n=%d, e=%d\n",i,j,n_lst[i],e_lst[i])
        t[i,j] = SA.optimize(ARGS)
    end
    h5open(string(fname,".h5"), "w") do file
    write(file, "t", t)  # alternatively, say "@write file A"
    end
end
PyPlot.clf()
PyPlot.plot(n_lst,t,"b*")
PyPlot.title("Connectivity History")
PyPlot.xlabel("Iteration")
PyPlot.ylabel("Algebraic Connectivity")
fname = string(fname,".pdf")
PyPlot.savefig(fname)
# println(t)
