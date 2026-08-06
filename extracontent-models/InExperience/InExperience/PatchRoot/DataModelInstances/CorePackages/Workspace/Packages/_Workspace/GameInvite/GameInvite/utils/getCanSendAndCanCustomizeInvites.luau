local GameInvite = script:FindFirstAncestor("GameInvite")
local GameInviteParent = GameInvite.Parent
local networkImpl = require(GameInvite.GameInviteDependencies).networkImpl

require(GameInvite.gameInviteModalType)

local GetCanSendAndCanCustomizeInvites = require(GameInvite.Requests.GetCanSendAndCanCustomizeInvites)
local FFlagGameInviteOpenModalWithoutBlockingOnCanPrompt = require(GameInviteParent.SharedFlags).FFlagGameInviteOpenModalWithoutBlockingOnCanPrompt

return function(p1, n1: number?) -- line: 13
	-- upvalues: GetCanSendAndCanCustomizeInvites (copy), networkImpl (copy), FFlagGameInviteOpenModalWithoutBlockingOnCanPrompt (copy)
	local v8, v9 = GetCanSendAndCanCustomizeInvites(networkImpl, p1, n1):await()

	if v8 and (v9 and v9.responseBody) then
		return v9.responseBody.canPrompt or false, v9.responseBody.canCustomize or false
	end

	if FFlagGameInviteOpenModalWithoutBlockingOnCanPrompt then
		return true, false
	end

	return false, false
end
