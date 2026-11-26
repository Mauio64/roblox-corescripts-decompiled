return {
	IsPointInRect = function(p2, p3): boolean
		local min = p2.Min
		local max = p2.Max
		return p3.X >= min.X and p3.Y >= min.Y and p3.X <= max.X and p3.Y <= max.Y
	end
}
