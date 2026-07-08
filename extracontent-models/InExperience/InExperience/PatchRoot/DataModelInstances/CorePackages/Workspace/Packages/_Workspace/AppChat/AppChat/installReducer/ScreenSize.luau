return function(vector2: Vector2?, p1) -- line: 3
	local v3 = vector2 or Vector2.new(0, 0)

	assert(v3, "")

	if p1 and p1.screenSize then
		return p1.screenSize
	end

	return v3
end
