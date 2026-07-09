local function formatExperienceIcon(s1: string?, s2: string) -- line: 1
	if s1 then
		return s1
	end

	return `rbxthumb://type=GameIcon&id={ s2 }&w=150&h=150`
end

return formatExperienceIcon
