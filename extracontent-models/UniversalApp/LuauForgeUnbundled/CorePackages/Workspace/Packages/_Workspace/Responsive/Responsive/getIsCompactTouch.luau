local StandardBreakpoints = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/Responsive/CommonConfigs/StandardBreakpoints")
local InputMode = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/Responsive/InputMode")

return function(p2, p3)
	local maxWidth = StandardBreakpoints.sizes[StandardBreakpoints.Enum.Small].maxWidth
	local v5 = p2.X < p2.Y
	return p2.X <= maxWidth and v5 and p3 == InputMode.Enum.Touch
end
