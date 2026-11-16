local parent = script:FindFirstAncestor("AppChat").Parent
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local Cryo = require(parent.Cryo)

local standardizedFields = { "addSessionInfo", "addOSInfo" }

local function defaultFormatCounter(_, data) -- 1 equivalent call inferred from this helper
	return {
		placement = data.placement,
		entryPoint = data.entryPoint,
		hasActiveParty = data.currentSquadId ~= nil
	}
end

local function namedCounterConfigurationAndFormat(p: string, fn)
	return {
		type = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends.RobloxTelemetryCounter,
		overrideName = function()
			return p
		end,
		format = function(p2, data)
			return Cryo.Dictionary.join(defaultFormatCounter(nil, data), fn(p2, data)) -- inferred equivalent call
		end,
		throttlingThousandths = nil
	}
end

local function defaultFormatStat(_, data) -- 1 equivalent call inferred from this helper
	return {
		placement = data.placement,
		entryPoint = data.entryPoint,
		hasActiveParty = data.currentSquadId ~= nil
	}
end

local function defaultEventIngestFormat(_, p)
	return p
end

local function eventIngestWithFormatFunction(fn)
	return {
		type = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends.EventIngest,
		standardizedFields = standardizedFields,
		format = function(p, p2)
			return Cryo.Dictionary.join(p2, fn(p, p2))
		end,
		overrideName = nil,
		throttlingThousandths = nil
	}
end

local DefaultTelemetryEvents = {}
DefaultTelemetryEvents.namedCounterConfigurationAndFormat = namedCounterConfigurationAndFormat

function DefaultTelemetryEvents.namedCounterConfigurationNoEmittedInfo(p: string)
	return namedCounterConfigurationAndFormat(p, function(_, _)
		return {}
	end)
end

function DefaultTelemetryEvents.namedStatConfigurationAndFormat(p: string, callback)
	return {
		type = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends.RobloxTelemetryStat,
		overrideName = function()
			return p
		end,
		format = function(p2, data)
			return Cryo.Dictionary.join(defaultFormatStat(nil, data), callback(p2, data)) -- inferred equivalent call
		end,
		throttlingThousandths = nil
	}
end

DefaultTelemetryEvents.eventIngestWithFormatFunction = eventIngestWithFormatFunction
DefaultTelemetryEvents.EVENT_INGEST_NO_EMITTED_INFO = eventIngestWithFormatFunction(function(_, _)
	return {}
end)
DefaultTelemetryEvents.STANDARDIZED_FIELDS = standardizedFields
return DefaultTelemetryEvents
