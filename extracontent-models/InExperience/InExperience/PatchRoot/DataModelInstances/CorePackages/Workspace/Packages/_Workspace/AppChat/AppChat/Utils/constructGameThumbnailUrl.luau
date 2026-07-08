local function constructGameThumbnailUrl(s1: string, n1: number, n2: number) -- line: 9
	return `rbxthumb://type=GameThumbnail&id={ s1 }&w={ n1 }&h={ n2 }`
end

return constructGameThumbnailUrl
