local ChatLineReporting = script:FindFirstAncestor("ChatLineReporting")
local EventIngestService = game:GetService("EventIngestService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local ChatLineReportingParent = ChatLineReporting.Parent
local EventIngest = require(ChatLineReportingParent.Analytics).AnalyticsReporters.EventIngest
local v6 = require(ChatLineReportingParent.Analytics).Analytics.new(RbxAnalyticsService)
local Cryo = require(ChatLineReportingParent.Cryo)

require(ChatLineReporting.Common.Types)

local t1 = {
	ReportTimeSpent = game:DefineFastString("ChatLineReportingTimeSpentStat", "TimeSpent"),
	SubmittedAbuseType = game:DefineFastString("ChatLineReportingSubmittedAbuseTypeStat", "SubmittedAbuseType")
}

function submitAnalytics(p1, n1: number, b1: boolean) -- line: 17
	-- upvalues: EventIngest (copy), EventIngestService (copy), v6 (copy), Cryo (copy), t1 (copy)
	local v12 = EventIngest.new(EventIngestService)
	local Diag = v6.Diag
	local v14 = math.floor(workspace:GetServerTimeNow() * 1000 - p1.accumulated_time_ms)
	local v15 = Cryo.Dictionary.join(p1, {
		accumulated_time_ms = v14,
		interaction_type = n1,
		mute_button_clicked = b1
	})
	local v16 = p1.context .. "_" .. t1.ReportTimeSpent
	local v17 = p1.context .. "_" .. t1.SubmittedAbuseType .. "_" .. p1.reason_selection

	Diag:reportStats(v16, v14)
	Diag:reportCounter(v17, 1)
	v12:sendEventDeferred(p1.context, p1.event_type, v15)
end

return submitAnalytics
