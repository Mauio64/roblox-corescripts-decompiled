local CoreScriptsRoactCommon = script:FindFirstAncestor("CoreScriptsRoactCommon")
local CoreScriptsRoactCommonParent = CoreScriptsRoactCommon.Parent
local TeleportBack = require(CoreScriptsRoactCommon.Traversal.TeleportBack)
local React = require(CoreScriptsRoactCommonParent.React)

local function useTeleportBack(n1: number?) -- line: 7
	-- upvalues: React (copy), TeleportBack (copy)
	return React.useCallback(function() -- line: 8
		-- upvalues: TeleportBack (copy), n1 (copy)
		TeleportBack(n1)
	end, {})
end

return useTeleportBack
