local function calculateSliderValueFromPosition(vector2: Vector2, p1, numberRange: NumberRange) -- line: 6
	local AbsoluteRotation = p1.AbsoluteRotation
	local Magnitude = p1.AbsoluteSize.Magnitude
	local v7 = p1.AbsolutePosition + p1.AbsoluteSize * 0.5
	local v8 = math.rad(AbsoluteRotation)
	local vector2_2 = Vector2.new(math.cos(v8), (math.sin(v8)))

	return (math.clamp(math.clamp((vector2 - v7):Dot(vector2_2) / Magnitude + 0.5, 0, 1) * (numberRange.Max - numberRange.Min) + numberRange.Min, numberRange.Min, numberRange.Max))
end

return calculateSliderValueFromPosition
