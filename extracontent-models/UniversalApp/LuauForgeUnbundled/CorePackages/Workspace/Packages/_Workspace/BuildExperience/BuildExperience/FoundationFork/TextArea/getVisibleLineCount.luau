local function getVisibleLineCount(value, max)
	local v5 = 1

	if value ~= "" then
		for k in string.gmatch(value, "\n") do
			v5 += 1
		end
	end

	return (math.clamp(v5, 1, max))
end

return getVisibleLineCount
