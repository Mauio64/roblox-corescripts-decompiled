local parent = script:FindFirstAncestor("SocialCommon").Parent
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local presenceType = LuaSocialLibrariesDeps.RoduxPresence.config({
	keyPath = "SocialCommon.Presence"
}).Enums.PresenceType

return function(p): string
	if p == presenceType.Online then
		return "Online"
	end

	if p == presenceType.InStudio then
		return "InStudio"
	end

	return if p == presenceType.InGame then "InGame" else "Offline"
end
