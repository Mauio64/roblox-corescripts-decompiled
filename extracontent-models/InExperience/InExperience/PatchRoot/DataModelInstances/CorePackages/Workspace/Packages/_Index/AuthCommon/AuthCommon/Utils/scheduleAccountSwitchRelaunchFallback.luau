local parent = script:FindFirstAncestor("AuthCommon").Parent
local Promise = require(parent.Promise)
local SharedFlags = require(parent.SharedFlags)

local GetFIntAccountSwitchRelaunchFallbackSeconds = SharedFlags.GetFIntAccountSwitchRelaunchFallbackSeconds

local function scheduleAccountSwitchRelaunchFallback(callback, options)
	return ((options or {}).delay or Promise.delay)(GetFIntAccountSwitchRelaunchFallbackSeconds()):andThen(function()
		callback()
	end)
end

return scheduleAccountSwitchRelaunchFallback
