local GameInvite = script:FindFirstAncestor("GameInvite")
local parent = GameInvite.Parent

local GameInviteDependencies = require(GameInvite.GameInviteDependencies)
local networkImpl = GameInviteDependencies.networkImpl
require(GameInvite.gameInviteModalType)

local GetCanSendAndCanCustomizeInvites = require(GameInvite.Requests.GetCanSendAndCanCustomizeInvites)

local SharedFlags = require(parent.SharedFlags)
local FFlagGameInviteOpenModalWithoutBlockingOnCanPrompt = SharedFlags.FFlagGameInviteOpenModalWithoutBlockingOnCanPrompt

return function(p, p2: number?)
	local v, v2 = GetCanSendAndCanCustomizeInvites(networkImpl, p, p2):await()

	if v and v2 and v2.responseBody then
		return v2.responseBody.canPrompt or false, v2.responseBody.canCustomize or false
	end

	if FFlagGameInviteOpenModalWithoutBlockingOnCanPrompt then
		return true, false
	end

	return false, false
end
