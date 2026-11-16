local parent = script.Parent.Parent
local dependencies = require(parent.dependencies)
local EventIngestService = game:GetService("EventIngestService")
local eventIngest = dependencies.Analytics.AnalyticsReporters.EventIngest.new(EventIngestService)
local logging = dependencies.Logging
local parent2 = parent.Parent
local SharedFlags = require(parent2.SharedFlags)
local EventStreamConstants = require(parent.Constants.EventStreamConstants)
local FFlagEnableAuthAnalyticsPrintDebuggingDev = SharedFlags.FFlagEnableAuthAnalyticsPrintDebuggingDev

return function(p: string, p2: string, nows)
	nows[EventStreamConstants.EventTimingKeys.OsClock] = tostring(os.clock())
	nows[EventStreamConstants.EventTimingKeys.OsTime] = tostring(os.time())
	local v = {}

	for k, item in pairs(nows) do
		if type(k) == "string" then
			v[k] = item
		else
			logging.warn("Failure logging " .. p2 .. ": Expected " .. k .. " to be a string key but got " .. type(k))

			return
		end
	end

	if FFlagEnableAuthAnalyticsPrintDebuggingDev then
		local v2 = ""

		for k, v3 in pairs(v) do
			v2 ..= k .. ": " .. tostring(v3) .. ", "
		end

		local v3 = string.sub(v2, 1, -3)
		print("Emitting EventIngest " .. p2 .. ", context " .. p .. " with args: " .. v3)
	end

	eventIngest:sendEventDeferred(p, p2, v)
end
