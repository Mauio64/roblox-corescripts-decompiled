local function formatExperienceThumbnail(s1: string?, s2: string, b1: boolean?) -- line: 1
	local n1 = 384
	local n2 = 216

	if b1 then
		n1 = 768
		n2 = 432
	end

	if s1 and s1 ~= "0" then
		return `rbxthumb://type=Asset&id={ s1 }&w={ n1 }&h={ n2 }`
	end

	return `rbxthumb://type=GameThumbnail&id={ s2 }&w={ n1 }&h={ n2 }`
end

return formatExperienceThumbnail
