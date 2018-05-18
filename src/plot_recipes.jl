using RecipesBase
using ColorTypes

const mygreen = RGBA{Float64}(151/255,180/255,118/255,1)
const mygreen2 = RGBA{Float64}(113/255,161/255,103/255,1)
const myblue = RGBA{Float64}(74/255,144/255,226/255,1)

@recipe function plot(p::Polygon)
    z = [p.vert; p.vert[1]]
    linecolor --> mygreen
    fillrange --> 0
    fillcolor --> mygreen
    ratio := 1
    legend := :none
    grid := false
    x := real.(z)
    y := imag.(z)
    ()
end

@recipe function plot(m::ExteriorMap)

  xmax = pop!(d, :xmax, nothing)
  xmaxc =  xmax == nothing ? 4.0 : xmax

  nspokes = pop!(d, :nspokes, nothing)
  nθ =  nspokes == nothing ? 20 : nspokes

  nrings = pop!(d, :nrings, nothing)
  nr =  nrings == nothing ? 10 : nrings

  rmax = sqrt(2)*xmaxc

  xmaxp = xmaxc*abs(m.ps.ccoeff[1])
  dxp = round(xmaxp)*0.5

  layout := (1,2)
  ratio := 1
  legend := :none
  xlims --> [(-xmaxc,xmaxc) (-xmaxp,xmaxp)]
  ylims --> [(-xmaxc,xmaxc) (-xmaxp,xmaxp)]
  framestyle := :frame
  grid := false

  # make the spokes
  dθ = 2π/nθ
  θg = 0
  nrg = 100
  rg = linspace(1,rmax,nrg)
  for jθ in 1:nθ
    ζg = collect(rg*exp(im*θg))
    zg = m(ζg)

    @series begin
      subplot := 1
      color --> mygreen2

      real.(ζg), imag.(ζg)
    end
    @series begin
      subplot := 2
      color -->  mygreen2

      real.(zg), imag.(zg)
    end
    θg += dθ
  end

  # make the rings
  dr = (rmax-1)/nr
  rg = 1

  nθg = 241
  θg = linspace(0,2π,nθg)
  for jr in 1:nr
    ζg = collect(rg*exp.(im*θg));
    zg = m(ζg)
    @series begin
      subplot := 1
      color -->  myblue

      real.(ζg), imag.(ζg)
    end
    @series begin
      subplot := 2
      color -->  myblue

      real.(zg), imag.(zg)
    end
    rg += dr
  end


end