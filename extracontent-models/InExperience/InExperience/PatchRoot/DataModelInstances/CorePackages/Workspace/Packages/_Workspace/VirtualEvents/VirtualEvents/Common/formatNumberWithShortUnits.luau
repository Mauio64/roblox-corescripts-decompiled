local function formatNumberWithShortUnits(p: number)
	local v = math.abs(p)
	local v2

	if v >= 1000000000 then
		v2 = ("%.0fB"):format((math.floor(p / 1000000000)))
	elseif v >= 1000000 then
		if v >= 100000000 then
			v2 = ("%.0fM"):format((math.floor(p / 1000000)))
		else
			v2 = ("%.1fM"):format(p / 1000000)
		end
	elseif v >= 1000 then
		if v >= 100000 then
			v2 = ("%.0fK"):format((math.floor(p / 1000)))
		else
			v2 = ("%.1fK"):format(p / 1000)
		end
	else
		v2 = tostring(p)
	end

	local match, v3 = v2:match("(%d+)%.0(%w+)")

	if match and v3 then
		return match .. v3
	end

	return v2
end

return formatNumberWithShortUnits
