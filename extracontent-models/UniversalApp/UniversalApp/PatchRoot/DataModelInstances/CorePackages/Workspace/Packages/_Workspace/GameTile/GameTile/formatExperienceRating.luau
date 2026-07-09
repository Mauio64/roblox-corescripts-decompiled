local function formatExperienceRating(n1: number, n2: number, s1: string?, b1: boolean?) -- line: 1
	if n1 + n2 == 0 then
		return s1 or "--"
	end

	local v6 = math.round(n1 / (n1 + n2) * 100)

	if b1 then
		return `{ v6 }%`
	end

	return (tostring(v6))
end

return formatExperienceRating
