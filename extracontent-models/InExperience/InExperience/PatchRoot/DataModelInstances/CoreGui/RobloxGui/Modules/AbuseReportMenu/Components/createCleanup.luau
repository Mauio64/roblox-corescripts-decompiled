local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")

require(AbuseReportMenu.Components.Types)

local CorePackages = game:GetService("CorePackages")
local Constants = require(AbuseReportMenu.Components.Constants)
local ReportTypes = Constants.ReportTypes
local EventIngestService = game:GetService("EventIngestService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local ReportAnythingAnalytics = require(AbuseReportMenu.ReportAnything.Utility.ReportAnythingAnalytics)
local EventIngest = require(CorePackages.Workspace.Packages.Analytics).AnalyticsReporters.EventIngest
local v9 = require(CorePackages.Workspace.Packages.Analytics).Analytics.new(RbxAnalyticsService)
local ReportAbuseAnalytics = require(AbuseReportMenu.Analytics.ReportAbuseAnalytics)
local collectAnalyticsParameters = require(AbuseReportMenu.Analytics.collectAnalyticsParameters)
local v12 = ReportAbuseAnalytics.new(EventIngest.new(EventIngestService), v9.Diag, ReportAbuseAnalytics.MenuContexts.NewMenu)

return function(p1, p2: ((...any) -> ...any), p3: ((...any) -> ...any), s1: string) -- line: 22
	-- upvalues: ReportTypes (copy), collectAnalyticsParameters (copy), ReportAnythingAnalytics (copy), v12 (copy), Constants (copy)
	return function(p4, p5) -- line: 28
		-- upvalues: p1 (copy), s1 (copy), ReportTypes (copy), collectAnalyticsParameters (copy), ReportAnythingAnalytics (copy), v12 (copy), Constants (copy), p2 (copy), p3 (copy)
		if not p1.menuEverShown then
			return
		end

		local v19 = if s1 ~= ReportTypes.Person then collectAnalyticsParameters.forExperienceReport(p1, p4, ReportAnythingAnalytics.getAccumulatedParameters()) else collectAnalyticsParameters.forPersonReport(p1, p4, ReportAnythingAnalytics.getAccumulatedParameters())

		v12:reportInGameAbuseReportInteraction(v19)
		p5({
			type = Constants.ReportAnythingActions.ClearAnnotationFlowProperties
		})
		p2({
			type = Constants.AnalyticsActions.Reset
		})
		ReportAnythingAnalytics.clear()
		p3(nil)
		v12:endAbuseReportSession()
	end
end
