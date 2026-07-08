local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CoreGui = game:GetService("CoreGui")

require(AbuseReportMenu.Components.Types)

local CorePackages = game:GetService("CorePackages")
local Constants = require(AbuseReportMenu.Components.Constants)
local getAvailableMethodsOfAbuse = require(AbuseReportMenu.Utility.getAvailableMethodsOfAbuse)
local TnSIXPWrapper = require(AbuseReportMenu.IXP.TnSIXPWrapper)
local RobloxGui = CoreGui.RobloxGui
local default = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default
local Cryo = require(CorePackages.Packages.Cryo)

return {
	componentType = "modalSelector",
	fieldLabel = "MethodOfAbuse",
	componentName = "MethodOfAbuse",
	getIsVisible = function(p1) -- line: 15
		-- upvalues: TnSIXPWrapper (copy)
		return p1.isVoiceEnabled or TnSIXPWrapper.getReportAnythingAvatarEnabled()
	end,
	getMenuItems = function(p2) -- line: 18
		-- upvalues: Cryo (copy), default (copy), getAvailableMethodsOfAbuse (copy), TnSIXPWrapper (copy)
		local v12 = p2.isVoiceEnabled and not Cryo.isEmpty(default:getRecentUsersInteractionData())

		return getAvailableMethodsOfAbuse(v12, TnSIXPWrapper.getReportAnythingAvatarEnabled())
	end,
	getSelectedValue = function(p3) -- line: 24
		return p3.methodOfAbuse
	end,
	onUpdateSelectedOption = function(p4, p5, p6, p7) -- line: 27
		-- upvalues: Constants (copy)
		p6({
			type = Constants.PlayerMenuActions.UpdateMethodOfAbuse,
			methodOfAbuse = p4.identifier
		})

		if p4.identifier ~= p5.methodOfAbuse then
			p7.reportAnythingDispatch({
				type = Constants.ReportAnythingActions.ClearAnnotationFlowProperties
			})
			p7.analyticsDispatch({
				type = Constants.AnalyticsActions.IncrementTypeofabuseChanged
			})
			p7.analyticsDispatch({
				type = Constants.AnalyticsActions.SetTypeOfAbuseSelection,
				selection = p4.identifier
			})
		end
	end
}
