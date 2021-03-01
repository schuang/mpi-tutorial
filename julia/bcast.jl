#
# MPI Broadcast examples
#
# Use Bcast! for normal MPI-style calls
# Use bcast for arbitrary data types

function bcast_array(N)
    # broadcast a float array
    # N = array length

    root = 0                            # root process ID
    pid = MPI.Comm_rank(MPI.COMM_WORLD) # this process

    if pid == root
        A = [ 10.0*i for i in 1:N ]
    else
        A = Array{Float64}(undef, N)
    end

    println("[a1] rank = $(pid) A=$A")

    MPI.Bcast!(A, root, MPI.COMM_WORLD)

    println("[a2] rank = $(pid) A=$A")
end

"""
Broadcast a Dict(). Note the use of lower-case "bcast()"
"""
function bcast_dict()
    # broadcast a dictionary
    root = 0
    pid = MPI.Comm_rank(MPI.COMM_WORLD) # this process
    if pid == root
        A = Dict("Apple" => 350, "Orange" => 232, 
                 "Grape" => 188)
    else
        A = nothing
    end
    println("[b1] rank=$pid Dict A=$A")
    A = MPI.bcast(A, root, MPI.COMM_WORLD)
    println("[b2]  rank=$pid Dict A=$A")
end

"""
Broadcast a function. Note the use of lower-case "bcast()"
"""
function bcast_fn()
    root = 0
    comm = MPI.COMM_WORLD

    if MPI.Comm_rank(comm) == root
        f = x -> x^3
    else
        f = nothing
    end

    #print("[c1] rank = $(MPI.Comm_rank(comm)), f(3) = $(Base.invokelatest(f,3))\n")

    f = MPI.bcast(f, root, comm)

    print("[c2] rank = $(MPI.Comm_rank(comm)), f(-5) = $(Base.invokelatest(f,-5))\n")

end

# main program starts

using MPI
MPI.Init()

#bcast_array(10)
bcast_dict()
bcast_fn()

MPI.Finalize()

