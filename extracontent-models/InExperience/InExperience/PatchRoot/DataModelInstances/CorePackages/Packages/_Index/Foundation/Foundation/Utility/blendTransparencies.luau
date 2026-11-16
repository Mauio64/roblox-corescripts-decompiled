local function blendTransparencies(value: number?, value2: number?)
	if value == nil then
		return value2 or 0
	end

	if value2 == nil then
		return value or 0
	end

	return 1 - (1 - value) * (1 - value2)
end

return blendTransparencies
