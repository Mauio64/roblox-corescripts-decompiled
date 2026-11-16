local AuthAnalytics = script:FindFirstAncestor("AuthAnalytics")
local parent = AuthAnalytics.Parent

local TelemetryConfigs = require(AuthAnalytics.RobloxTelemetry.TelemetryConfigs)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local LoginStatus = RobloxAppEnums.LoginStatus

local SharedFlags = require(parent.SharedFlags)
local FFlagUseSignalsForAuthenticationStatus = SharedFlags.FFlagUseSignalsForAuthenticationStatus
local getAuthenticationStatusStore

if FFlagUseSignalsForAuthenticationStatus then
	local AuthenticationStatus = require(parent.AuthenticationStatus)
	getAuthenticationStatusStore = AuthenticationStatus.GetAuthenticationStatusStore
else
	getAuthenticationStatusStore = nil
end

local set = {
	[LoginStatus.UNKNOWN] = true,
	[LoginStatus.LOGGED_OUT] = true,
	[LoginStatus.LOGGED_IN] = true
}

local function normalizeAuthenticationStatusForTelemetry(p: string?) -- 1 equivalent call inferred from this helper
	if p == nil then
		return "NIL"
	end

	return if set[p] then p else "UNRECOGNIZED"
end

return function(p, object, callback)
	return function(object2)
		local v

		if FFlagUseSignalsForAuthenticationStatus then
			v = getAuthenticationStatusStore(false).getStatus(false)
		else
			v = object2:getState().AuthenticationStatus.status
		end

		if v == LoginStatus.LOGGED_IN then
			return
		end

		callback(p):andThen(function(_)
			object:logRobloxTelemetryCounter(TelemetryConfigs.ValidCookieForNoCachedUserTelemetryConfig, 1, {
				authenticationStatus = normalizeAuthenticationStatusForTelemetry(v) -- inferred equivalent call
			})
		end):catch(function(_) end)
	end
end
