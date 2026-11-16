local function shouldSuppressUnreadForTabMetadata(value: string?): boolean
	if value == nil or value == "" then
		return false
	end

	return string.sub(value, 1, 18) == "Roblox.ChatEnabled"
		or string.sub(value, 1, 14) == "Roblox.Welcome"
		or string.sub(value, 1, 14) == "Roblox.Summary"
		or string.sub(value, 1, 22) == "Roblox.Whisper.Welcome"
end

return shouldSuppressUnreadForTabMetadata
