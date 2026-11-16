local parent = script:FindFirstAncestor("GameInvite").Parent

local DataHydration = require(parent.DataHydration)
local UserLib = require(parent.UserLib)
local UserModel = UserLib.Models.UserModel

local isInThisServer = require(script.Parent.isInThisServer)

local InGame = DataHydration.Presence.PresenceEnums.PresenceType.InGame

local function isJoinExpected(p, p2, p3: string): boolean
	if p == nil then
		return p2 == nil or p2.presence == UserModel.PresenceType.IN_GAME
	end

	return p.userPresenceType == InGame and not isInThisServer(p, p3)
end

return isJoinExpected
