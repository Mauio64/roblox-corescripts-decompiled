local AppComposition = script:FindFirstAncestor("AppComposition")
local parent = AppComposition.Parent
local Display = require(parent.Display)
local Signals = require(parent.Signals)
require(parent.Foundation)

local resolveBreakpoint = require(AppComposition.resolveBreakpoint)

return (Signals.createComputed(function(p)
	return resolveBreakpoint((Display.GetDisplayStore(p).getDesignSpaceViewportWidth(p)))
end))
