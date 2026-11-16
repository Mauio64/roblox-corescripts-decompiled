local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Promise")
local getFIntAccountSwitchRelaunchFallbackSeconds = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").GetFIntAccountSwitchRelaunchFallbackSeconds

local function scheduleAccountSwitchRelaunchFallback(callback, options)
	return ((options or {}).delay or Promise.delay)(getFIntAccountSwitchRelaunchFallbackSeconds()):andThen(function()
		callback()
	end)
end

return scheduleAccountSwitchRelaunchFallback
