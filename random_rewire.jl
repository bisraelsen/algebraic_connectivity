using Graphs
using SimpleGraphs

function swap_edge!(g::GenericGraph,e_o::Edge,newSrc::Int,newDest::Int)
    # swap edge
    eind = edge_index(e_o)
    fwd_edge = Edge(eind,newSrc,newDest)
    rev_edge = Edge(eind,newDest,newSrc)
    g.edges[eind] = fwd_edge
    e_o_prime = Edge(eind,target(e_o),source(e_o))

    # we are moving the entire edge delete the old one
    inc_idx_f = findfirst(g.finclist[source(e_o)].==e_o,true)
    if inc_idx_f == 0
        # delete old edge at target
        inc_idx_f = findfirst(g.finclist[source(e_o)].==e_o_prime,true)
        deleteat!(g.finclist[source(e_o)],inc_idx_f)

        # delete old edge at source
        inc_idx_r = findfirst(g.finclist[target(e_o)].==e_o,true)
        deleteat!(g.finclist[source(e_o)],inc_idx_r)
    else
        # delete old edge at target
        deleteat!(g.finclist[source(e_o)],inc_idx_f)
        # delete old edge at target
        inc_idx_r = findfirst(g.finclist[target(e_o)].==e_o_prime,true)
        deleteat!(g.finclist[target(e_o)],inc_idx_r)
    end
    # add forward edge
    push!(g.finclist[newSrc],fwd_edge)

    # add reverse edge
    push!(g.finclist[newDest], rev_edge)
end
function rewire(g::GenericGraph,p::Float64;self_loops=false,parallel_edges=false,keep_vertex_source=false)
    # Inputs:
    #   g: graph of type GenericGraph
    #   p: probability of rewiring an edge
    #   self_loops: bool indicating if self loops are allowed
    #   parallel_edges: bool indicating whether multiple edges can be between two vertices
    #   keep_vertex_source: whether an edge is constrained to keep its original source
    num_e = num_edges(g)
    num_v = num_vertices(g)
    edg_list = collect(edges(g))
    max_its = 3000
    for i in 1:num_e
        r = rand()
        if r < p
            e = edg_list[i]
            if keep_vertex_source
                # keep the same source to preserve vertex edges already connected to that vertex
                source_v = source(e)
            else
                # choose random source
                source_v = rand(collect(1:num_v))
            end

            if !parallel_edges
                neighbors = collect(Graphs.out_neighbors(source_v,g))
            end
            # rewire the edge
            ok = false
            ok_sl = false
            ok_pl = false
            cand = -1
            its = 0
            while !ok && its < max_its
                its += 1
                if its > max_its
                    println("exceeded its")
                end
                cand = rand(collect(1:num_v))
                if !self_loops
                    if cand != source_v
                        ok_sl = true
                    else
                        ok_sl = false
                    end
                else
                    ok_sl = true
                end
                if !parallel_edges
                    if cand in neighbors
                        ok_pl = false
                    else
                        ok_pl = true
                    end
                else
                    ok_pl = true
                end
                ok = ok_sl && ok_pl
            end
            # println(collect(out_neighbors(source_v,g)))
            swap_edge!(g,e,source_v,cand)
            # println(collect(out_neighbors(source_v,g)))
        else
            # don't rewire this edge, move on
            continue
        end
    end
    return g
end

function rewire_old(g::SimpleGraphs.SimpleGraph,p::Float64)
    max_its = 1000
    for e in elist(g)
        s = e[1]
        t = e[2]
        if rand() < p
            vl = vlist(g)
            source_v = s
            dest_v = t
            its = 0
            while (has(g,source_v,dest_v) || source_v == dest_v) && its < max_its
                its += 1
                source_v = rand(vl)
                dest_v = rand(vl)
            end
            if its == max_its
                println("too many tries")
            end
        else
            continue
        end
        delete!(g,s,t)
        add!(g,source_v,dest_v)
    end
    return g
end

function rewire(g::SimpleGraphs.SimpleGraph,p::Float64)
    max_its = 1000
    e_lst = elist(g)
    for i in 1:NE(g)
        if rand() < p
            s = e_lst[i][1]
            t = e_lst[i][2]
            cand = i
            while cand == i
                cand = rand(1:NE(g))
            end
            c_s = cand[1]
            c_t = cand[2]

            if c_s != s && c_t != t
                delete!(g,s,t)
                delete!(g,c_s,c_t)
                add!(g,s,c_s)
                add!(g,t,c_t)
            end
        else
            continue
        end
    end
    return g
end
