local function calculateRowOnPage(p2, value)
	if value and typeof(value) == "number" then
		return value + p2 - 1
	end

	return -1
end

local function calculateRowPositionFields(value, value2, value3)
	if
		not value
		or typeof(value) ~= "number"
		or value <= 0
		or not value2
		or typeof(value2) ~= "number"
		or value2 <= 0
	then
		return { positionInRow = -1, rowInSort = -1, rowOnPage = -1 }
	end

	local v5 = (value - 1) % value2 + 1

	local v6 = math.ceil(value / value2)
	return {
		positionInRow = v5,
		rowInSort = v6,
		rowOnPage = (not value3 or typeof(value3) ~= "number") and -1 or value3 + v6 - 1
	}
end

return calculateRowPositionFields
