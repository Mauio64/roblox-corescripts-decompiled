local SocialLuaAnalytics = script:FindFirstAncestor("SocialLuaAnalytics")
local parent = SocialLuaAnalytics.Parent

local Cryo = require(parent.Cryo)

local createFireEvent = require(SocialLuaAnalytics.Analytics.FireEvent.createFireEvent)

require(script.Parent.Parent.Types)

local function AnalyticsFactory(data)
	local infoForAllEvents = data.infoForAllEvents or {}

	local function fn(p)
		infoForAllEvents = Cryo.Dictionary.join(infoForAllEvents, p)
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
