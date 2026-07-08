local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local Constants = require(AbuseReportMenu.Components.Constants)

require(AbuseReportMenu.Components.Types)

local Cryo = require(CorePackages.Packages.Cryo)

return {
	componentType = "modalSelector",
	fieldLabel = "ReasonForAbuse",
	componentName = "AbuseReason",
	getIsVisible = function(_) -- line: 9
		return true
	end,
	getMenuItems = function(p2, p3) -- line: 12
		-- upvalues: Constants (copy), Cryo (copy)
		local v8 = if p2.methodOfAbuse ~= Constants.AbuseMethods.VoiceChat then Constants.PlayerAbuseTypes else Constants.PlayerVoiceAbuseTypes
		local v9 = Cryo.Dictionary.values(v8)

		return Cryo.List.map(v9, function(p4) -- line: 17
			-- upvalues: p3 (copy)
			return {
				label = p3[p4],
				identifier = p4
			}
		end)
	end,
	getSelectedValue = function(p5) -- line: 24
		return p5.abuseReason
	end,
	onUpdateSelectedOption = function(p6, _, p8, p9) -- line: 27
		-- upvalues: Constants (copy)
		p9.analyticsDispatch({
			type = Constants.AnalyticsActions.IncrementReasonChanged
		})
		p9.analyticsDispatch({
			type = Constants.AnalyticsActions.SetReasonSelection,
			selection = p6.identifier
		})
		p8({
			type = Constants.PlayerMenuActions.UpdateAbuseReason,
			abuseReason = p6.identifier
		})
	end
}
