local function countUtf16Units(list: string)
	if utf8.len(list) == nil then
		return #list
	end

	local total = 0

	for _, v in utf8.codes(list) do
		total += v > 65535 and 2 or 1
	end

	return total
end

return countUtf16Units
