return function(vector2: Vector2?, p)
	local selected = vector2 or Vector2.new(0, 0)
	assert(selected, "")

	return if p and p.screenSize then p.screenSize else selected
end
