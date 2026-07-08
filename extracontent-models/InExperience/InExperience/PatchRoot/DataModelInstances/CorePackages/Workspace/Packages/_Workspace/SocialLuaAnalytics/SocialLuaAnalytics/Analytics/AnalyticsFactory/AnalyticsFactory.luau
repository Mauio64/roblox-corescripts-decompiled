local SocialLuaAnalytics = script:FindFirstAncestor("SocialLuaAnalytics")
local SocialLuaAnalyticsParent = SocialLuaAnalytics.Parent
local Cryo = require(SocialLuaAnalyticsParent.Cryo)
local createFireEvent = require(SocialLuaAnalytics.Analytics.FireEvent.createFireEvent)

require(script.Parent.Parent.Types)

local function AnalyticsFactory(t1: {[any]: any}) -- line: 34
	-- upvalues: Cryo (copy), createFireEvent (copy)
	local u7 = t1.infoForAllEvents or {}

	local function v8() -- line: 42
		-- upvalues: u7 (ref)
		return u7
	end

	return {
		fireAnalyticsEvent = createFireEvent({
			EventStream = t1.eventLists.EventStream,
			Diag = t1.eventLists.Diag,
			Telemetry = t1.eventLists.Telemetry
		})({
			analytics = {
				EventStream = t1.analyticsImpl.EventStream,
				Diag = t1.analyticsImpl.Diag,
				Telemetry = t1.analyticsImpl.Telemetry
			},
			getInfoForAllEvents = v8,
			loggerImpl = t1.loggerImpl
		}),
		updateInfoForAllEvents = function(p1) -- line: 37
			-- upvalues: u7 (ref), Cryo (copy)
			u7 = Cryo.Dictionary.join(u7, p1)

			return u7
		end,
		getInfoForAllEvents = v8
	}
end

return AnalyticsFactory
