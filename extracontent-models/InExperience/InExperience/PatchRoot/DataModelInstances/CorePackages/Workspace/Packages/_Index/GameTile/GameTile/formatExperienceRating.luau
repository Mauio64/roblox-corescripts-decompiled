local function formatExperienceRating(p: number, p2: number, value: string?, flag: boolean?)
	if p + p2 == 0 then
		return value or "--"
	end

	local v = math.round(p / (p + p2) * 100)

	if flag then
		return `{v}%`
	end

	return (tostring(v))
end

return formatExperienceRating
