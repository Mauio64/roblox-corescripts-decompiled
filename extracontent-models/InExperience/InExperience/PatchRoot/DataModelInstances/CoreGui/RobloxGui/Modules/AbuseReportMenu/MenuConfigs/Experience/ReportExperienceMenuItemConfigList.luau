local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
require(AbuseReportMenu.Components.Types)
local MenuConfigs = AbuseReportMenu.MenuConfigs

local OptionalAttachScreenshotMenuConfig = require(MenuConfigs.Experience.OptionalAttachScreenshotMenuConfig)
local AbuseReasonMenuConfig = require(MenuConfigs.Experience.AbuseReasonMenuConfig)
local SubmitReportButtonMenuConfig = require(MenuConfigs.Experience.SubmitReportButtonMenuConfig)
local FreeFormCommentMenuConfig = require(MenuConfigs.Experience.FreeFormCommentMenuConfig)

return {
	AbuseReasonMenuConfig,
	OptionalAttachScreenshotMenuConfig,
	FreeFormCommentMenuConfig,
	SubmitReportButtonMenuConfig
}
