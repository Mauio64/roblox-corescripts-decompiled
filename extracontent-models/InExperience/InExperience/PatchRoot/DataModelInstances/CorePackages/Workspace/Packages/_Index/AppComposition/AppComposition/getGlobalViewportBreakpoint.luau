local AppComposition = script:FindFirstAncestor("AppComposition")
local parent = AppComposition.Parent
local Display = require(parent.Display)
local Signals = require(parent.Signals)
require(parent.Foundation)
local SharedFlags = require(parent.SharedFlags)
local FFlagAppCompositionContainerWidth = SharedFlags.FFlagAppCompositionContainerWidth

local createBreakpointComputed = require(AppComposition.createBreakpointComputed)
local resolveBreakpoint = require(AppComposition.resolveBreakpoint)

if FFlagAppCompositionContainerWidth then
	return (createBreakpointComputed(function(p)
		return Display.GetDisplayStore(p).getDesignSpaceViewportWidth(p)
	end))
end

return (Signals.createComputed(function(p)
	return resolveBreakpoint((Display.GetDisplayStore(p).getDesignSpaceViewportWidth(p)))
end))
