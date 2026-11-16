return {
	IsPointInRect = function(p, p2): boolean
		local min = p.Min
		local max = p.Max
		return p2.X >= min.X and p2.Y >= min.Y and p2.X <= max.X and p2.Y <= max.Y
	end
}
