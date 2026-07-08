return function(p1, p2) -- line: 10
	if p1.SliceCenter then
		local v3 = p1.SliceCenter.Min * p2
		local v4 = p1.SliceCenter.Max * p2

		p1.SliceCenter = Rect.new(v3, v4)
		p1.SliceScale = (p1.SliceScale or 1) / p2
	end

	return p1
end
