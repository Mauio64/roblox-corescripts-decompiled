return function(p2, p3)
	local v5 = p2 or Vector2.new(0, 0)
	assert(v5, "")

	if p3 and p3.screenSize then
		return p3.screenSize
	end

	return v5
end
