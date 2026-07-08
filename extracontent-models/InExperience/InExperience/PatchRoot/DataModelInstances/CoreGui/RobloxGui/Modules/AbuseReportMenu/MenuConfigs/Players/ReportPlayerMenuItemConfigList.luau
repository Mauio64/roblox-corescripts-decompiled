local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")

require(AbuseReportMenu.Components.Types)

local MenuConfigs = AbuseReportMenu.MenuConfigs
local MethodOfAbuseModalMenuConfig = require(MenuConfigs.Players.MethodOfAbuseModalMenuConfig)
local OptionalAttachScreenshotMenuConfig = require(MenuConfigs.Players.OptionalAttachScreenshotMenuConfig)
local PlayerModalSelectorMenuConfig = require(MenuConfigs.Players.PlayerModalSelectorMenuConfig)
local ChatModalSelectorMenuConfig = require(MenuConfigs.Players.ChatModalSelectorMenuConfig)
local AbuseReasonModalSelectorMenuConfig = require(MenuConfigs.Players.AbuseReasonModalSelectorMenuConfig)
local SubmitReportButtonMenuConfig = require(MenuConfigs.Players.SubmitReportButtonMenuConfig)
local FreeFormCommentMenuConfig = require(MenuConfigs.Players.FreeFormCommentMenuConfig)

if require(CorePackages.Workspace.Packages.SharedFlags).FFlagInGameMenuAddChatLineReporting then
	return {
		MethodOfAbuseModalMenuConfig,
		PlayerModalSelectorMenuConfig,
		ChatModalSelectorMenuConfig,
		AbuseReasonModalSelectorMenuConfig,
		OptionalAttachScreenshotMenuConfig,
		FreeFormCommentMenuConfig,
		SubmitReportButtonMenuConfig
	}
end

return {
	MethodOfAbuseModalMenuConfig,
	PlayerModalSelectorMenuConfig,
	AbuseReasonModalSelectorMenuConfig,
	OptionalAttachScreenshotMenuConfig,
	FreeFormCommentMenuConfig,
	SubmitReportButtonMenuConfig
}
