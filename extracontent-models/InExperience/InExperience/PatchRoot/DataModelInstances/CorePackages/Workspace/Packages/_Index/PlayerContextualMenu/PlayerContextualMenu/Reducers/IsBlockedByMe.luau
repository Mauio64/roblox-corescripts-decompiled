local PlayerContextualMenu = script:FindFirstAncestor("PlayerContextualMenu")
local parent = PlayerContextualMenu.Parent
local Rodux = require(parent.Rodux)
local Dash = require(parent.Dash)
local Blocking = require(PlayerContextualMenu.Http.Blocking)

return Rodux.createReducer({}, {
	[Blocking.GetBlockedUsers.Succeeded.name] = function(_, p)
		local blockedUsers = p.responseBody and p.responseBody.blockedUsers or {}
		local userIdSet = {}

		for _, blockedUser in ipairs(blockedUsers) do
			userIdSet[tostring(blockedUser.userId)] = true
		end

		return userIdSet
	end,
	[Blocking.BlockUserById.Succeeded.name] = function(p, p2)
		local users = tostring(p2.namedIds.users)
		return Dash.join(p, { [users] = true })
	end,
	[Blocking.UnblockUserById.Succeeded.name] = function(p, p2)
		local users = tostring(p2.namedIds.users)
		return Dash.join(p, { [users] = false })
	end
})
