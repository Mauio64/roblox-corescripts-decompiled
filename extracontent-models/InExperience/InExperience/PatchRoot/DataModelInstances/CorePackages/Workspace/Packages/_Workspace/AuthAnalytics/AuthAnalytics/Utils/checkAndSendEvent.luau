local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local EventIngestService = game:GetService("EventIngestService")
local v4 = dependencies.Analytics.AnalyticsReporters.EventIngest.new(EventIngestService)
local Logging = dependencies.Logging
local ParentParentParent = ParentParent.Parent
local SharedFlags = require(ParentParentParent.SharedFlags)
local EventStreamConstants = require(ParentParent.Constants.EventStreamConstants)
local FFlagEnableAuthAnalyticsPrintDebuggingDev = SharedFlags.FFlagEnableAuthAnalyticsPrintDebuggingDev

return function(s1: string, s2: string, t1: {[any]: any}) -- line: 11
	-- upvalues: EventStreamConstants (copy), Logging (copy), FFlagEnableAuthAnalyticsPrintDebuggingDev (copy), v4 (copy)
	local t2 = {}

	t1[EventStreamConstants.EventTimingKeys.OsClock] = tostring(os.clock())
	t1[EventStreamConstants.EventTimingKeys.OsTime] = tostring(os.time())

	for k, v in pairs(t1) do
		if type(k) ~= "string" then
			Logging.warn("Failure logging " .. s2 .. ": Expected " .. k .. " to be a string key but got " .. type(k))

			return
		end

		t2[k] = v
	end

	if FFlagEnableAuthAnalyticsPrintDebuggingDev then
		local s3 = ""

		for k, v in pairs(t2) do
			s3 ..= k .. ": " .. tostring(v) .. ", "
		end

		local v19 = string.sub(s3, 1, -3)

		print("Emitting EventIngest " .. s2 .. ", context " .. s1 .. " with args: " .. v19)
	end

	v4:sendEventDeferred(s1, s2, t2)
end
