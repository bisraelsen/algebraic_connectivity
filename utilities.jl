using Graphs
using SimpleGraphs

function save_json(arg,fname::ASCIIString,gname::ASCIIString)
    d = JSON.json(arg)
    f = open(@sprintf("%s",joinpath(fname,gname)),"w")
    JSON.print(f,d)
    close(f)
end

function plot_to_file(g::GenericGraph,fname::ASCIIString,gname::ASCIIString)
    write_to_file(g,fname,gname)
    pname = joinpath(fname,gname)
    run(`neato -Tpng $pname".dot" -o $pname".png"`)
end

function write_to_file(g::GenericGraph,fname::ASCIIString,gname::ASCIIString)
    if !ispath(fname)
        mkdir(fname)
    end
    f = open(@sprintf("%s.dot",joinpath(fname,gname)),"w")
    write(f,to_dot(g))
    close(f)
end

function plot_to_file(g::SimpleGraphs.SimpleGraph,fname::ASCIIString,gname::ASCIIString)
    (G,d,dinv) = convert_simple(g)
    plot_to_file(G,fname,gname)
end

function write_to_file(g::SimpleGraphs.SimpleGraph,fname::ASCIIString,gname::ASCIIString)
    (G,d,dinv) = convert_simple(g)
    write_to_file(G,fname,gname)
end

function simple_NE_sgraph(n::Int,e::Int)
    g = SimpleGraphs.SimpleGraph()
    for i = 1:e
        pts = rand(collect(1:n),2)
        add!(g,pts[1],pts[2])
    end
    if NE(g) != e
        # add in missing edges
        for i = 1:(e-NE(g))
            ns = nt = 1
            while ns == nt || has(g,ns,nt)
                ns = rand(1:NV(g))
                nt = rand(1:NV(g))
            end
            add!(g,ns,nt)
        end
    end
    return g
end

function simple_NE_graph(N,E;parallel_edges=false,self_loops=false)
    g = simple_graph(N,is_directed=false)
    for i = 1:E
        if !parallel_edges
            edge_placed = false
            while !edge_placed
                pts = rand(collect(1:N),2)
                if !(pts[2] in collect(Graphs.out_neighbors(pts[1],g)))
                    if !self_loops && (pts[2] != pts[1])
                        add_edge!(g,pts[1],pts[2])
                        edge_placed = true
                    elseif self_loops
                        add_edge!(g,pts[1],pts[2])
                        edge_placed = true
                    end
                else
                    continue
                end
            end
        else
            pts = rand(collect(1:N),2)
            add_edge!(g,pts[1],pts[2])
        end
    end
    return g
end
