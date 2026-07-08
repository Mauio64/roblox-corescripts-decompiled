local TelemetryService = game:GetService("TelemetryService")
local ParentParent = script.Parent.Parent
local SafeFlags = require(ParentParent.SafeFlags)
local ReactGlobals = require(ParentParent.ReactGlobals)
local v5 = SafeFlags.createGetFFlag("ReactTelemetryEnabled", false)()

local function reportCounter(t1: {[any]: any}) -- line: 19
	-- upvalues: v5 (copy), TelemetryService (copy), ReactGlobals (copy)
	if not v5 then
		return
	end

	local t2 = {
		eventName = t1.eventName,
		backends = { "RobloxTelemetryCounter" },
		lastUpdated = t1.lastUpdated,
		description = t1.description,
		links = t1.links
	}
	local t3 = {
		customFields = t1.customFields or {}
	}
	local ok, result = pcall(TelemetryService.LogCounter, TelemetryService, t2, t3, t1.value)

	if ReactGlobals.__DEV__ and not ok then
		warn(`React telemetry collection is enabled but log failed: { result }`)
	end
end

return reportCounter
