local ChatLineReporting = script:FindFirstAncestor("ChatLineReporting")
local EventIngestService = game:GetService("EventIngestService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local parent = ChatLineReporting.Parent

local Analytics = require(parent.Analytics)
local EventIngest = Analytics.AnalyticsReporters.EventIngest
local Analytics2 = require(parent.Analytics)
local analytics = Analytics2.Analytics.new(RbxAnalyticsService)
local Cryo = require(parent.Cryo)

require(ChatLineReporting.Common.Types)

local v = {
	ReportTimeSpent = game:DefineFastString("ChatLineReportingTimeSpentStat", "TimeSpent"),
	SubmittedAbuseType = game:DefineFastString("ChatLineReportingSubmittedAbuseTypeStat", "SubmittedAbuseType")
}

function submitAnalytics(data, interaction_type: number, mute_button_clicked: boolean)
	local v2 = EventIngest.new(EventIngestService)
	local diag = analytics.Diag

	local accumulated_time_ms = math.floor(workspace:GetServerTimeNow() * 1000 - data.accumulated_time_ms)
	local joined = Cryo.Dictionary.join(data, {
		accumulated_time_ms = accumulated_time_ms,
		interaction_type = interaction_type,
		mute_button_clicked = mute_button_clicked
	})

	local v3 = data.context .. "_" .. v.ReportTimeSpent
	local v4 = data.context .. "_" .. v.SubmittedAbuseType .. "_" .. data.reason_selection

	diag:reportStats(v3, accumulated_time_ms)
	diag:reportCounter(v4, 1)
	v2:sendEventDeferred(data.context, data.event_type, joined)
end

return submitAnalytics
