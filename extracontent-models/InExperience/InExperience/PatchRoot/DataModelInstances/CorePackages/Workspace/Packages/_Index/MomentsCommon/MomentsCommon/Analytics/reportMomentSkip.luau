local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local MomentsCommonParent = MomentsCommon.Parent
local LoggingProtocol = require(MomentsCommonParent.LoggingProtocol)
local GetFFlagMomentsAnalyticsSchemaIdentity = require(MomentsCommon.Flags.GetFFlagMomentsAnalyticsSchemaIdentity)
local t1 = {
	eventName = "MomentsAnalyticsSkip",
	throttlingPercentage = 10000,
	description = "Counts schema-targeted moment-scoped analytics events SKIPPED because the raw feedItemId was absent (FFlagMomentsAnalyticsSchemaIdentity). Dimensioned by surface/reason/entry; the flag-B ramp gate watches this before enabling the flag broadly.",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = {
		2026,
		7,
		7
	}
}

local function defaultEmit(p1, n1: number, t2: {[any]: any}) -- line: 67
	-- upvalues: LoggingProtocol (copy)
	LoggingProtocol.default:logRobloxTelemetryCounter(p1, n1, t2)
end
local function reportMomentSkip(s1: string, s2: string, t3: {[any]: any}?, p2: ((...any) -> ...any)?) -- line: 81
	-- upvalues: GetFFlagMomentsAnalyticsSchemaIdentity (copy), defaultEmit (copy), t1 (copy)
	if not GetFFlagMomentsAnalyticsSchemaIdentity() then
		return
	end

	local t4 = {
		surface = s1,
		reason = s2
	}

	if t3 then
		if t3.entry ~= nil then
			t4.entry = t3.entry
		end

		if t3.action ~= nil then
			t4.action = t3.action
		end

		if t3.parentEntity ~= nil then
			t4.parentEntity = t3.parentEntity
		end
	end;

	(p2 or defaultEmit)(t1, 1, t4)
end

return reportMomentSkip
