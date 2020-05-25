# file xim_haircut.jl
# is a part of the xim module
# contains code to do haircut to images


#*************************************************
function xim_haircut_testsum(x,y)
  c=x+y
  c
end

#*************************************************
function xim_hotHaircut(im,r1,r2,ratio1,rd,ratio2)
  hcim = im
  hcim[20:25,:] .= 0
  hcim[:,20:25] .= 1
  s = subfunction1(50)
  hcim2 = subfunction3(hcim,s)
  return hcim2
end

#*************************************************
function xim_coldHaircut(im,r1,r2,ratio1,rd,ratio2)
  hcim = im
  hcim[50:55,:] .= 0.2
  hcim[:,50:55] .= 0.8
  s = subfunction2(40)
  hcim2 = subfunction3(hcim,s)
  return hcim2
end

#*************************************************
function subfunction1(s)
  sq = ones(Float64,(s,s));
  println("batata1")
  return sq
end

#*************************************************
function subfunction2(r)
  sq = ones(Float64,(r,2*r));
  println("batata2")
  return sq
end

#*************************************************
function subfunction3(im,ar)
  sizeIm = [size(im,1) size(im,2)]
  sizeAr = [size(ar,1) size(ar,2)]
  newim=im;
  #if (sizeIm[1]>100 && sizeIm[1]>100 && sizeIm[2]>100 && sizeIm[2]>100)
    newim[80:80+sizeAr[1]-1,80:80+sizeAr[2]-1] .= ar
  #end
  return newim
end
