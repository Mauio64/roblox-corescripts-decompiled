local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/Rodux")
local Dash = require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/Dash")
local Blocking = require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/PlayerContextualMenu/Http/Blocking")

return Rodux.createReducer({}, {
	[Blocking.GetBlockedUsers.Succeeded.name] = function(p2, p3)
		local blockedUsers = p3.responseBody and p3.responseBody.blockedUsers or {}
		local userIdSet = {}

		for i, blockedUser in ipairs(blockedUsers) do
			userIdSet[tostring(blockedUser.userId)] = true
		end

		return userIdSet
	end,
	[Blocking.BlockUserById.Succeeded.name] = function(p2, p3)
		local users = tostring(p3.namedIds.users)
		return Dash.join(p2, { [users] = true })
	end,
	[Blocking.UnblockUserById.Succeeded.name] = function(p2, p3)
		local users = tostring(p3.namedIds.users)
		return Dash.join(p2, { [users] = false })
	end
})
