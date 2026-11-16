local CoreScriptsRoactCommon = script:FindFirstAncestor("CoreScriptsRoactCommon")
local parent = CoreScriptsRoactCommon.Parent

local TeleportBack = require(CoreScriptsRoactCommon.Traversal.TeleportBack)
local React = require(parent.React)

local function useTeleportBack(p: number?)
	return React.useCallback(function()
		TeleportBack(p)
	end, {})
end

return useTeleportBack
