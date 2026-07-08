local CorePackages = game:GetService("CorePackages")

require(script.Parent.Parent.EventType)

local VRHub = require(CorePackages.Workspace.Packages.VrCommon).VRHub

return {
	Name = "LeaveGameIconHighlightEvent",
	StartEvent = function() -- line: 16
		-- upvalues: VRHub (copy)
		VRHub:SetShowHighlightedLeaveGameIconToggled(true)
	end,
	StopEvent = function() -- line: 20
		-- upvalues: VRHub (copy)
		VRHub:SetShowHighlightedLeaveGameIconToggled(false)
	end
}
