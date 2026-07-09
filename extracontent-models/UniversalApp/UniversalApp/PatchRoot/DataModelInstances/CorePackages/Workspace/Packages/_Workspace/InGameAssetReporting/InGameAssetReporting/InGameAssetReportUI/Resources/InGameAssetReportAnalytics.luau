local InGameAssetReporting = script:FindFirstAncestor("InGameAssetReporting")
local EventIngestService = game:GetService("EventIngestService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local InGameAssetReportingParent = InGameAssetReporting.Parent
local EventIngest = require(InGameAssetReportingParent.Analytics).AnalyticsReporters.EventIngest
local v6 = require(InGameAssetReportingParent.Analytics).Analytics.new(RbxAnalyticsService)
local Cryo = require(InGameAssetReportingParent.Cryo)

require(InGameAssetReporting.InGameAssetReportUI.Resources.Types)

local t1 = {
	ReportTimeSpent = game:DefineFastString("InGameAssetReportingTimeSpentStat", "TimeSpent"),
	SubmittedAbuseType = game:DefineFastString("InGameAssetReportingSubmittedAbuseTypeStat", "SubmittedAbuseType")
}

function submitAnalytics(p1, n1: number) -- line: 17
	-- upvalues: EventIngest (copy), EventIngestService (copy), v6 (copy), Cryo (copy), t1 (copy)
	local v11 = EventIngest.new(EventIngestService)
	local Diag = v6.Diag
	local v13 = math.floor(workspace:GetServerTimeNow() * 1000 - p1.accumulated_time_ms)
	local v14 = Cryo.Dictionary.join(p1, {
		accumulated_time_ms = v13,
		interaction_type = n1
	})
	local v15 = p1.context .. "_" .. t1.ReportTimeSpent
	local v16 = p1.context .. "_" .. t1.SubmittedAbuseType .. "_" .. p1.reason_selection

	Diag:reportStats(v15, v13)
	Diag:reportCounter(v16, 1)
	v11:sendEventDeferred(p1.context, p1.event_type, v14)
end

return submitAnalytics
