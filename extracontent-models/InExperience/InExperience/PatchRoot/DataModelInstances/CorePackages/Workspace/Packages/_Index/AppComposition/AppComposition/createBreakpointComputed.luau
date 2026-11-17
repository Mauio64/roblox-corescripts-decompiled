local AppComposition = script:FindFirstAncestor("AppComposition")
local parent = AppComposition.Parent
require(parent.Foundation)
local Signals = require(parent.Signals)

local resolveBreakpoint = require(AppComposition.resolveBreakpoint)

local function createBreakpointComputed(callback)
	return (Signals.createComputed(function(p)
		return resolveBreakpoint(callback(p))
	end))
end

return createBreakpointComputed
