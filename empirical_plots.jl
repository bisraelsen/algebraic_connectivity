using HDF5
using PyPlot

t = h5open("projectResults/emp_results_2016_04_09_08_49_26.h5", "r") do file
    read(file, "t")
end
n_lst = collect(100:50:2000)
PyPlot.clf()
PyPlot.plot(n_lst,t,"b*")
PyPlot.title("Runtime vs. n")
PyPlot.xlabel("n")
PyPlot.ylabel("Runtime")
xs = collect(0:1:2000)
# ys1 = 0.5e-6 * xs.^2.5
# ys2 = 1e-6 * xs.^2.5
ys1 = 1.3e-8 * xs.^3
ys2 = 2.5e-8 * xs.^3
PyPlot.plot(xs,ys1,"r")
PyPlot.plot(xs,ys2,"r")
fname = string("empirical_runtime",".pdf")
PyPlot.savefig(fname)
