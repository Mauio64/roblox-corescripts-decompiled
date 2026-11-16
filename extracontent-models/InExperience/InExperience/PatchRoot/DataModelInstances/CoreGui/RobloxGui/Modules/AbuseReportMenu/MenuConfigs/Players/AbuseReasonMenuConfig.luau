local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local Constants = require(AbuseReportMenu.Components.Constants)
require(AbuseReportMenu.Components.Types)
local Cryo = require(CorePackages.Packages.Cryo)
local AbuseReasonMenuConfig = {}
AbuseReasonMenuConfig.componentType = "dropdown"

function AbuseReasonMenuConfig.getIsVisible(_): boolean
	return true
end

function AbuseReasonMenuConfig.getMenuItems(p)
	local v

	if p.methodOfAbuse == "Voice Chat" then
		v = Constants.PlayerVoiceAbuseTypes
	else
		v = Constants.PlayerAbuseTypes
	end

	return Cryo.Dictionary.values(v)
end

function AbuseReasonMenuConfig.onUpdateSelectedOption(p, _, callback, p2)
	p2.analyticsDispatch({ type = Constants.AnalyticsActions.IncrementReasonChanged })
	p2.analyticsDispatch({ type = Constants.AnalyticsActions.SetReasonSelection, selection = p })

	callback({ type = Constants.PlayerMenuActions.UpdateAbuseReason, abuseReason = p })
end

AbuseReasonMenuConfig.fieldLabel = "ReasonForAbuse"
AbuseReasonMenuConfig.componentName = "AbuseReason"
return AbuseReasonMenuConfig
