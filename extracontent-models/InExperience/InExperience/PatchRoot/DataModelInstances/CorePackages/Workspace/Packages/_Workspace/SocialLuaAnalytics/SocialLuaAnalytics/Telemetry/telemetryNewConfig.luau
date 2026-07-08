local SocialLuaAnalytics = script:FindFirstAncestor("SocialLuaAnalytics")
local SocialLuaAnalyticsParent = SocialLuaAnalytics.Parent
local Cryo = require(SocialLuaAnalyticsParent.Cryo)

require(SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends)

local formatEventStreamFields = require(SocialLuaAnalytics.Telemetry.formatEventStreamFields)

require(SocialLuaAnalytics.Analytics.Enums.Contexts)

local function telemetryConfig(t1: {[any]: any}) -- line: 32
	-- upvalues: Cryo (copy), formatEventStreamFields (copy)
	return {
		name = t1.name,
		description = t1.description,
		eventStreamCtx = t1.eventStreamCtx,
		lastUpdated = t1.lastUpdated,
		backendsList = Cryo.List.map(t1.backendsList, function(p1) -- line: 38
			-- upvalues: formatEventStreamFields (copy), Cryo (copy)
			if p1.type == "EventIngest" then
				return Cryo.Dictionary.join(p1, {
					format = function(...) -- line: 41
						-- upvalues: p1 (copy), formatEventStreamFields (copy)
						local v8 = p1.format(...)

						return formatEventStreamFields(v8)
					end
				})
			end

			return p1
		end),
		throttlingThousandths = t1.throttlingThousandths
	}
end

return telemetryConfig
