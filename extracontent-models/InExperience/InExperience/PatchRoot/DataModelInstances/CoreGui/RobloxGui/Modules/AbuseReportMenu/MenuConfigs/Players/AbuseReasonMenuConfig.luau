local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local Constants = require(AbuseReportMenu.Components.Constants)

require(AbuseReportMenu.Components.Types)

local Cryo = require(CorePackages.Packages.Cryo)

return {
	componentType = "dropdown",
	fieldLabel = "ReasonForAbuse",
	componentName = "AbuseReason",
	getIsVisible = function(_) -- line: 9
		return true
	end,
	getMenuItems = function(p2) -- line: 12
		-- upvalues: Constants (copy), Cryo (copy)
		local v7 = if p2.methodOfAbuse ~= "Voice Chat" then Constants.PlayerAbuseTypes else Constants.PlayerVoiceAbuseTypes

		return Cryo.Dictionary.values(v7)
	end,
	onUpdateSelectedOption = function(p3, _, p5, p6) -- line: 18
		-- upvalues: Constants (copy)
		p6.analyticsDispatch({
			type = Constants.AnalyticsActions.IncrementReasonChanged
		})
		p6.analyticsDispatch({
			type = Constants.AnalyticsActions.SetReasonSelection,
			selection = p3
		})
		p5({
			type = Constants.PlayerMenuActions.UpdateAbuseReason,
			abuseReason = p3
		})
	end
}
