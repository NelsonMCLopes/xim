#= module xim.jl
   started at 2020-05-09
   aim to contain all software for x-ray image treatment

   to load it use...
   using Pkg
   Pkg.add(Pkg.PackageSpec(url="https://github.com/NelsonMCLopes/xim.git"))
   using xim
   xim_basics_testsum(1,2)
   xim_haircut_testsum(1,2)

=#
module xim

include("xim_basics.jl")
include("xim_haircut.jl")
# this is a file to contain the haircut code

export xim_basics_testsum
export xim_basics_load_packages
export xim_haircut_testsum

export xim_hotHaircut
export xim_coldHaircut



end # module
#
