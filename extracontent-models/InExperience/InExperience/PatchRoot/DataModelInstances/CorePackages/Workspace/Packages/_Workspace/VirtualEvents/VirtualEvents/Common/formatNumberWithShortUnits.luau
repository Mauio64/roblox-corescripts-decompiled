local function formatNumberWithShortUnits(n1: number) -- line: 30
	local v3 = math.abs(n1)
	local v4 = if not (v3 >= 1000000000) then if not (v3 >= 1000000) then if not (v3 >= 1000) then tostring(n1) else if not (v3 >= 100000) then ("%.1fK"):format(n1 / 1000) else ("%.0fK"):format((math.floor(n1 / 1000))) else if not (v3 >= 100000000) then ("%.1fM"):format(n1 / 1000000) else ("%.0fM"):format((math.floor(n1 / 1000000))) else ("%.0fB"):format((math.floor(n1 / 1000000000)))
	local v5, v6 = v4:match("(%d+)%.0(%w+)")

	if v5 and v6 then
		v4 = v5 .. v6
	end

	return v4
end

return formatNumberWithShortUnits
