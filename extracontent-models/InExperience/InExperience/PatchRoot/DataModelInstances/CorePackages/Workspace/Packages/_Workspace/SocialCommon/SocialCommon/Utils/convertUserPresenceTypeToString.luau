local Parent = script:FindFirstAncestor("SocialCommon").Parent
local PresenceType = require(Parent.LuaSocialLibrariesDeps).RoduxPresence.config({
	keyPath = "SocialCommon.Presence"
}).Enums.PresenceType

return function(p1) -- line: 8
	-- upvalues: PresenceType (copy)
	if p1 == PresenceType.Online then
		return "Online"
	end

	if p1 == PresenceType.InStudio then
		return "InStudio"
	end

	if p1 == PresenceType.InGame then
		return "InGame"
	end

	return "Offline"
end
