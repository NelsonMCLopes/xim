# file xim_haircut.jl
# is a part of the xim module
# contains code to do haircut to images


#*************************************************
function xim_haircut_testsum(x,y)
  c=x+y
  c
end

#*************************************************
#*************************************************
function xim_hotHaircut(im::Array{Float64,2},r1::Int16,r2::Int16,ratio1::Float64,rd::Int16,ratio2::Float64)
    # cuts exceptionally hot pixels (compared to a local average parametrized by r1 r2 rd ratio1 and ratio2)
    # this function uses the following functions contained in this module...
    #    ...   weigthed_average, rshape1, rshape2, pad_im
    #
    # detailed description
    # 

    si      = size(im)
    l       = Int16(2*rd+1)
    a       = Array{Float64,2}(undef,l,1); a = LinRange(-rd,rd,l)

    F1      = Array{Float64,2}(undef,2*rd+1,2*rd+1); F1      = rshape1(rd)
    avmap   = Array{Float64,2}(undef,si[1],si[2]);   avmap   = weigthed_average(Array{Float64,2}(deepcopy(im)),F1)
    ratmap  = Array{Float64,2}(undef,si[1],si[2]);   ratmap  = im./avmap
    badpix  = Array{Bool,2}(undef,si[1],si[2]);      badpix  = ratmap .>ratio2
    goodpix = ones(Bool,si[1],si[2]) .- badpix

    F2      = Array{Float64,2}(undef,2*r1+1,2*r2+1); F2      = rshape2(r1,r2)
    weight  = Array{Float64,2}(undef,si[1],si[2]);   weight  = weigthed_average(Array{Float64,2}(goodpix),F2)
    goodim  = Array{Float64,2}(undef,si[1],si[2]);   goodim  =  deepcopy(im) .* goodpix

    am      = Array{Float64,2}(undef,si[1],si[2]);   am      = weigthed_average(goodim,F2)
    bm      = Array{Float64,2}(undef,si[1],si[2]);   bm      = im ./ am .* weight

    hothair = Array{Float64,2}(undef,si[1],si[2]);   hothair = bm .> ratio1
    ok      = ones(Bool,si[1],si[2]) .- hothair

    new_im  = Array{Float64,2}(undef,si[1],si[2])
      new_im  = ok .* deepcopy(im) + hothair .* am ./ weight

    return new_im
  end

#*************************************************
function xim_coldHaircut(im,r1,r2,ratio1,rd,ratio2)

  im[50:55,:] .= 0.2
  im[:,50:55] .= 0.8
  s = subfunction2(40)
  im = subfunction4(im,s)
  return im
end


#*************************************************
#*************************************************
function weigthed_average(im::Array{Float64,2},w::Array{Float64,2})
  si = size(im)
  sw = size(w)
  padded_im = pad_im(  im , Int16((sw[1]-1)/2) , Int16((sw[2]-1)/2))

  am = zeros(Float64,si[1],si[2])
  for lili = 1:sw[1]
    for coco = 1:sw[2]
      am = am .+ w[lili,coco].*padded_im[lili:lili+si[1]-1,coco:coco+si[2]-1];
    end
  end

  return am
end
#*************************************************

#*************************************************
#*************************************************
function rshape1(R::Int16)

  p  = Array{Float64,2}(undef,7,1); p = LinRange(0.0,R,7)
  f  = Array{Float64,2}(undef,7,1); f = [0.0,0.2,1.0,1.0,0.5,0.2,0.0]
  s  = Float64((R/6)^2)
  l  = Int16(2*R+1)
  a  = Array{Float64,2}(undef,l,1); a = LinRange(-R,R,l)
  rs = sqrt.(repeat(a',l,1).^2 + repeat(a,1,l).^2)

  sh = zeros(Float64,l,l)
  sh += (rs.>=p[1]).*(rs.<p[2]) .* (f[1].+(rs.-p[1]*(f[2]-f[1])./(p[2]-p[1]))./s)
  sh += (rs.>=p[2]).*(rs.<p[3]) .* (f[2].+(rs.-p[2]*(f[3]-f[2])./(p[3]-p[2]))./s)
  sh += (rs.>=p[3]).*(rs.<p[4]) .* (f[3].+(rs.-p[3]*(f[4]-f[3])./(p[4]-p[3]))./s)
  sh += (rs.>=p[4]).*(rs.<p[5]) .* (f[4].+(rs.-p[4]*(f[5]-f[4])./(p[5]-p[4]))./s)
  sh += (rs.>=p[5]).*(rs.<p[6]) .* (f[5].+(rs.-p[5]*(f[6]-f[5])./(p[6]-p[5]))./s)
  sh += (rs.>=p[6]).*(rs.<p[7]) .* (f[6].+(rs.-p[6]*(f[7]-f[6])./(p[7]-p[6]))./s)

  sh = sh/sum(sh)
  return sh
end
#*************************************************

#*************************************************
#*************************************************
function rshape2(R1::Int16,R2::Int16)

  p  = Array{Float64,2}(undef,7,1); p = LinRange(R1,R2,7)
  f  = Array{Float64,2}(undef,7,1); f = [0.0,0.2,1.0,1.0,0.5,0.2,0.0]
  s  = Float64(((R2-R1)/6)^2)
  l  = Int16(2*R2+1)
  a  = Array{Float64,2}(undef,l,1); a = LinRange(-R2,R2,l)
  rs = sqrt.(repeat(a',l,1).^2 + repeat(a,1,l).^2)

  sh = zeros(Float64,l,l)
  sh += (rs.>=p[1]).*(rs.<p[2]) .* (f[1].+(rs.-p[1]*(f[2]-f[1])./(p[2]-p[1]))./s)
  sh += (rs.>=p[2]).*(rs.<p[3]) .* (f[2].+(rs.-p[2]*(f[3]-f[2])./(p[3]-p[2]))./s)
  sh += (rs.>=p[3]).*(rs.<p[4]) .* (f[3].+(rs.-p[3]*(f[4]-f[3])./(p[4]-p[3]))./s)
  sh += (rs.>=p[4]).*(rs.<p[5]) .* (f[4].+(rs.-p[4]*(f[5]-f[4])./(p[5]-p[4]))./s)
  sh += (rs.>=p[5]).*(rs.<p[6]) .* (f[5].+(rs.-p[5]*(f[6]-f[5])./(p[6]-p[5]))./s)
  sh += (rs.>=p[6]).*(rs.<p[7]) .* (f[6].+(rs.-p[6]*(f[7]-f[6])./(p[7]-p[6]))./s)

  sh = sh/sum(sh)
  return sh
end
#*************************************************

#*************************************************
#*************************************************
function pad_im(im::Array{Float64,2},n1::Int16,n2::Int16)
  # function to padd image im in all sides by n1 vertically and n3 horizontally
  si  = size(im)
  nim = Array{Float64,2}(undef,si[1]+2*n1,si[2]+2*n2)
  nim[n1+1:n1+si[1],:] = hcat( reverse(im[:,1:n2],dims=2) , im , reverse(im[:,si[2]-n2+1:si[2]],dims=2) )
  nim[1:n1,:] = reverse(deepcopy(nim[n1+1:2*n1,:]),dims=1)
  nim[n1+si[1]+1:2*n1+si[1],:] = reverse(nim[si[1]+1:n1+si[1],:],dims=1)
  return nim
end
#*************************************************
