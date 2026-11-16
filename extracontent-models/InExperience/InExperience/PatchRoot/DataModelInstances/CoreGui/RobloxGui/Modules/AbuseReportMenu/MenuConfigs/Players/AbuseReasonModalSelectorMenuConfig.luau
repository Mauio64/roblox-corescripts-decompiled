local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local Constants = require(AbuseReportMenu.Components.Constants)
require(AbuseReportMenu.Components.Types)
local Cryo = require(CorePackages.Packages.Cryo)
local AbuseReasonModalSelectorMenuConfig = {}
AbuseReasonModalSelectorMenuConfig.componentType = "modalSelector"

function AbuseReasonModalSelectorMenuConfig.getIsVisible(_): boolean
	return true
end

function AbuseReasonModalSelectorMenuConfig.getMenuItems(p, p2)
	local v

	if p.methodOfAbuse == Constants.AbuseMethods.VoiceChat then
		v = Constants.PlayerVoiceAbuseTypes
	else
		v = Constants.PlayerAbuseTypes
	end

	local values = Cryo.Dictionary.values(v)
	return Cryo.List.map(values, function(identifier)
		return { label = p2[identifier], identifier = identifier }
	end)
end

function AbuseReasonModalSelectorMenuConfig.getSelectedValue(p)
	return p.abuseReason
end

function AbuseReasonModalSelectorMenuConfig.onUpdateSelectedOption(p, _, callback, p2)
	p2.analyticsDispatch({ type = Constants.AnalyticsActions.IncrementReasonChanged })
	p2.analyticsDispatch({
		type = Constants.AnalyticsActions.SetReasonSelection,
		selection = p.identifier
	})

	callback({ type = Constants.PlayerMenuActions.UpdateAbuseReason, abuseReason = p.identifier })
end

AbuseReasonModalSelectorMenuConfig.fieldLabel = "ReasonForAbuse"
AbuseReasonModalSelectorMenuConfig.componentName = "AbuseReason"
return AbuseReasonModalSelectorMenuConfig
