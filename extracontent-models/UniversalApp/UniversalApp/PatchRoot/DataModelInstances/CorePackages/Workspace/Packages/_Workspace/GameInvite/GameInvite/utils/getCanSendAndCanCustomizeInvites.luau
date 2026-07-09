local GameInvite = script:FindFirstAncestor("GameInvite")
local networkImpl = require(GameInvite.GameInviteDependencies).networkImpl

require(GameInvite.gameInviteModalType)

local GetCanSendAndCanCustomizeInvites = require(GameInvite.Requests.GetCanSendAndCanCustomizeInvites)

return function(p1, n1: number?) -- line: 9
	-- upvalues: GetCanSendAndCanCustomizeInvites (copy), networkImpl (copy)
	local v6, v7 = GetCanSendAndCanCustomizeInvites(networkImpl, p1, n1):await()

	if v6 and (v7 and v7.responseBody) then
		return v7.responseBody.canPrompt or false, v7.responseBody.canCustomize or false
	end

	return false, false
end
