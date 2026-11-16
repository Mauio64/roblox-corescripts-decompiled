local function calculateRowOnPage(p: number, value) -- 1 equivalent call inferred from this helper
	if value and typeof(value) == "number" then
		return value + p - 1
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

	local positionInRow = (value - 1) % value2 + 1

	local rowInSort = math.ceil(value / value2)

	return {
		positionInRow = positionInRow,
		rowInSort = rowInSort,
		rowOnPage = calculateRowOnPage(rowInSort, value3) -- inferred equivalent call
	}
end

return calculateRowPositionFields
