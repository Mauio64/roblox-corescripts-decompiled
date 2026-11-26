local function normalizeScreenSizeForWire(value)
	if #value == 0 then
		return value
	end

	return string.lower((string.sub(value, 1, 1))) .. string.sub(value, 2)
end

return normalizeScreenSizeForWire
