local CorePackages = game:GetService("CorePackages")

require(script.Parent.Parent.EventType)
local VrCommon = require(CorePackages.Workspace.Packages.VrCommon)
local VRHub = VrCommon.VRHub

local LeaveGameIconHighlightEvent = { Name = "LeaveGameIconHighlightEvent" }

function LeaveGameIconHighlightEvent.StartEvent()
	VRHub:SetShowHighlightedLeaveGameIconToggled(true)
end

function LeaveGameIconHighlightEvent.StopEvent()
	VRHub:SetShowHighlightedLeaveGameIconToggled(false)
end

return LeaveGameIconHighlightEvent
