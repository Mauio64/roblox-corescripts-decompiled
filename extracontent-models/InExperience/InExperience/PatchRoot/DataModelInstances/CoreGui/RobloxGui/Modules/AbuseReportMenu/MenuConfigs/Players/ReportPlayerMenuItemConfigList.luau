local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
require(AbuseReportMenu.Components.Types)
local MenuConfigs = AbuseReportMenu.MenuConfigs

local MethodOfAbuseModalMenuConfig = require(MenuConfigs.Players.MethodOfAbuseModalMenuConfig)
local OptionalAttachScreenshotMenuConfig = require(MenuConfigs.Players.OptionalAttachScreenshotMenuConfig)
local PlayerModalSelectorMenuConfig = require(MenuConfigs.Players.PlayerModalSelectorMenuConfig)
local AbuseReasonModalSelectorMenuConfig = require(MenuConfigs.Players.AbuseReasonModalSelectorMenuConfig)
local SubmitReportButtonMenuConfig = require(MenuConfigs.Players.SubmitReportButtonMenuConfig)
local FreeFormCommentMenuConfig = require(MenuConfigs.Players.FreeFormCommentMenuConfig)

return {
	MethodOfAbuseModalMenuConfig,
	PlayerModalSelectorMenuConfig,
	AbuseReasonModalSelectorMenuConfig,
	OptionalAttachScreenshotMenuConfig,
	FreeFormCommentMenuConfig,
	SubmitReportButtonMenuConfig
}
