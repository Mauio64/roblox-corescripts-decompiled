local v5 = utf8.char(8205)

local function countChars(value)
	if utf8.len(value) == nil then
		return #value
	end

	local total = 0

	for k, v6 in utf8.graphemes(value) do
		local count = 0

		for k2, v7 in string.split(string.sub(value, k, v6), v5) do
			if v7 ~= "" then
				count += 1
			end
		end

		total += (math.max)(count, 1)
	end

	return total
end

return countChars
