local socialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/dependencies").SocialLuaAnalytics

local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Analytics/Enums/EventNames")
local fireReportStats = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Analytics/fireReportStats")
local fireEventStream = socialLuaAnalytics.Analytics.FireEvent.fireEventStream
local fireDiagCounter = socialLuaAnalytics.Analytics.FireEvent.fireDiagCounter
local AnalyticsEvents = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Analytics/AnalyticsEvents")
local DiagEvents = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Analytics/DiagEvents")

return function(data)
	local v7 = if data.analytics then data.analytics.EventStream else data.eventStreamImpl
	local v8 = fireEventStream({
		eventStreamImpl = v7,
		eventList = AnalyticsEvents,
		infoForAllEvents = data.defaultAnalyticsInfo
	})

	local v11 = if data.analytics then data.analytics.Diag else data.diag
	local v12 = fireDiagCounter({ diagImpl = v11, eventList = DiagEvents })

	local v15 = if data.analytics then data.analytics.Diag else data.diag
	local v16 = fireReportStats({ diagImpl = v15, eventList = DiagEvents })

	return function(p2, p3)
		if DiagEvents[p2] then
			if p2 == EventNames.ContactImportingTime then
				v16(EventNames.ContactImportingTime, p3)
			else
				v12(p2)
			end
		end

		if AnalyticsEvents[p2] then
			v8(p2, p3)
		end
	end
end
