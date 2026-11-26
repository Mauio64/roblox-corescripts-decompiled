require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Common/LocalTypes")
local presenceType = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Rodux/RoduxPresence").Enums.PresenceType
local FFlagUserSearchPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Flags/FFlagUserSearchPresenceStoreMigration")

local presenceType2 = if FFlagUserSearchPresenceStoreMigration then require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/DataHydration").Presence.PresenceEnums.PresenceType else nil

return {
	isUserOnline = function(p2): boolean
		if FFlagUserSearchPresenceStoreMigration then
			return p2 == presenceType2.Online or p2 == presenceType2.InStudio or p2 == presenceType2.InGame
		end

		return p2 == presenceType.Online or p2 == presenceType.InStudio or p2 == presenceType.InGame
	end,
	isUserInGame = function(p2): boolean
		if p2 and p2.universeId then
			if FFlagUserSearchPresenceStoreMigration then
				return p2.userPresenceType == presenceType2.InGame
			end

			return p2.userPresenceType == presenceType.InGame
		end

		return false
	end
}
