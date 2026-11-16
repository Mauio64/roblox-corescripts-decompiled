local function formatExperienceIcon(p2, p3)
	if p2 then
		return p2
	end

	return `rbxthumb://type=GameIcon&id={p3}&w=150&h=150`
end

return formatExperienceIcon
