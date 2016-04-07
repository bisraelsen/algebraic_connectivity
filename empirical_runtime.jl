include("SA.jl")
import JSON


n_lst = collect(100:100:200)
e_lst = 3*n_lst
reps = 5
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
    ARGS[4] = "-i=100"
    ARGS[5] = "-r=0.5"
    ARGS[6] = "--out_folder=empirical_results"
    ARGS[7] = "--no_console_output"
    for j = 1:reps
        @printf("Run %d trial %d, n=%d, e=%d\n",i,j,n_lst[i],e_lst[i])
        t[i,j] = SA.optimize(ARGS)
    end
end
SA.save_json(t,"",string(fname,".json"))
PyPlot.clf()
PyPlot.plot(n_lst,t,"b*")
PyPlot.title("Connectivity History")
PyPlot.xlabel("Iteration")
PyPlot.ylabel("Algebraic Connectivity")
fname = string(fname,".pdf")
PyPlot.savefig(fname)
# println(t)
