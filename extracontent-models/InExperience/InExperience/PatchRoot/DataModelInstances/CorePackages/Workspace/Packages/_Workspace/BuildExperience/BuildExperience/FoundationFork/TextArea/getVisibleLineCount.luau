local function getVisibleLineCount(s1: string, n1: number) -- line: 3
	local n2 = 1

	if s1 ~= "" then
		for _ in string.gmatch(s1, "\n") do
			n2 += 1
		end
	end

	return (math.clamp(n2, 1, n1))
end

return getVisibleLineCount
