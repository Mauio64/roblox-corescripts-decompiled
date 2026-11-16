local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CoreGui = game:GetService("CoreGui")
require(AbuseReportMenu.Components.Types)
local CorePackages = game:GetService("CorePackages")
local Constants = require(AbuseReportMenu.Components.Constants)
local getAvailableMethodsOfAbuse = require(AbuseReportMenu.Utility.getAvailableMethodsOfAbuse)
local TnSIXPWrapper = require(AbuseReportMenu.IXP.TnSIXPWrapper)
local RobloxGui = CoreGui.RobloxGui
local VoiceChatServiceManager = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager)
local default = VoiceChatServiceManager.default
local Cryo = require(CorePackages.Packages.Cryo)
local MethodOfAbuseModalMenuConfig = {}
MethodOfAbuseModalMenuConfig.componentType = "modalSelector"

function MethodOfAbuseModalMenuConfig.getIsVisible(p)
	return p.isVoiceEnabled or TnSIXPWrapper.getReportAnythingAvatarEnabled()
end

function MethodOfAbuseModalMenuConfig.getMenuItems(p)
	return getAvailableMethodsOfAbuse(
		p.isVoiceEnabled and not Cryo.isEmpty(default:getRecentUsersInteractionData()),
		TnSIXPWrapper.getReportAnythingAvatarEnabled()
	)
end

function MethodOfAbuseModalMenuConfig.getSelectedValue(p)
	return p.methodOfAbuse
end

function MethodOfAbuseModalMenuConfig.onUpdateSelectedOption(p, p2, callback, p3)
	callback({
		type = Constants.PlayerMenuActions.UpdateMethodOfAbuse,
		methodOfAbuse = p.identifier
	})

	if p.identifier ~= p2.methodOfAbuse then
		p3.reportAnythingDispatch({
			type = Constants.ReportAnythingActions.ClearAnnotationFlowProperties
		})

		p3.analyticsDispatch({ type = Constants.AnalyticsActions.IncrementTypeofabuseChanged })
		p3.analyticsDispatch({
			type = Constants.AnalyticsActions.SetTypeOfAbuseSelection,
			selection = p.identifier
		})
	end
end

MethodOfAbuseModalMenuConfig.fieldLabel = "MethodOfAbuse"
MethodOfAbuseModalMenuConfig.componentName = "MethodOfAbuse"
return MethodOfAbuseModalMenuConfig
