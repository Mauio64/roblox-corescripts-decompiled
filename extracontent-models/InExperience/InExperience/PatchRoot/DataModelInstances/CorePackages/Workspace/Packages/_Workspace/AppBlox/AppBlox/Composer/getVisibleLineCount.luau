local function getVisibleLineCount(value: string, max: number)
	local v = 1

	if value ~= "" then
		for _ in string.gmatch(value, "\n") do
			v += 1
		end
	end

	return (math.clamp(v, 1, max))
end

return getVisibleLineCount
