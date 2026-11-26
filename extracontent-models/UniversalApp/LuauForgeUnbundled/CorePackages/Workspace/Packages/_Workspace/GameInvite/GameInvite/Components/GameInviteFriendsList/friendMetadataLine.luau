local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/DataHydration")
require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/UserList")
local userModel = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/UserLib").Models.UserModel

local escapeRichText = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/utils/escapeRichText")

local presenceType = DataHydration.Presence.PresenceEnums.PresenceType

return {
	getContextText = function(p2, p3)
		local lastLocation = p2.lastLocation

		if p2.presence == userModel.PresenceType.IN_STUDIO then
			return p3.inStudio
		end

		if p2.presence == userModel.PresenceType.IN_GAME and lastLocation ~= nil and lastLocation ~= "" then
			return escapeRichText(lastLocation)
		end

		return nil
	end,
	getContextTextForPresence = function(p2, p3, p4)
		if p2 == presenceType.InStudio then
			return p4.inStudio
		end

		if p2 == presenceType.InGame and p3 ~= nil and p3 ~= "" then
			return escapeRichText(p3)
		end

		if p2 == presenceType.Online then
			return p4.online
		end

		return nil
	end,
	getLivePresenceType = function(p2)
		if p2.userPresenceType == presenceType.InGame and p2.universeId == "" then
			return presenceType.Online
		end

		return p2.userPresenceType
	end
}
