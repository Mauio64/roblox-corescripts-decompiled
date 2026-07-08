local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CorePackages = game:GetService("CorePackages")
local TelemetryService = game:GetService("TelemetryService")
local LoggingProtocol = require(CorePackages.Workspace.Packages.LoggingProtocol)
local EngineFeature = game:GetEngineFeature("TelemetryServicePlaySessionInfoEnabled")
local v6 = game:DefineFastInt("OpenReactPageThrottleHundredthsPercent", 0)
local v7 = game:DefineFastInt("CloseReactPageThrottleHundredthsPercent", 0)
local t1 = {}

t1.__index = t1
t1.configs = {
	openPage = {
		eventName = "ingame_menu_action",
		description = "Fires when a React menu page is opened",
		backends = { LoggingProtocol.TelemetryBackends.EventIngest },
		throttlingPercentage = v6,
		lastUpdated = {
			2025,
			9,
			23
		}
	},
	closePage = {
		eventName = "ingame_menu_action",
		description = "Fires when a React menu page is closed",
		backends = { LoggingProtocol.TelemetryBackends.EventIngest },
		throttlingPercentage = v7,
		lastUpdated = {
			2025,
			9,
			23
		}
	}
}

function t1.new() -- line: 52
	-- upvalues: t1 (copy)
	return (setmetatable({}, t1))
end
function t1._logEventWithStandardizedFields(_: {[any]: any}, p1, s1: string, t3: {[any]: any}?) -- line: 57
	-- upvalues: EngineFeature (copy), RbxAnalyticsService (copy), TelemetryService (copy)
	local t4 = {
		"addPlaceId",
		"addUniverseId",
		"addSessionInfo"
	}
	local v14 = t3 or {}

	if EngineFeature then
		table.insert(t4, "addPlaySessionId")
	else
		v14.playsessionid = RbxAnalyticsService:GetPlaySessionId()
	end

	TelemetryService:LogEvent(p1, {
		eventContext = s1,
		standardizedFields = t4,
		customFields = v14
	})
end
function t1.openPage(t5: {[any]: any}, s2: string) -- line: 74
	local v17 = `open_{ s2 }_page`

	t5:_logEventWithStandardizedFields(t5.configs.openPage, v17)
end
function t1.closePage(t6: {[any]: any}, s3: string) -- line: 79
	local v20 = `close_{ s3 }_page`

	t6:_logEventWithStandardizedFields(t6.configs.closePage, v20)
end

return t1
