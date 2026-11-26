local function formatNumberWithShortUnits(p2)
	local v5 = math.abs(p2)
	local v6

	if v5 >= 1000000000 then
		v6 = ("%.0fB"):format((math.floor(p2 / 1000000000)))
	elseif v5 >= 1000000 then
		if v5 >= 100000000 then
			v6 = ("%.0fM"):format((math.floor(p2 / 1000000)))
		else
			v6 = ("%.1fM"):format(p2 / 1000000)
		end
	elseif v5 >= 1000 then
		if v5 >= 100000 then
			v6 = ("%.0fK"):format((math.floor(p2 / 1000)))
		else
			v6 = ("%.1fK"):format(p2 / 1000)
		end
	else
		v6 = tostring(p2)
	end

	local match, v7 = v6:match("(%d+)%.0(%w+)")

	if match and v7 then
		v6 = match .. v7
	end

	return v6
end

return formatNumberWithShortUnits
