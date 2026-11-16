local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
require(AbuseReportMenu.Components.Types)
local CorePackages = game:GetService("CorePackages")
local Constants = require(AbuseReportMenu.Components.Constants)
local ReportTypes = Constants.ReportTypes

local EventIngestService = game:GetService("EventIngestService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local ReportAnythingAnalytics = require(AbuseReportMenu.ReportAnything.Utility.ReportAnythingAnalytics)
local Analytics = require(CorePackages.Workspace.Packages.Analytics)
local EventIngest = Analytics.AnalyticsReporters.EventIngest
local Analytics2 = require(CorePackages.Workspace.Packages.Analytics)
local analytics = Analytics2.Analytics.new(RbxAnalyticsService)
local ReportAbuseAnalytics = require(AbuseReportMenu.Analytics.ReportAbuseAnalytics)
local collectAnalyticsParameters = require(AbuseReportMenu.Analytics.collectAnalyticsParameters)

local v = ReportAbuseAnalytics.new(
	EventIngest.new(EventIngestService),
	analytics.Diag,
	ReportAbuseAnalytics.MenuContexts.NewMenu
)

return function(p, callback, callback2, p2: string)
	return function(p3, callback3)
		if not p.menuEverShown then
			return
		end

		local v2

		if p2 == ReportTypes.Person then
			v2 = collectAnalyticsParameters.forPersonReport(p, p3, ReportAnythingAnalytics.getAccumulatedParameters())
		else
			v2 = collectAnalyticsParameters.forExperienceReport(
				p,
				p3,
				ReportAnythingAnalytics.getAccumulatedParameters()
			)
		end

		v:reportInGameAbuseReportInteraction(v2)

		callback3({ type = Constants.ReportAnythingActions.ClearAnnotationFlowProperties })

		callback({ type = Constants.AnalyticsActions.Reset })
		ReportAnythingAnalytics.clear()
		callback2(nil)
		v:endAbuseReportSession()
	end
end
