local function shouldSuppressUnreadForTabMetadata(s1: string?) -- line: 9
	if s1 == nil or s1 == "" then
		return false
	end

	return string.sub(s1, 1, 18) == "Roblox.ChatEnabled" or (string.sub(s1, 1, 14) == "Roblox.Welcome" or string.sub(s1, 1, 14) == "Roblox.Summary")
end

return shouldSuppressUnreadForTabMetadata
