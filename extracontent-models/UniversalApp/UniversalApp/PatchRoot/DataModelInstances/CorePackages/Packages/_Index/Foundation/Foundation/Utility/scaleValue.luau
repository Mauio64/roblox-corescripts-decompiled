local function scaleValue(p1, n1: number?) -- line: 1
	if n1 == nil then
		return p1
	end

	if typeof(p1) == "number" then
		return p1 * n1
	end

	if typeof(p1) == "UDim" then
		return UDim.new(p1.Scale, p1.Offset * n1)
	end

	if typeof(p1) == "UDim2" then
		return UDim2.new(p1.X.Scale, p1.X.Offset * n1, p1.Y.Scale, p1.Y.Offset * n1)
	end

	return p1
end

return scaleValue
