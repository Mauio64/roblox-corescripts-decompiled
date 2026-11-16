local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui.RobloxGui
require(AbuseReportMenu.Components.Types)
local getToastMessageFromAbuseReason = require(AbuseReportMenu.MenuConfigs.getToastMessageFromAbuseReason)
local createVoiceAbuseReportRequest = require(RobloxGui.Modules.VoiceChat.createVoiceAbuseReportRequest)
local VoiceChatServiceManager = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager)
local default = VoiceChatServiceManager.default
local AbuseReportBuilder = require(AbuseReportMenu.ReportAnything.Utility.AbuseReportBuilder)
local ReportAbuseAnalytics = require(AbuseReportMenu.Analytics.ReportAbuseAnalytics)
local Constants = require(AbuseReportMenu.Components.Constants)
local TnSIXPWrapper = require(AbuseReportMenu.IXP.TnSIXPWrapper)
local Cryo = require(CorePackages.Packages.Cryo)

function isEligibleForVoiceSubmit(data, p): boolean
	return data.allegedAbuser ~= nil
		and data.allegedAbuserId ~= nil
		and data.abuseReason ~= nil
		and data.methodOfAbuse ~= nil
		and p.analyticsState.menuOpenedUnixTimestampMilliseconds ~= nil
		and Players.LocalPlayer ~= nil
end

function isEligibleForRAOtherSubmit(data): boolean
	return data.allegedAbuser ~= nil
		and data.allegedAbuserId ~= nil
		and data.abuseReason ~= nil
		and Players.LocalPlayer ~= nil
end

function isEligibleForTextSubmit(p): boolean
	return p.allegedAbuser ~= nil and p.abuseReason ~= nil
end

local SubmitReportButtonMenuConfig = {}
SubmitReportButtonMenuConfig.componentType = "button"

function SubmitReportButtonMenuConfig.getIsVisible(_): boolean
	return true
end

SubmitReportButtonMenuConfig.variant = "primary"

function SubmitReportButtonMenuConfig.getIconSrc(_): string
	return ""
end

function SubmitReportButtonMenuConfig.getButtonLabel(_): string
	return "SubmitButton"
end

function SubmitReportButtonMenuConfig.getIsDisabled(p, p2): boolean
	local methodOfAbuse = p.methodOfAbuse

	if methodOfAbuse == Constants.AbuseMethods.VoiceChat then
		return not isEligibleForVoiceSubmit(p, p2)
	end

	if
		methodOfAbuse == Constants.AbuseMethods.TextChat
		or methodOfAbuse == nil
		or methodOfAbuse == Constants.AbuseMethods.Other and not TnSIXPWrapper.getReportAnythingAvatarEnabled()
	then
		return not isEligibleForTextSubmit(p)
	end

	if methodOfAbuse == Constants.AbuseMethods.Other or methodOfAbuse == Constants.AbuseMethods.Avatar then
		return not isEligibleForRAOtherSubmit(p)
	end

	return false
end

function SubmitReportButtonMenuConfig.onClick(data, _, data2)
	local allegedAbuser = data.allegedAbuser
	local allegedAbuserId = data.allegedAbuserId
	local abuseReason = data.abuseReason
	local methodOfAbuse = data.methodOfAbuse
	local menuOpenedUnixTimestampMilliseconds = data2.analyticsState.menuOpenedUnixTimestampMilliseconds

	if methodOfAbuse == Constants.AbuseMethods.VoiceChat then
		if isEligibleForVoiceSubmit(data, data2) then
			pcall(function()
				task.spawn(function()
					local voiceAbuseReportRequest = createVoiceAbuseReportRequest(Players, default, {
						localUserId = Players.LocalPlayer.UserId,
						abuserUserId = allegedAbuserId,
						abuseComment = data.comment,
						abuseReason = abuseReason,
						inExpMenuOpenedUnixMilli = menuOpenedUnixTimestampMilliseconds,
						sortedPlayerListUserIds = Cryo.List.map(data.playerObjects, function(p)
							return p.UserId
						end),
						abuseVector = Constants.AbuseVector.Voice
					})

					Players:ReportAbuseV3(Players.LocalPlayer, voiceAbuseReportRequest)

					data2.analyticsDispatch({
						type = Constants.AnalyticsActions.SetSubmissionCompleted
					})
					data2.showReportSentPage(allegedAbuser)
				end)
			end)
		end
	elseif
		methodOfAbuse == Constants.AbuseMethods.TextChat
		or methodOfAbuse == Constants.AbuseMethods.Other and not TnSIXPWrapper.getReportAnythingAvatarEnabled()
		or methodOfAbuse == nil
	then
		if isEligibleForTextSubmit(data) then
			spawn(function()
				Players:ReportAbuse(allegedAbuser, abuseReason, data.comment)
			end)
			data2.analyticsDispatch({ type = Constants.AnalyticsActions.SetSubmissionCompleted })
			local toastMessageFromAbuseReason = getToastMessageFromAbuseReason(abuseReason)
			data2.onReportComplete(toastMessageFromAbuseReason)
		end
	elseif
		(methodOfAbuse == Constants.AbuseMethods.Other or methodOfAbuse == Constants.AbuseMethods.Avatar)
		and isEligibleForRAOtherSubmit(data)
	then
		pcall(function()
			task.spawn(function()
				local otherReportRequest = AbuseReportBuilder.buildOtherReportRequest({
					localUserId = Players.LocalPlayer.UserId,
					formSelectedAbuserUserId = allegedAbuserId,
					abuseComment = data.comment,
					abuseReason = abuseReason,
					menuEntryPoint = ReportAbuseAnalytics:getAbuseReportSessionEntryPoint(),
					variant = AbuseReportBuilder.Constants.Variant.NM
				}, data2.reportAnythingState, data2.reportAnythingAnalytics.getAccumulatedParameters())

				if game:GetEngineFeature("WHAM2165") and methodOfAbuse == Constants.AbuseMethods.Avatar then
					Players:ReportAvatarAbuse(allegedAbuserId, otherReportRequest)
				else
					Players:ReportAbuseV3(Players.LocalPlayer, otherReportRequest)
				end

				data2.analyticsDispatch({ type = Constants.AnalyticsActions.SetSubmissionCompleted })
				local toastMessageFromAbuseReason = getToastMessageFromAbuseReason(abuseReason, true)
				data2.onReportComplete(toastMessageFromAbuseReason)
			end)
		end)
	end
end

SubmitReportButtonMenuConfig.fieldLabel = ""
SubmitReportButtonMenuConfig.componentName = "SubmitButton"
return SubmitReportButtonMenuConfig
