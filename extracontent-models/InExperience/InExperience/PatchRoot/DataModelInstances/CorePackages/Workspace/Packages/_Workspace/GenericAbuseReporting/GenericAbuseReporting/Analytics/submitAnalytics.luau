local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local EventIngestService = game:GetService("EventIngestService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local EventIngest = require(GenericAbuseReportingParent.Analytics).AnalyticsReporters.EventIngest
local v6 = require(GenericAbuseReportingParent.Analytics).Analytics.new(RbxAnalyticsService)
local Cryo = require(GenericAbuseReportingParent.Cryo)

require(script.Parent.AnalyticsReducer)

local v8 = require(GenericAbuseReporting.Logger):new("AbuseReport Analytics")
local t1 = {
	ReportTimeSpent = game:DefineFastString("GenericAbuseReportingTimeSpentStat", "TimeSpent"),
	SubmittedAbuseType = game:DefineFastString("GenericAbuseReportingSubmittedAbuseTypeStat", "SubmittedAbuseType")
}
local t2 = {
	"Unspecified",
	"Submit",
	"Abandon"
}

local function submitAnalytics(p1, s1: string) -- line: 22
	-- upvalues: v6 (copy), t1 (copy), Cryo (copy), t2 (copy), EventIngest (copy), EventIngestService (copy), v8 (copy)
	local Diag = v6.Diag

	Diag:reportStats(p1.context .. "_" .. t1.ReportTimeSpent, p1.accumulated_time_ms)

	local v15 = p1.context .. "_" .. t1.SubmittedAbuseType .. "_" .. p1.reason_selection

	Diag:reportCounter(v15, 1)

	local v16 = math.floor(workspace:GetServerTimeNow() * 1000 - p1.accumulated_time_ms)
	local v17 = Cryo.Dictionary.union(p1, {
		accumulated_time_ms = v16,
		interaction_type = (table.find(t2, s1) or 1) - 1
	})

	EventIngest.new(EventIngestService):sendEventDeferred(p1.context, p1.event_type, v17)
	v8:info("Submitted. context: {} interaction_type: {} abuseTypeCategory: {} timeSpent (ms): {}", p1.context, s1, v15, v16)
end

return submitAnalytics
