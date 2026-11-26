require("@game/CorePackages/Workspace/Packages/_Workspace/AppComposition/Foundation")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppComposition/Signals")

local resolveBreakpoint = require("@game/CorePackages/Workspace/Packages/_Index/AppComposition/AppComposition/resolveBreakpoint")

local function createBreakpointComputed(callback)
	return Signals.createComputed(function(p2)
		return resolveBreakpoint(callback(p2))
	end)
end

return createBreakpointComputed
