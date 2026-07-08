local function blendTransparencies(n1: number?, n2: number?) -- line: 1
	if n1 == nil then
		return n2 or 0
	end

	if n2 == nil then
		return n1 or 0
	end

	return 1 - (1 - n1) * (1 - n2)
end

return blendTransparencies
