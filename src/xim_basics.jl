#= module xim_basics.jl
   started at 2020-05-20
   aim to contain support functions to xim package

=#
module xim_basics

#export xim_basics_load_packages

#*************************************************
function xim_basics_testsum(x,y)
  c=x+y;
  return c
end
#*************************************************
function xim_basics_load_packages()
  using Pkg;
  Pkg.add("Images");
  Pkg.add("ImageView");
  Pkg.add("TestImages");
  Pkg.add("FileIO");
  Pkg.add("Colors");
  Pkg.add("QuartzImageIO");

  using Images, ImageView, TestImages, FileIO, Colors, QuartzImageIO;
end
#*************************************************
