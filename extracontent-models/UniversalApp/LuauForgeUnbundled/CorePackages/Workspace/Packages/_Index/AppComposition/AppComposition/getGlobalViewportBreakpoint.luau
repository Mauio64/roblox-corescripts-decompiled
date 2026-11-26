local Display = require("@game/CorePackages/Workspace/Packages/_Workspace/AppComposition/Display")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppComposition/Signals")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppComposition/Foundation")
local fFlagAppCompositionContainerWidth = require("@game/CorePackages/Workspace/Packages/_Workspace/AppComposition/SharedFlags").FFlagAppCompositionContainerWidth

local createBreakpointComputed = require("@game/CorePackages/Workspace/Packages/_Index/AppComposition/AppComposition/createBreakpointComputed")
local resolveBreakpoint = require("@game/CorePackages/Workspace/Packages/_Index/AppComposition/AppComposition/resolveBreakpoint")

if fFlagAppCompositionContainerWidth then
	return (createBreakpointComputed(function(p2)
		return Display.GetDisplayStore(p2).getDesignSpaceViewportWidth(p2)
	end))
end

return (Signals.createComputed(function(p2)
	return resolveBreakpoint((Display.GetDisplayStore(p2).getDesignSpaceViewportWidth(p2)))
end))
