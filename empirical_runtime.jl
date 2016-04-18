include("SA.jl")
using HDF5

# n_lst = collect(8000:100:15000)
n_lst = collect(10000)
e_lst = 3*n_lst
reps = 5
t = zeros(length(n_lst),reps)

dt = replace(string(now()),"T","_")
dt = replace(dt,":","_")
dt = replace(dt,"-","_")
fname = "emp_results"
folder0 = string("empirical_results_",dt)
folder = ""
# junk run to get everyhting in memory, not sure how to fix this yet.
SA.optimize()
# now start the real testing
for i = 1:length(n_lst)

    ARGS = Array(UTF8String,7)
    ARGS[1] = "--simple_graph"
    ARGS[2] = @sprintf("-n=%d",n_lst[i])
    ARGS[3] = @sprintf("-e=%d",e_lst[i])
    ARGS[4] = "-i=100"
    ARGS[5] = "-r=0.5"
    ARGS[7] = "--no_console_output"
    for j = 1:reps
        folder = string(folder0,"__",i,"_",j)
        ARGS[6] = @sprintf("--out_folder=%s",folder)
        @printf("Run %d trial %d, n=%d, e=%d\n",i,j,n_lst[i],e_lst[i])
        t[i,j] = SA.optimize(ARGS)
    end
    h5open(string(joinpath(folder,string(fname,"_data")),".h5"), "w") do file
    write(file, "t", t)  # alternatively, say "@write file A"
    write(file, "n_lst", n_lst)
    write(file, "e_lst", e_lst)
    write(file, "ARGS", ARGS)
    end
end
PyPlot.clf()
PyPlot.plot(n_lst,t,"b*")
PyPlot.title("Runtime vs. n")
PyPlot.xlabel("n")
PyPlot.ylabel("Runtime")
fname = string(fname,"_runtime",".pdf")
PyPlot.savefig(joinpath(folder,fname))
# println(t)
