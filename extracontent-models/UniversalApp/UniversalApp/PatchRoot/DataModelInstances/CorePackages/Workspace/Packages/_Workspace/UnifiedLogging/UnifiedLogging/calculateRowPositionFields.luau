local function calculateRowOnPage(n1: number, p1) -- line: 1
	if not p1 or typeof(p1) ~= "number" then
		return -1
	end

	return p1 + n1 - 1
end
local function calculateRowPositionFields(p2, p3, p4) -- line: 15
	if not p2 or (typeof(p2) ~= "number" or p2 <= 0 or not p3 or typeof(p3) ~= "number" or p3 <= 0) then
		return {
			positionInRow = -1,
			rowInSort = -1,
			rowOnPage = -1
		}
	end

	local v8 = (p2 - 1) % p3 + 1
	local v9 = math.ceil(p2 / p3)
	local v10 = if not not p4 and typeof(p4) == "number" then p4 + v9 - 1 else -1

	return {
		positionInRow = v8,
		rowInSort = v9,
		rowOnPage = v10
	}
end

return calculateRowPositionFields
