local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local RobloxGui = game:GetService("CoreGui").RobloxGui

require(AbuseReportMenu.Components.Types)

local getToastMessageFromAbuseReason = require(AbuseReportMenu.MenuConfigs.getToastMessageFromAbuseReason)
local createVoiceAbuseReportRequest = require(RobloxGui.Modules.VoiceChat.createVoiceAbuseReportRequest)
local default = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default
local AbuseReportBuilder = require(AbuseReportMenu.ReportAnything.Utility.AbuseReportBuilder)
local ReportAbuseAnalytics = require(AbuseReportMenu.Analytics.ReportAbuseAnalytics)
local Constants = require(AbuseReportMenu.Components.Constants)
local TnSIXPWrapper = require(AbuseReportMenu.IXP.TnSIXPWrapper)
local Cryo = require(CorePackages.Packages.Cryo)
local submitChatLineReport = require(AbuseReportMenu.Utility.submitChatLineReport)
local FFlagInGameMenuAddChatLineReporting = require(CorePackages.Workspace.Packages.SharedFlags).FFlagInGameMenuAddChatLineReporting

function isEligibleForVoiceSubmit(p1, p2) -- line: 22
	-- upvalues: Players (copy)
	return p1.allegedAbuser ~= nil and (p1.allegedAbuserId ~= nil and (p1.abuseReason ~= nil and (p1.methodOfAbuse ~= nil and (p2.analyticsState.menuOpenedUnixTimestampMilliseconds ~= nil and Players.LocalPlayer ~= nil))))
end
function isEligibleForRAOtherSubmit(p3) -- line: 31
	-- upvalues: Players (copy)
	return p3.allegedAbuser ~= nil and (p3.allegedAbuserId ~= nil and (p3.abuseReason ~= nil and Players.LocalPlayer ~= nil))
end
function isEligibleForTextSubmit(p4) -- line: 37
	-- upvalues: FFlagInGameMenuAddChatLineReporting (copy)
	if FFlagInGameMenuAddChatLineReporting then
		return (p4.selectedMessage ~= nil or p4.allegedAbuser ~= nil) and p4.abuseReason ~= nil
	end

	return p4.allegedAbuser ~= nil and p4.abuseReason ~= nil
end

