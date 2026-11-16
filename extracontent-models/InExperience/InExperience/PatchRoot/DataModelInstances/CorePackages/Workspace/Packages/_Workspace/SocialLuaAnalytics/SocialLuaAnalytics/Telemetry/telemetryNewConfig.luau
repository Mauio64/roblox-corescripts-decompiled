local SocialLuaAnalytics = script:FindFirstAncestor("SocialLuaAnalytics")
local parent = SocialLuaAnalytics.Parent
local Cryo = require(parent.Cryo)
require(SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends)
local formatEventStreamFields = require(SocialLuaAnalytics.Telemetry.formatEventStreamFields)
require(SocialLuaAnalytics.Analytics.Enums.Contexts)

local function telemetryConfig(data)
	return {
		name = data.name,
		description = data.description,
		eventStreamCtx = data.eventStreamCtx,
		lastUpdated = data.lastUpdated,
		backendsList = Cryo.List.map(data.backendsList, function(p)
			if p.type ~= "EventIngest" then
				return p
			end

			local function fn(...)
				return formatEventStreamFields((p.format(...)))
			end

			return Cryo.Dictionary.join(p, { format = fn })
		end),
		throttlingThousandths = data.throttlingThousandths
	}
end

return telemetryConfig
