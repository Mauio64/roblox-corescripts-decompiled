local function calculateSliderFraction(vector2: Vector2, data, flag: boolean)
	local absolutePosition = data.AbsolutePosition
	local absoluteSize = data.AbsoluteSize
	local v = absolutePosition + absoluteSize * 0.5
	local absoluteRotation = math.rad(data.AbsoluteRotation)
	local vector2_2

	if flag then
		vector2_2 = Vector2.new(math.sin(absoluteRotation), -math.cos(absoluteRotation))
	else
		vector2_2 = Vector2.new(math.cos(absoluteRotation), (math.sin(absoluteRotation)))
	end

	local v2 = if flag then absoluteSize.Y else absoluteSize.X
	return (math.clamp((vector2 - v):Dot(vector2_2) / v2 + 0.5, 0, 1))
end

return calculateSliderFraction
