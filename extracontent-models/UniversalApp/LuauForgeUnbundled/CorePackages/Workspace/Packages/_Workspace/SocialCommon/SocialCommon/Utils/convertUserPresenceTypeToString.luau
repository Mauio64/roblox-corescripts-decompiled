local presenceType = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/LuaSocialLibrariesDeps").RoduxPresence.config({
	keyPath = "SocialCommon.Presence"
}).Enums.PresenceType

return function(p2): string
	if p2 == presenceType.Online then
		return "Online"
	end

	if p2 == presenceType.InStudio then
		return "InStudio"
	end

	if p2 == presenceType.InGame then
		return "InGame"
	end

	return "Offline"
end
