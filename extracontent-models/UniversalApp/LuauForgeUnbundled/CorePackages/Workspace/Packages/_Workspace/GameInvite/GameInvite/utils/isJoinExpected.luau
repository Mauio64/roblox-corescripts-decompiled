local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/DataHydration")
local userModel = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/UserLib").Models.UserModel

local isInThisServer = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/utils/isInThisServer")

local inGame = DataHydration.Presence.PresenceEnums.PresenceType.InGame

local function isJoinExpected(p2, p3, p4): boolean
	if p2 == nil then
		return p3 == nil or p3.presence == userModel.PresenceType.IN_GAME
	end

	return p2.userPresenceType == inGame and not isInThisServer(p2, p4)
end

return isJoinExpected
