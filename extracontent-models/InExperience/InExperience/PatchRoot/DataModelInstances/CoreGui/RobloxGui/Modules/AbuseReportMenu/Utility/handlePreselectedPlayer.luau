local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = game:GetService("CoreGui").RobloxGui
local Constants = require(AbuseReportMenu.Components.Constants)
local TnSIXPWrapper = require(AbuseReportMenu.IXP.TnSIXPWrapper)
local FFlagAddPreselectedAbuseTypeAnalytics = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAddPreselectedAbuseTypeAnalytics
local default = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default

function handlePreselectedPlayer(p1, b1: boolean, p2: ((...any) -> ...any), p3: ((...any) -> ...any)) -- line: 19
	-- upvalues: default (copy), Constants (copy), FFlagAddPreselectedAbuseTypeAnalytics (copy), TnSIXPWrapper (copy)
	if b1 and default:getRecentUsersInteractionData()[tostring(p1.UserId)] ~= nil then
		p2({
			type = Constants.PlayerMenuActions.UpdateMethodOfAbuse,
			methodOfAbuse = Constants.AbuseMethods.VoiceChat
		})
		p3({
			type = Constants.AnalyticsActions.SetTypeOfAbuseSelection,
			selection = Constants.AbuseMethods.VoiceChat
		})

		if FFlagAddPreselectedAbuseTypeAnalytics then
			p3({
				type = Constants.AnalyticsActions.SetPreselectedAbuseSelection,
				selection = Constants.AbuseMethods.VoiceChat
			})
		end
	elseif TnSIXPWrapper.getReportAnythingAvatarEnabled() then
		p2({
			type = Constants.PlayerMenuActions.UpdateMethodOfAbuse,
			methodOfAbuse = Constants.AbuseMethods.TextChat
		})
		p3({
			type = Constants.AnalyticsActions.SetTypeOfAbuseSelection,
			selection = Constants.AbuseMethods.TextChat
		})

		if FFlagAddPreselectedAbuseTypeAnalytics then
			p3({
				type = Constants.AnalyticsActions.SetPreselectedAbuseSelection,
				selection = Constants.AbuseMethods.TextChat
			})
		end
	elseif FFlagAddPreselectedAbuseTypeAnalytics then
		p3({
			selection = "None",
			type = Constants.AnalyticsActions.SetPreselectedAbuseSelection
		})
	end

	p2({
		type = Constants.PlayerMenuActions.SetPreselectedPlayer,
		player = p1
	})
end

return handlePreselectedPlayer
