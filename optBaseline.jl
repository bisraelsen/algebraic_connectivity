include("plotting.jl")
include("algConnectivity.jl")
include("growOptimalACgraph.jl")
include("utilities.jl")
fldrs = "empirical_results_2016_04_16_08_57_32__1_"
fname = "final"
num_fldrs = 5
empirical_opt_connectivities = zeros(num_fldrs)
random_connectivities = similar(empirical_opt_connectivities)
opt_connectivity=0
n = 0
edg = 0
for i = 1:num_fldrs
    out_fldr = string(fldrs,i)
    f = open(string(joinpath(out_fldr,fname),".dot"),"r")

    g = SimpleGraphs.SimpleGraph()

    for j in enumerate(eachline(f))
        if j[1] == 1 || eof(f)
            continue
        else
            inew = [parse(Int,x) for x in split(j[2],"--")]
            if length(inew) == 1
                add!(g,inew[1])
            else
                add!(g,inew[1],inew[2])
            end
        end
    end
    if i == 1
        n = NV(g)
        edg = NE(g)
        opt_connectivity = growOptimalA(n,edg)[2]
    end
    close(f)
    empirical_opt_connectivities[i] = AlgConnectivity(g,false)
end

# create random graphs and store connectivites
for i = 1:num_fldrs
    g = simple_NE_sgraph(n,edg)
    random_connectivities[i] = AlgConnectivity(g,false)
end
vals = cat(2,empirical_opt_connectivities,random_connectivities)
plot_c_box(vals,n,opt_connectivity,"","test")
