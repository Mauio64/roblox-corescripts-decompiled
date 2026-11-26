local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/RoactUtils").Hooks.RoactRodux.useSelector

local function useIsUserBlocked(p2)
	return useSelector(function(p3): boolean
		local playerContextualMenu = p3.PlayerContextualMenu

		if not playerContextualMenu then
			return false
		end

		local userBlocking = playerContextualMenu.UserBlocking

		local isBlockedByMe = if userBlocking then userBlocking.isBlockedByMe else playerContextualMenu.IsBlockedByMe

		if isBlockedByMe then
			return isBlockedByMe[p2] == true
		end

		return false
	end)
end

return useIsUserBlocked
