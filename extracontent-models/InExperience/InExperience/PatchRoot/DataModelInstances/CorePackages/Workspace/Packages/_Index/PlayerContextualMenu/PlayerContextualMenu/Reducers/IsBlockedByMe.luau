local PlayerContextualMenu = script:FindFirstAncestor("PlayerContextualMenu")
local PlayerContextualMenuParent = PlayerContextualMenu.Parent
local Rodux = require(PlayerContextualMenuParent.Rodux)
local Dash = require(PlayerContextualMenuParent.Dash)
local Blocking = require(PlayerContextualMenu.Http.Blocking)

return Rodux.createReducer({}, {
	[Blocking.GetBlockedUsers.Succeeded.name] = function(_, p2) -- line: 12
		local v8 = p2.responseBody and p2.responseBody.blockedUsers or {}
		local t1 = {}

		for _, v in ipairs(v8) do
			t1[tostring(v.userId)] = true
		end

		return t1
	end,
	[Blocking.BlockUserById.Succeeded.name] = function(p3, p4) -- line: 21
		-- upvalues: Dash (copy)
		local str = tostring(p4.namedIds.users)

		return Dash.join(p3, {
			[str] = true
		})
	end,
	[Blocking.UnblockUserById.Succeeded.name] = function(p5, p6) -- line: 27
		-- upvalues: Dash (copy)
		local str = tostring(p6.namedIds.users)

		return Dash.join(p5, {
			[str] = false
		})
	end
})
