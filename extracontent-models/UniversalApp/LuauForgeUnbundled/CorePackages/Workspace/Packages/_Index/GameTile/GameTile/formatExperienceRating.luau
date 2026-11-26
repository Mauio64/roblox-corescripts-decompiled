local function formatExperienceRating(p2, p3, value, p4)
	if p2 + p3 == 0 then
		return value or "--"
	end

	local v5 = math.round(p2 / (p2 + p3) * 100)

	if p4 then
		return `{v5}%`
	end

	return (tostring(v5))
end

return formatExperienceRating
