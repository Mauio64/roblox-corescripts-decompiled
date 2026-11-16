local function formatExperienceThumbnail(p: string?, p2: string, flag: boolean?)
	local v, v2

	if flag then
		v = 768
		v2 = 432
	else
		v = 384
		v2 = 216
	end

	if p and p ~= "0" then
		return `rbxthumb://type=Asset&id={p}&w={v}&h={v2}`
	end

	return `rbxthumb://type=GameThumbnail&id={p2}&w={v}&h={v2}`
end

return formatExperienceThumbnail
