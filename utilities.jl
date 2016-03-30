using Graphs

function plot_to_file(g::GenericGraph,fname::ASCIIString,gname::ASCIIString)
    write_to_file(g,fname,gname)
    pname = joinpath(fname,gname)
    run(`neato -Tpng $pname".dot" -o $pname".png"`)
end

function write_to_file(g::GenericGraph,fname::ASCIIString,gname::ASCIIString)
    f = open(@sprintf("%s.dot",joinpath(fname,gname)),"w")
    write(f,to_dot(g))
    close(f)
end

function simple_NE_graph(N,E;parallel_edges=false,self_loops=false)
    g = simple_graph(N,is_directed=false)
    for i = 1:E
        if !parallel_edges
            edge_placed = false
            while !edge_placed
                pts = rand(collect(1:N),2)
                if !(pts[2] in collect(out_neighbors(pts[1],g)))
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
