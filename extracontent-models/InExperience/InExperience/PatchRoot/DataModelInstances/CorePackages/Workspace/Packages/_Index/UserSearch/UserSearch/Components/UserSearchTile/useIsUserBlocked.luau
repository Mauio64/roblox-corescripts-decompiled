local parent = script:FindFirstAncestor("UserSearch").Parent

local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local function useIsUserBlocked(p: string)
	return useSelector(function(p2): boolean
		local playerContextualMenu = p2.PlayerContextualMenu

		if not playerContextualMenu then
			return false
		end

		local userBlocking = playerContextualMenu.UserBlocking
		local isBlockedByMe

		if userBlocking then
			isBlockedByMe = userBlocking.isBlockedByMe
		else
			isBlockedByMe = playerContextualMenu.IsBlockedByMe
		end

		if isBlockedByMe then
			return isBlockedByMe[p] == true
		end

		return false
	end)
end

return useIsUserBlocked
