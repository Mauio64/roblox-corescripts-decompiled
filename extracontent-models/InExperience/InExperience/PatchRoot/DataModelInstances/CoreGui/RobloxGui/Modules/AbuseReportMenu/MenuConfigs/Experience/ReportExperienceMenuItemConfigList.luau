local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")

require(AbuseReportMenu.Components.Types)

local MenuConfigs = AbuseReportMenu.MenuConfigs
local OptionalAttachScreenshotMenuConfig = require(MenuConfigs.Experience.OptionalAttachScreenshotMenuConfig)
local AbuseReasonMenuConfig = require(MenuConfigs.Experience.AbuseReasonMenuConfig)
local SubmitReportButtonMenuConfig = require(MenuConfigs.Experience.SubmitReportButtonMenuConfig)

return {
	AbuseReasonMenuConfig,
	OptionalAttachScreenshotMenuConfig,
	require(MenuConfigs.Experience.FreeFormCommentMenuConfig),
	SubmitReportButtonMenuConfig
}
