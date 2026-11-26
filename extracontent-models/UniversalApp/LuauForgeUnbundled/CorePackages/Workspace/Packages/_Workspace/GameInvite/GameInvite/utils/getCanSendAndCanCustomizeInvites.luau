local networkImpl = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/GameInviteDependencies").networkImpl
require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/gameInviteModalType")

local GetCanSendAndCanCustomizeInvites = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Requests/GetCanSendAndCanCustomizeInvites")

local fFlagGameInviteOpenModalWithoutBlockingOnCanPrompt = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/SharedFlags").FFlagGameInviteOpenModalWithoutBlockingOnCanPrompt

return function(p2, p3)
	local v5, v6 = GetCanSendAndCanCustomizeInvites(networkImpl, p2, p3):await()

	if v5 and v6 and v6.responseBody then
		return v6.responseBody.canPrompt or false, v6.responseBody.canCustomize or false
	end

	if fFlagGameInviteOpenModalWithoutBlockingOnCanPrompt then
		return true, false
	end

	return false, false
end
