local dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/dependencies")
local presenceTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Enums").PresenceTypes
local presenceType = dependencies.RoduxPresence.Enums.PresenceType

local v5 = {
	[presenceType.InGame] = presenceTypes.InGame,
	[presenceType.InStudio] = presenceTypes.InStudio,
	[presenceType.Offline] = presenceTypes.Offline,
	[presenceType.Online] = presenceTypes.Online
}

return function(value)
	if not value then
		return nil
	end

	if type(value) == "string" and value ~= "" then
		return presenceTypes[value]
	end

	return v5[value]
end
