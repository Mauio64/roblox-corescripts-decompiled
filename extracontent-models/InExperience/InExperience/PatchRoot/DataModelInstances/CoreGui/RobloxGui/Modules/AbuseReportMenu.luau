local CorePackages = game:GetService("CorePackages")
local FFlagAbuseReportMenuV2 = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAbuseReportMenuV2
local AbuseReportMenuNew = require(script.Components.AbuseReportMenuNew)
local v4 = if not FFlagAbuseReportMenuV2 then nil else require(script.V2.AbuseReportMenu)
local ReportAbuseAnalytics = require(script.Analytics.ReportAbuseAnalytics)

return {
	AbuseReportMenu = AbuseReportMenuNew,
	AbuseReportMenuV2 = v4,
	ReportAbuseAnalytics = ReportAbuseAnalytics,
	["jest.config"] = script["jest.config"]
}
