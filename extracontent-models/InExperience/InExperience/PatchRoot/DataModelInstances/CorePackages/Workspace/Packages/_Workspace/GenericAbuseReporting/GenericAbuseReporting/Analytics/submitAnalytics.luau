local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local EventIngestService = game:GetService("EventIngestService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local parent = GenericAbuseReporting.Parent

local Analytics = require(parent.Analytics)
local EventIngest = Analytics.AnalyticsReporters.EventIngest
local Analytics2 = require(parent.Analytics)
local analytics = Analytics2.Analytics.new(RbxAnalyticsService)
local Cryo = require(parent.Cryo)

require(script.Parent.AnalyticsReducer)

local Logger = require(GenericAbuseReporting.Logger)
local v = Logger:new("AbuseReport Analytics")

local v2 = {
	ReportTimeSpent = game:DefineFastString("GenericAbuseReportingTimeSpentStat", "TimeSpent"),
	SubmittedAbuseType = game:DefineFastString("GenericAbuseReportingSubmittedAbuseTypeStat", "SubmittedAbuseType")
}

local v3 = { "Unspecified", "Submit", "Abandon" }

local function submitAnalytics(data, p: string)
	local diag = analytics.Diag

	diag:reportStats(data.context .. "_" .. v2.ReportTimeSpent, data.accumulated_time_ms)

	local v4 = data.context .. "_" .. v2.SubmittedAbuseType .. "_" .. data.reason_selection
	diag:reportCounter(v4, 1)

	local accumulated_time_ms = math.floor(workspace:GetServerTimeNow() * 1000 - data.accumulated_time_ms)

	local union = Cryo.Dictionary.union(data, {
		accumulated_time_ms = accumulated_time_ms,
		interaction_type = (table.find(v3, p) or 1) - 1
	})

	EventIngest.new(EventIngestService):sendEventDeferred(data.context, data.event_type, union)

	v:info(
		"Submitted. context: {} interaction_type: {} abuseTypeCategory: {} timeSpent (ms): {}",
		data.context,
		p,
		v4,
		accumulated_time_ms
	)
end

return submitAnalytics
