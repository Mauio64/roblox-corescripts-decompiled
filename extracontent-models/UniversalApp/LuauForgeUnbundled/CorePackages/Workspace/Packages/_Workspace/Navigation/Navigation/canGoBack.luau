local actions = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/RoactNavigation").Actions
require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/types")
local getRootNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/getRootNavigation")

local function canGoBack(p2): boolean
	local v5 = getRootNavigation(p2)
	local state = v5.state

	return state ~= v5.router.getStateForAction(actions.back({ key = false }), state)
end

return canGoBack
