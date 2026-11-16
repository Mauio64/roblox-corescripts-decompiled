local function scaleValue(value, p: number?)
	if p == nil then
		return value
	end

	if typeof(value) == "number" then
		return value * p
	end

	if typeof(value) == "UDim" then
		return UDim.new(value.Scale, value.Offset * p)
	end

	if typeof(value) == "UDim2" then
		return UDim2.new(value.X.Scale, value.X.Offset * p, value.Y.Scale, value.Y.Offset * p)
	end

	return value
end

return scaleValue
