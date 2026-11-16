local TelemetryConfigs = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthAnalytics/AuthAnalytics/RobloxTelemetry/TelemetryConfigs")
local loginStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthAnalytics/RobloxAppEnums").LoginStatus

local fFlagUseSignalsForAuthenticationStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthAnalytics/SharedFlags").FFlagUseSignalsForAuthenticationStatus
local getAuthenticationStatusStore

if fFlagUseSignalsForAuthenticationStatus then
	getAuthenticationStatusStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthAnalytics/AuthenticationStatus").GetAuthenticationStatusStore
else
	getAuthenticationStatusStore = nil
end

local set = {
	[loginStatus.UNKNOWN] = true,
	[loginStatus.LOGGED_OUT] = true,
	[loginStatus.LOGGED_IN] = true
}

local function normalizeAuthenticationStatusForTelemetry(p2)
	if p2 == nil then
		return "NIL"
	end

	if set[p2] then
		return p2
	end

	return "UNRECOGNIZED"
end

return function(p2, p3, callback)
	return function(object)
		local v5

		if fFlagUseSignalsForAuthenticationStatus then
			v5 = getAuthenticationStatusStore(false).getStatus(false)
		else
			v5 = object:getState().AuthenticationStatus.status
		end

		if v5 == loginStatus.LOGGED_IN then
			return
		end

		callback(p2):andThen(function(p4)
			local v8 = v5
			p3:logRobloxTelemetryCounter(TelemetryConfigs.ValidCookieForNoCachedUserTelemetryConfig, 1, {
				authenticationStatus = v8 == nil and "NIL" or not set[v8] and "UNRECOGNIZED" or v8
			})
		end):catch(function(p4) end)
	end
end
