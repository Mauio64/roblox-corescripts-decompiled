local dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthAnalytics/AuthAnalytics/dependencies")
local EventIngestService = game:GetService("EventIngestService")
local eventIngest = dependencies.Analytics.AnalyticsReporters.EventIngest.new(EventIngestService)
local logging = dependencies.Logging

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthAnalytics/SharedFlags")
local EventStreamConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthAnalytics/AuthAnalytics/Constants/EventStreamConstants")
local fFlagEnableAuthAnalyticsPrintDebuggingDev = SharedFlags.FFlagEnableAuthAnalyticsPrintDebuggingDev

return function(p2, p3, nows)
	nows[EventStreamConstants.EventTimingKeys.OsClock] = tostring(os.clock())
	nows[EventStreamConstants.EventTimingKeys.OsTime] = tostring(os.time())
	local v5 = {}

	for k, item in pairs(nows) do
		if type(k) == "string" then
			v5[k] = item
		else
			logging.warn("Failure logging " .. p3 .. ": Expected " .. k .. " to be a string key but got " .. type(k))

			return
		end
	end

	if fFlagEnableAuthAnalyticsPrintDebuggingDev then
		local v6 = ""

		for k, v7 in pairs(v5) do
			v6 ..= k .. ": " .. tostring(v7) .. ", "
		end

		local v7 = (string.sub)(v6, 1, -3)
		print("Emitting EventIngest " .. p3 .. ", context " .. p2 .. " with args: " .. v7)
	end

	eventIngest:sendEventDeferred(p2, p3, v5)
end
