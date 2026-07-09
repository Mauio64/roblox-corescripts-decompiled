local AppComposition = script:FindFirstAncestor("AppComposition")
local AppCompositionParent = AppComposition.Parent
local Display = require(AppCompositionParent.Display)
local Signals = require(AppCompositionParent.Signals)

require(AppCompositionParent.Foundation)

local resolveBreakpoint = require(AppComposition.resolveBreakpoint)

return (Signals.createComputed(function(p1) -- line: 11
	-- upvalues: Display (copy), resolveBreakpoint (copy)
	local v7 = Display.GetDisplayStore(p1).getDesignSpaceViewportWidth(p1)

	return resolveBreakpoint(v7)
end))
