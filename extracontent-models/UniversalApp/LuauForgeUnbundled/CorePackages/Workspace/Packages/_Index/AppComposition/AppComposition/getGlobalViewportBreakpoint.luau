local Display = require("@game/CorePackages/Workspace/Packages/_Workspace/AppComposition/Display")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppComposition/Signals")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppComposition/Foundation")

local resolveBreakpoint = require("@game/CorePackages/Workspace/Packages/_Index/AppComposition/AppComposition/resolveBreakpoint")

return (Signals.createComputed(function(p2)
	return resolveBreakpoint((Display.GetDisplayStore(p2).getDesignSpaceViewportWidth(p2)))
end))
