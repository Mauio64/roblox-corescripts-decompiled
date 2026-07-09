local AuthAnalytics = script:FindFirstAncestor("AuthAnalytics")
local AuthAnalyticsParent = AuthAnalytics.Parent
local TelemetryConfigs = require(AuthAnalytics.RobloxTelemetry.TelemetryConfigs)
local LoginStatus = require(AuthAnalyticsParent.RobloxAppEnums).LoginStatus
local t1 = {
	[LoginStatus.UNKNOWN] = true,
	[LoginStatus.LOGGED_OUT] = true,
	[LoginStatus.LOGGED_IN] = true
}

local function normalizeAuthenticationStatusForTelemetry(s1: string?) -- line: 17
	-- upvalues: t1 (copy)
	if s1 == nil then
		return "NIL"
	end

	if t1[s1] then
		return s1
	end

	return "UNRECOGNIZED"
end

return function(p1, p2, p3) -- line: 27
	-- upvalues: LoginStatus (copy), TelemetryConfigs (copy), t1 (copy)
	return function(p4) -- line: 30
		-- upvalues: LoginStatus (copy), p3 (copy), p1 (copy), p2 (copy), TelemetryConfigs (copy), t1 (copy)
		local status = p4:getState().AuthenticationStatus.status

		if status == LoginStatus.LOGGED_IN then
			return
		end

		p3(p1):andThen(function(_) -- line: 43
			-- upvalues: p2 (copy), TelemetryConfigs (copy), status (copy), t1 (copy)
			local v14 = p2
			local ValidCookieForNoCachedUserTelemetryConfig = TelemetryConfigs.ValidCookieForNoCachedUserTelemetryConfig
			local t2 = {}
			local v17 = status

			t2.authenticationStatus = if v17 ~= nil then not t1[v17] and "UNRECOGNIZED" or v17 else "NIL"
			v14:logRobloxTelemetryCounter(ValidCookieForNoCachedUserTelemetryConfig, 1, t2)
		end):catch(function(_) -- line: 54
		end)
	end
end
