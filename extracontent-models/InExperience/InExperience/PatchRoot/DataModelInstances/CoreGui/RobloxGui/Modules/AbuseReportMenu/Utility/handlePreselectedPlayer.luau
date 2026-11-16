local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")

local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui.RobloxGui

local Constants = require(AbuseReportMenu.Components.Constants)
local TnSIXPWrapper = require(AbuseReportMenu.IXP.TnSIXPWrapper)

local VoiceChatServiceManager = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager)
local default = VoiceChatServiceManager.default
local function fn(p): boolean -- 1 equivalent call inferred from this helper
	return default:getRecentUsersInteractionData()[tostring(p.UserId)] ~= nil
end

function handlePreselectedPlayer(player, flag: boolean, callback, callback2)
	if flag and fn(player) then -- inferred equivalent call
		callback({
			type = Constants.PlayerMenuActions.UpdateMethodOfAbuse,
			methodOfAbuse = Constants.AbuseMethods.VoiceChat
		})

		callback2({
			type = Constants.AnalyticsActions.SetTypeOfAbuseSelection,
			selection = Constants.AbuseMethods.VoiceChat
		})

		callback2({
			type = Constants.AnalyticsActions.SetPreselectedAbuseSelection,
			selection = Constants.AbuseMethods.VoiceChat
		})
	elseif TnSIXPWrapper.getReportAnythingAvatarEnabled() then
		callback({
			type = Constants.PlayerMenuActions.UpdateMethodOfAbuse,
			methodOfAbuse = Constants.AbuseMethods.TextChat
		})

		callback2({
			type = Constants.AnalyticsActions.SetTypeOfAbuseSelection,
			selection = Constants.AbuseMethods.TextChat
		})

		callback2({
			type = Constants.AnalyticsActions.SetPreselectedAbuseSelection,
			selection = Constants.AbuseMethods.TextChat
		})
	else
		callback2({
			type = Constants.AnalyticsActions.SetPreselectedAbuseSelection,
			selection = "None"
		})
	end

	callback({ type = Constants.PlayerMenuActions.SetPreselectedPlayer, player = player })
end

return handlePreselectedPlayer
