local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/Cryo")
require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Enums/SupportedTelemetryBackends")
local formatEventStreamFields = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Telemetry/formatEventStreamFields")
require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Enums/Contexts")

local function telemetryConfig(data)
	return {
		name = data.name,
		description = data.description,
		eventStreamCtx = data.eventStreamCtx,
		lastUpdated = data.lastUpdated,
		backendsList = Cryo.List.map(data.backendsList, function(p2)
			if p2.type ~= "EventIngest" then
				return p2
			end

			local function fn(...)
				return formatEventStreamFields((p2.format(...)))
			end

			return Cryo.Dictionary.join(p2, { format = fn })
		end),
		throttlingThousandths = data.throttlingThousandths
	}
end

return telemetryConfig
