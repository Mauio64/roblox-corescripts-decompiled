local function isGlobalChatMessage(p): boolean
	return p.isUniverseChat == true or p.channelNameOverride == "RBXGlobal"
end

return isGlobalChatMessage
