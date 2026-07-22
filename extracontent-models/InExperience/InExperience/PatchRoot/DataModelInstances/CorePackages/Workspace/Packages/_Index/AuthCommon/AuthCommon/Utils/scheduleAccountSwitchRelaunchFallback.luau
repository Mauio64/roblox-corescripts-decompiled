local Parent = script:FindFirstAncestor("AuthCommon").Parent
local Promise = require(Parent.Promise)
local GetFIntAccountSwitchRelaunchFallbackSeconds = require(Parent.SharedFlags).GetFIntAccountSwitchRelaunchFallbackSeconds

local function scheduleAccountSwitchRelaunchFallback(p1: ((...any) -> ...any), t1: {[any]: any}?) -- line: 28
	-- upvalues: Promise (copy), GetFIntAccountSwitchRelaunchFallbackSeconds (copy)
	return ((t1 or {}).delay or Promise.delay)(GetFIntAccountSwitchRelaunchFallbackSeconds()):andThen(function() -- line: 32
		-- upvalues: p1 (copy)
		p1()
	end)
end

return scheduleAccountSwitchRelaunchFallback
