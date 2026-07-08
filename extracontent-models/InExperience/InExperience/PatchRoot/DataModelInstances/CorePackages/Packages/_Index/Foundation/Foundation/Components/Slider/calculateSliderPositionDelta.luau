local function calculateSliderPositionDelta(vector2: Vector2, vector2_2: Vector2, n1: number) -- line: 6
	return (vector2 - vector2_2).X / n1
end

return calculateSliderPositionDelta
