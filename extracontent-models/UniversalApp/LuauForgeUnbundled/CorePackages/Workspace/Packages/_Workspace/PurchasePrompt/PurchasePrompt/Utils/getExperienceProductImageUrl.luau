local function getExperienceProductImageUrl(p2, p3)
	if p2 and p2 ~= "" then
		return p2
	end

	return string.format("rbxthumb://type=GameIcon&id=%s&w=150&h=150", (tostring(p3)))
end

return getExperienceProductImageUrl
