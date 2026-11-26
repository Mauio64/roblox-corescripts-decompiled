local function formatExperienceThumbnail(p2, p3, p4)
	local v5, v6

	if p4 then
		v5 = 768
		v6 = 432
	else
		v5 = 384
		v6 = 216
	end

	if p2 and p2 ~= "0" then
		return `rbxthumb://type=Asset&id={p2}&w={v5}&h={v6}`
	end

	return `rbxthumb://type=GameThumbnail&id={p3}&w={v5}&h={v6}`
end

return formatExperienceThumbnail
