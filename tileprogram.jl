
#---------------------------------------------------------------------------
# Program to compute tile combinations for the sitting area in Bodø
# Using recursive funcion and computing only symmetric combinations
#
# Require horizontal and vertical mirror planes
# 
# Fredrik Hansteen
# 01.08.2016
#---------------------------------------------------------------------------

#---------------------------------------------------------------------------
# Functions
#---------------------------------------------------------------------------

function tilefill!(grid::Array, i::Int, j::Int, outfile::IOStream)
	tiletypes=[(3,3), (2,2), (3,2), (2,3)]
#	tiletypes=[(3,3), (3,2), (2,3)]
#	tiletypes=[(3,3), (3,2)]
	Nt=length(tiletypes)
	Ni, Nj = size(grid)	# Any other way to obtian this
	status=0
	if j > Nj		# Check if row has been filled
		if i == Ni	# Check if this was the final row
			#println("Success!", grid)
			write(outfile, grid)
			return(-1)	# Remove previous tile
		end
		return(1)	# Signal that we need to change row
	end
	# Attempt to fit a tile if cell has not already been filled
	if grid[i,j]==0
		# Loop over all tile types 
		for (ttype, tilesize) in enumerate(tiletypes)
			(di, dj)=tilesize
			# Reference to subarray that tile would cover
			tilearea=try
				sub(grid, i:i+di-1, j:j+dj-1)
			catch
				-1
			end
			# Check occupancy of area that tile would cover
			if reduce(|, tilearea)==0
				# Tile fits. Place one symmetrically in all quadrants
				q2=sub(grid, i:i+di-1, Nj-j+1:-1:Nj-j-dj+2)
				q3=sub(grid, Ni-i+1:-1:Ni-i-di+2, j:j+dj-1)
				q4=sub(grid, Ni-i+1:-1:Ni-i-di+2, Nj-j+1:-1:Nj-j-dj+2)

				# Place the tiles only if full overlap or no overlap between
				# the target area of the different quadrants
				p1=parentindexes(tilearea)
				p2=parentindexes(q2)
				p3=parentindexes(q3)
				p4=parentindexes(q4)
				set1=Set([(x, y) for y in p1[2], x in p1[1]][:])
				set2=Set([(x, y) for y in p2[2], x in p2[1]][:])
				set3=Set([(x, y) for y in p3[2], x in p3[1]][:])
				set4=Set([(x, y) for y in p4[2], x in p4[1]][:])
				tilecells=length(set1)
				no_or_full_overlap=
					(length(intersect(set1, set2))==0 ||
					 length(intersect(set1, set2))==tilecells) &&
					(length(intersect(set1, set3))==0 ||
					 length(intersect(set1, set3))==tilecells) &&
					(length(intersect(set1, set4))==0 ||
					 length(intersect(set1, set4))==tilecells) &&
					(length(intersect(set2, set3))==0 ||
					 length(intersect(set2, set3))==tilecells) &&
					(length(intersect(set2, set4))==0 ||
					 length(intersect(set2, set4))==tilecells) &&
					(length(intersect(set3, set4))==0 ||
					 length(intersect(set3, set4))==tilecells)
				if no_or_full_overlap
					tilearea[:]=ttype	# Place tiles
					q2[:]=ttype
					q3[:]=ttype
					q4[:]=ttype
					#println(grid)
					#readline()		# For debugging
					# Fill next colum
					status=tilefill!(grid, i, j+1, outfile)
					if status==1
						# Filled current row, start next
						status=tilefill!(grid, i+1, 1, outfile)
					elseif status==-1
						# Got stuck, remove laid tiles so that we can try another type
						tilearea[:]=0
						q2[:]=0
						q3[:]=0
						q4[:]=0
					end
				end
			end
		end
		# Exhausted search for fitting tile
		return(-1)
	else
		# Fill next colum
		status=tilefill!(grid, i, j+1, outfile)
		if status==1
			# Filled current row, start next
			status=tilefill!(grid, i+1, 1, outfile)
		end
	end
	return(status)
end


#---------------------------------------------------------------------------
# Main Program
#---------------------------------------------------------------------------
mygrid=zeros(Int8, 21, 25)
outfile=open("out.dat", "w")
tilefill!(mygrid,1,1,outfile)

