local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialLuaAnalytics")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")

local v5 = { "addSessionInfo", "addOSInfo" }

local function defaultFormatCounter(p2, data)
	return {
		placement = data.placement,
		entryPoint = data.entryPoint,
		hasActiveParty = data.currentSquadId ~= nil
	}
end

local function namedCounterConfigurationAndFormat(p2, fn)
	return {
		type = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends.RobloxTelemetryCounter,
		overrideName = function()
			return p2
		end,
		format = function(p3, data)
			return Cryo.Dictionary.join({
				placement = data.placement,
				entryPoint = data.entryPoint,
				hasActiveParty = data.currentSquadId ~= nil
			}, fn(p3, data))
		end,
		throttlingThousandths = nil
	}
end

local function defaultFormatStat(p2, data)
	return {
		placement = data.placement,
		entryPoint = data.entryPoint,
		hasActiveParty = data.currentSquadId ~= nil
	}
end

local function defaultEventIngestFormat(p2, p3)
	return p3
end

local function eventIngestWithFormatFunction(fn)
	return {
		type = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends.EventIngest,
		standardizedFields = v5,
		format = function(p2, p3)
			return Cryo.Dictionary.join(p3, fn(p2, p3))
		end,
		overrideName = nil,
		throttlingThousandths = nil
	}
end

return {
	namedCounterConfigurationAndFormat = namedCounterConfigurationAndFormat,
	namedCounterConfigurationNoEmittedInfo = function(p2)
		return namedCounterConfigurationAndFormat(p2, function(p3, p4)
			return {}
		end)
	end,
	namedStatConfigurationAndFormat = function(p2, callback)
		return {
			type = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends.RobloxTelemetryStat,
			overrideName = function()
				return p2
			end,
			format = function(p3, data)
				return Cryo.Dictionary.join({
					placement = data.placement,
					entryPoint = data.entryPoint,
					hasActiveParty = data.currentSquadId ~= nil
				}, callback(p3, data))
			end,
			throttlingThousandths = nil
		}
	end,
	eventIngestWithFormatFunction = eventIngestWithFormatFunction,
	EVENT_INGEST_NO_EMITTED_INFO = eventIngestWithFormatFunction(function(p2, p3)
		return {}
	end),
	STANDARDIZED_FIELDS = v5
}