return {
	componentType = "button",
	variant = "primary",
	fieldLabel = "",
	componentName = "SubmitButton",
	getIsVisible = function(_) -- line: 48
		return true
	end,
	getIconSrc = function(_) -- line: 52
		return ""
	end,
	getButtonLabel = function(_) -- line: 55
		return "SubmitButton"
	end,
	getIsDisabled = function(p8, p9) -- line: 58
		-- upvalues: Constants (copy), TnSIXPWrapper (copy)
		local methodOfAbuse = p8.methodOfAbuse

		if methodOfAbuse == Constants.AbuseMethods.VoiceChat then
			return not isEligibleForVoiceSubmit(p8, p9)
		end

		if methodOfAbuse == Constants.AbuseMethods.TextChat or methodOfAbuse == nil or methodOfAbuse == Constants.AbuseMethods.Other and not TnSIXPWrapper.getReportAnythingAvatarEnabled() then
			return not isEligibleForTextSubmit(p8)
		end

		if methodOfAbuse == Constants.AbuseMethods.Other or methodOfAbuse == Constants.AbuseMethods.Avatar then
			return not isEligibleForRAOtherSubmit(p8)
		end

		return false
	end,
	onClick = function(p10, _, p12) -- line: 73
		-- upvalues: Constants (copy), createVoiceAbuseReportRequest (copy), Players (copy), default (copy), Cryo (copy), TnSIXPWrapper (copy), FFlagInGameMenuAddChatLineReporting (copy), submitChatLineReport (copy), getToastMessageFromAbuseReason (copy), AbuseReportBuilder (copy), ReportAbuseAnalytics (copy)
		local allegedAbuser = p10.allegedAbuser
		local allegedAbuserId = p10.allegedAbuserId
		local abuseReason = p10.abuseReason
		local methodOfAbuse = p10.methodOfAbuse
		local menuOpenedUnixTimestampMilliseconds = p12.analyticsState.menuOpenedUnixTimestampMilliseconds

		if methodOfAbuse == Constants.AbuseMethods.VoiceChat then
			if isEligibleForVoiceSubmit(p10, p12) then
				pcall(function() -- line: 86
					-- upvalues: createVoiceAbuseReportRequest (copy), Players (copy), default (copy), allegedAbuserId (copy), p10 (copy), abuseReason (copy), menuOpenedUnixTimestampMilliseconds (copy), Cryo (copy), Constants (copy), p12 (copy), allegedAbuser (copy)
					task.spawn(function() -- line: 87
						-- upvalues: createVoiceAbuseReportRequest (copy), Players (copy), default (copy), allegedAbuserId (copy), p10 (copy), abuseReason (copy), menuOpenedUnixTimestampMilliseconds (copy), Cryo (copy), Constants (copy), p12 (copy), allegedAbuser (copy)
						local v34 = createVoiceAbuseReportRequest(Players, default, {
							localUserId = Players.LocalPlayer.UserId,
							abuserUserId = allegedAbuserId,
							abuseComment = p10.comment,
							abuseReason = abuseReason,
							inExpMenuOpenedUnixMilli = menuOpenedUnixTimestampMilliseconds,
							sortedPlayerListUserIds = Cryo.List.map(p10.playerObjects, function(p13) -- line: 94
								return p13.UserId
							end),
							abuseVector = Constants.AbuseVector.Voice
						})

						Players:ReportAbuseV3(Players.LocalPlayer, v34)
						p12.analyticsDispatch({
							type = Constants.AnalyticsActions.SetSubmissionCompleted
						})
						p12.showReportSentPage(allegedAbuser)
					end)
				end)

				return
			end
		elseif methodOfAbuse == Constants.AbuseMethods.TextChat or (methodOfAbuse == Constants.AbuseMethods.Other and not TnSIXPWrapper.getReportAnythingAvatarEnabled() or methodOfAbuse == nil) then
			if isEligibleForTextSubmit(p10) then
				if FFlagInGameMenuAddChatLineReporting and p10.selectedMessage then
					submitChatLineReport({
						localPlayerUserId = Players.LocalPlayer.UserId,
						abuserUserId = p10.selectedMessage.userId,
						abuseReason = abuseReason,
						selectedMessage = p10.selectedMessage,
						abuseDescription = p10.comment,
						orderedMessages = p10.orderedMessages,
						reportTargetUser = p10.selectedMessage.userId
					})
				else
					spawn(function() -- line: 125
						-- upvalues: Players (copy), allegedAbuser (copy), abuseReason (copy), p10 (copy)
						Players:ReportAbuse(allegedAbuser, abuseReason, p10.comment)
					end)
				end

				p12.analyticsDispatch({
					type = Constants.AnalyticsActions.SetSubmissionCompleted
				})

				local v33 = getToastMessageFromAbuseReason(abuseReason)

				p12.onReportComplete(v33)

				return
			end
		elseif (methodOfAbuse == Constants.AbuseMethods.Other or methodOfAbuse == Constants.AbuseMethods.Avatar) and isEligibleForRAOtherSubmit(p10) then
			pcall(function() -- line: 135
				-- upvalues: AbuseReportBuilder (copy), Players (copy), allegedAbuserId (copy), p10 (copy), abuseReason (copy), ReportAbuseAnalytics (copy), p12 (copy), methodOfAbuse (copy), Constants (copy), getToastMessageFromAbuseReason (copy)
				task.spawn(function() -- line: 136
					-- upvalues: AbuseReportBuilder (copy), Players (copy), allegedAbuserId (copy), p10 (copy), abuseReason (copy), ReportAbuseAnalytics (copy), p12 (copy), methodOfAbuse (copy), Constants (copy), getToastMessageFromAbuseReason (copy)
					local v35 = AbuseReportBuilder.buildOtherReportRequest({
						localUserId = Players.LocalPlayer.UserId,
						formSelectedAbuserUserId = allegedAbuserId,
						abuseComment = p10.comment,
						abuseReason = abuseReason,
						menuEntryPoint = ReportAbuseAnalytics:getAbuseReportSessionEntryPoint(),
						variant = AbuseReportBuilder.Constants.Variant.NM
					}, p12.reportAnythingState, p12.reportAnythingAnalytics.getAccumulatedParameters())

					if game:GetEngineFeature("WHAM2165") and methodOfAbuse == Constants.AbuseMethods.Avatar then
						Players:ReportAvatarAbuse(allegedAbuserId, v35)
					else
						Players:ReportAbuseV3(Players.LocalPlayer, v35)
					end

					p12.analyticsDispatch({
						type = Constants.AnalyticsActions.SetSubmissionCompleted
					})

					local v36 = getToastMessageFromAbuseReason(abuseReason, true)

					p12.onReportComplete(v36)
				end)
			end)
		end
	end
}
