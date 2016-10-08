
#---------------------------------------------------------------------------
# Program to plot resulting tile combinations
#
# Require horizontal and vertical mirror planes
# 
# Fredrik Hansteen
# 07.08.2016
#---------------------------------------------------------------------------

#############################################################
# Plot All
#############################################################
using PyPlot
using PyCall
@pyimport matplotlib.patches as patch

fin=open("out.dat", "r")
k=0
sfactor=20
dx,dy=0.5,0.5
rows,cols=21,25
cfig=figure(figsize=(5,4))
#tiletypes=[(3,3), (3,2), (2,3)]
tiletypes=[(3,3), (2,2), (3,2), (2,3)]
Nttypes=length(tiletypes)
#tilecolors=["gray", "#44ff44", "#4444ff", "#f5f566"]
tilecolors=["gray", "#ee3333", "#4444ff", "#f5f566"]
#while !eof(fin) && k<5000
while !eof(fin)
	seek(fin, rows*cols*4*k)
	k=k+1000
	c=read(fin, Int8, (rows,cols))
	accept=true
#	for r in 1:rows
#		#accept=accept&&(length(find(fn, c[r,:]))==4)
#		accept=accept&&(length(find(c[r,:].==2))==4)
#	end
#	if accept
		ax = cfig[:add_subplot](1,1,1)
		for t in 1:Nttypes
			indx=0
			while true 
				indx=findnext(c, t, indx+1)
				if indx==0
					break
				end
				y,x=ind2sub(c,indx)
				h,w=tiletypes[t]
				c[y:y+h-1,x:x+w-1]=0
				p = patch.Rectangle((sfactor*(x-1),sfactor*(y-1)), sfactor*w, sfactor*h,fc=tilecolors[t],ec="black",linewidth=2)
				ax[:add_artist](p)
			end
		end
		#imshow(c, interpolation="nearest", cmap="jet", vmin=1, vmax=4)
		#axis("equal")
		#colorbar()
		ax[:set_aspect]("equal")
		xlim(sfactor*(0-dx),sfactor*(25+dx))
		ylim(sfactor*(0-dy),sfactor*(21+dy))
		mytitle=@sprintf("Scenario %06d", k)
		title(mytitle)
		fout=@sprintf("mirrorhv21x25_4tiles_%08d.png", k)
		#savefig(fout, format="png")
		cfig[:savefig](fout, format="png")
		clf()
		println(k)
#	end
end


