local Parent = script:FindFirstAncestor("AppChat").Parent
local SocialLuaAnalytics = require(Parent.SocialLuaAnalytics)
local Cryo = require(Parent.Cryo)
local t1 = {
	"addSessionInfo",
	"addOSInfo"
}

local function defaultFormatCounter(_, p2) -- line: 18
	return {
		placement = p2.placement,
		entryPoint = p2.entryPoint,
		hasActiveParty = p2.currentSquadId ~= nil
	}
end
local function namedCounterConfigurationAndFormat(s1: string, p3: ((...any) -> ...any)) -- line: 25
	-- upvalues: SocialLuaAnalytics (copy), Cryo (copy), t1 (copy)
	return {
		throttlingThousandths = nil,
		type = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends.RobloxTelemetryCounter,
		overrideName = function() -- line: 31
			-- upvalues: s1 (copy)
			return s1
		end,
		format = function(p4, p5) -- line: 34
			-- upvalues: Cryo (copy), p3 (copy)
			return Cryo.Dictionary.join({
				placement = p5.placement,
				entryPoint = p5.entryPoint,
				hasActiveParty = p5.currentSquadId ~= nil
			}, p3(p4, p5))
		end,
		standardizedFields = t1
	}
end
local function defaultFormatStat(_, p7) -- line: 51
	return {
		placement = p7.placement,
		entryPoint = p7.entryPoint,
		hasActiveParty = p7.currentSquadId ~= nil
	}
end
local function defaultEventIngestFormat(_, p9) -- line: 75
	return p9
end
local function eventIngestWithFormatFunction(p10: ((...any) -> ...any)) -- line: 78
	-- upvalues: SocialLuaAnalytics (copy), t1 (copy), Cryo (copy)
	return {
		overrideName = nil,
		throttlingThousandths = nil,
		type = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends.EventIngest,
		standardizedFields = t1,
		format = function(p11, p12) -- line: 84
			-- upvalues: Cryo (copy), p10 (copy)
			return Cryo.Dictionary.join(p12, p10(p11, p12))
		end
	}
end

local v10 = eventIngestWithFormatFunction(function(_, _) -- line: 95
	return {}
end)

return {
	namedCounterConfigurationAndFormat = namedCounterConfigurationAndFormat,
	namedCounterConfigurationNoEmittedInfo = function(s2: string) -- line: 41
		-- upvalues: namedCounterConfigurationAndFormat (copy)
		return (namedCounterConfigurationAndFormat(s2, function(_, _) -- line: 44
			return {}
		end))
	end,
	namedStatConfigurationAndFormat = function(s3: string, p17: ((...any) -> ...any)) -- line: 58
		-- upvalues: SocialLuaAnalytics (copy), Cryo (copy), t1 (copy)
		return {
			throttlingThousandths = nil,
			type = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends.RobloxTelemetryStat,
			overrideName = function() -- line: 64
				-- upvalues: s3 (copy)
				return s3
			end,
			format = function(p18, p19) -- line: 67
				-- upvalues: Cryo (copy), p17 (copy)
				return Cryo.Dictionary.join({
					placement = p19.placement,
					entryPoint = p19.entryPoint,
					hasActiveParty = p19.currentSquadId ~= nil
				}, p17(p18, p19))
			end,
			standardizedFields = t1
		}
	end,
	eventIngestWithFormatFunction = eventIngestWithFormatFunction,
	EVENT_INGEST_NO_EMITTED_INFO = v10,
	STANDARDIZED_FIELDS = t1
}
