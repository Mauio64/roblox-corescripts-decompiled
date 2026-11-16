local immutable = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/AppCommonLib").Immutable

local ReceivedUserInviteStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/State/Actions/ReceivedUserInviteStatus")
local ResetUserInviteStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/State/Actions/ResetUserInviteStatus")
return function(options, data)
	local v5 = options or {}

	if data.type == ReceivedUserInviteStatus.name then
		return (immutable.Set(v5, data.userId, data.inviteStatus))
	end

	return data.type == ResetUserInviteStatus.name and {} or v5
end
