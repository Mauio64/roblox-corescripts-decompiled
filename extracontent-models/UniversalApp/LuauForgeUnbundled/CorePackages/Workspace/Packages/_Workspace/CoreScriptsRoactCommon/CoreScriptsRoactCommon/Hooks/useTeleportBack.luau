local TeleportBack = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/CoreScriptsRoactCommon/Traversal/TeleportBack")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/React")

local function useTeleportBack(p2)
	return React.useCallback(function()
		TeleportBack(p2)
	end, {})
end

return useTeleportBack
