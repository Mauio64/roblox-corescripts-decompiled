return {
	IsPointInRect = function(p1, p2) -- line: 4
		local Min = p1.Min
		local Max = p1.Max

		return p2.X >= Min.X and (p2.Y >= Min.Y and (p2.X <= Max.X and p2.Y <= Max.Y))
	end
}
