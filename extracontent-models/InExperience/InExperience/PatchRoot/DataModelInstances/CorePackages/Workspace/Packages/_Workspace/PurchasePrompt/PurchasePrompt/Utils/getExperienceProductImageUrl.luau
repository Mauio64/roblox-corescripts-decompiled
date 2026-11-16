local function getExperienceProductImageUrl(p: string?, p2)
	if p and p ~= "" then
		return p
	end

	return string.format("rbxthumb://type=GameIcon&id=%s&w=150&h=150", (tostring(p2)))
end

return getExperienceProductImageUrl
