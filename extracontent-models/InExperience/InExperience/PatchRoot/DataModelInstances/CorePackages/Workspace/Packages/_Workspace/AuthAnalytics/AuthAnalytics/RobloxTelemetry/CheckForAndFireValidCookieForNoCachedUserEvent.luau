local AuthAnalytics = script:FindFirstAncestor("AuthAnalytics")
local AuthAnalyticsParent = AuthAnalytics.Parent
local TelemetryConfigs = require(AuthAnalytics.RobloxTelemetry.TelemetryConfigs)
local LoginStatus = require(AuthAnalyticsParent.RobloxAppEnums).LoginStatus
local FFlagUseSignalsForAuthenticationStatus = require(AuthAnalyticsParent.SharedFlags).FFlagUseSignalsForAuthenticationStatus
local v6 = if not FFlagUseSignalsForAuthenticationStatus then nil else require(AuthAnalyticsParent.AuthenticationStatus).GetAuthenticationStatusStore
local t1 = {
	[LoginStatus.UNKNOWN] = true,
	[LoginStatus.LOGGED_OUT] = true,
	[LoginStatus.LOGGED_IN] = true
}

local function normalizeAuthenticationStatusForTelemetry(s1: string?) -- line: 24
	-- upvalues: t1 (copy)
	if s1 == nil then
		return "NIL"
	end

	if t1[s1] then
		return s1
	end

	return "UNRECOGNIZED"
end

return function(p1, p2, p3) -- line: 34
	-- upvalues: FFlagUseSignalsForAuthenticationStatus (copy), v6 (copy), LoginStatus (copy), TelemetryConfigs (copy), t1 (copy)
	return function(p4) -- line: 37
		-- upvalues: FFlagUseSignalsForAuthenticationStatus (copy), v6 (copy), LoginStatus (copy), p3 (copy), p1 (copy), p2 (copy), TelemetryConfigs (copy), t1 (copy)
		local v14 = if not FFlagUseSignalsForAuthenticationStatus then p4:getState().AuthenticationStatus.status else v6(false).getStatus(false)

		if v14 == LoginStatus.LOGGED_IN then
			return
		end

		p3(p1):andThen(function(_) -- line: 52
			-- upvalues: p2 (copy), TelemetryConfigs (copy), v14 (copy), t1 (copy)
			local v16 = p2
			local ValidCookieForNoCachedUserTelemetryConfig = TelemetryConfigs.ValidCookieForNoCachedUserTelemetryConfig
			local t2 = {}
			local v19 = v14

			t2.authenticationStatus = if v19 ~= nil then not t1[v19] and "UNRECOGNIZED" or v19 else "NIL"
			v16:logRobloxTelemetryCounter(ValidCookieForNoCachedUserTelemetryConfig, 1, t2)
		end):catch(function(_) -- line: 63
		end)
	end
end
