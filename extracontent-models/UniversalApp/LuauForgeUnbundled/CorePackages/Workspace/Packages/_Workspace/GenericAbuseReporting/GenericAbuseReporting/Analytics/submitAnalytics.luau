local EventIngestService = game:GetService("EventIngestService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local eventIngest = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Analytics").AnalyticsReporters.EventIngest
local analytics = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Analytics").Analytics.new(RbxAnalyticsService)
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Cryo")

require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Analytics/AnalyticsReducer")

local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Logger"):new("AbuseReport Analytics")

local v6 = {
	ReportTimeSpent = game:DefineFastString("GenericAbuseReportingTimeSpentStat", "TimeSpent"),
	SubmittedAbuseType = game:DefineFastString(
		"GenericAbuseReportingSubmittedAbuseTypeStat",
		"SubmittedAbuseType"
	)
}

local v7 = { "Unspecified", "Submit", "Abandon" }

local function submitAnalytics(data, p2)
	local diag = analytics.Diag

	diag:reportStats(data.context .. "_" .. v6.ReportTimeSpent, data.accumulated_time_ms)

	local v8 = data.context .. "_" .. v6.SubmittedAbuseType .. "_" .. data.reason_selection
	diag:reportCounter(v8, 1)

	local v9 = math.floor(workspace:GetServerTimeNow() * 1000 - data.accumulated_time_ms)

	local union = Cryo.Dictionary.union(data, {
		accumulated_time_ms = v9,
		interaction_type = (table.find(v7, p2) or 1) - 1
	})

	eventIngest.new(EventIngestService):sendEventDeferred(data.context, data.event_type, union)

	v5:info(
		"Submitted. context: {} interaction_type: {} abuseTypeCategory: {} timeSpent (ms): {}",
		data.context,
		p2,
		v8,
		v9
	)
end

return submitAnalytics
