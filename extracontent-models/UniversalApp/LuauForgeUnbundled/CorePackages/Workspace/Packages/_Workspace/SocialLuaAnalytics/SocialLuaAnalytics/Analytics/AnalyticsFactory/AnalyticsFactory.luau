local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/Cryo")

local createFireEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/FireEvent/createFireEvent")

require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Types")

local function AnalyticsFactory(data)
	local infoForAllEvents = data.infoForAllEvents or {}

	local function fn(p2)
		infoForAllEvents = Cryo.Dictionary.join(infoForAllEvents, p2)
		return infoForAllEvents
	end

	local function fn2()
		return infoForAllEvents
	end

	return {
		fireAnalyticsEvent = createFireEvent({
			EventStream = data.eventLists.EventStream,
			Diag = data.eventLists.Diag,
			Telemetry = data.eventLists.Telemetry
		})({
			analytics = {
				EventStream = data.analyticsImpl.EventStream,
				Diag = data.analyticsImpl.Diag,
				Telemetry = data.analyticsImpl.Telemetry
			},
			getInfoForAllEvents = fn2,
			loggerImpl = data.loggerImpl
		}),
		updateInfoForAllEvents = fn,
		getInfoForAllEvents = fn2
	}
end

return AnalyticsFactory
