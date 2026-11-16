local v = utf8.char(8205)

local function countChars(value: string)
	if utf8.len(value) == nil then
		return #value
	end

	local total = 0

	for k, v2 in utf8.graphemes(value) do
		local count = 0

		for _, v3 in string.split(string.sub(value, k, v2), v) do
			if v3 ~= "" then
				count += 1
			end
		end

		total += math.max(count, 1)
	end

	return total
end

return countChars
