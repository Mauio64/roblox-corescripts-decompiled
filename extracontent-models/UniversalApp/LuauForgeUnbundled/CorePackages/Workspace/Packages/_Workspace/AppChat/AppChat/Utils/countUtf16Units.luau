local function countUtf16Units(list)
	if utf8.len(list) == nil then
		return #list
	end

	local total = 0

	for k, v5 in utf8.codes(list) do
		total += v5 > 65535 and 2 or 1
	end

	return total
end

return countUtf16Units
