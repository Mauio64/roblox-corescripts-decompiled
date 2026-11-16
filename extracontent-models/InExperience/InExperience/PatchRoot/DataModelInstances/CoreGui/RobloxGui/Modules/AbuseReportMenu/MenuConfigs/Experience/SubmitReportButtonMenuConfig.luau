local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

require(AbuseReportMenu.Components.Types)
local Constants = require(AbuseReportMenu.Components.Constants)
local TnSIXPWrapper = require(AbuseReportMenu.IXP.TnSIXPWrapper)
local AbuseReportBuilder = require(AbuseReportMenu.ReportAnything.Utility.AbuseReportBuilder)
local ReportAbuseAnalytics = require(AbuseReportMenu.Analytics.ReportAbuseAnalytics)
local getToastMessageFromAbuseReason = require(AbuseReportMenu.MenuConfigs.getToastMessageFromAbuseReason)
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

function SubmitReportButtonMenuConfig.onClick(p, _, data)
	local abuseReason = p.abuseReason

	if abuseReason ~= nil and Players.LocalPlayer ~= nil then
		if TnSIXPWrapper.getReportAnythingExperienceEnabled() then
			local experienceReportRequest = AbuseReportBuilder.buildExperienceReportRequest({
				localUserId = Players.LocalPlayer.UserId,
				placeId = game.PlaceId,
				abuseComment = p.comment,
				abuseReason = abuseReason,
				menuEntryPoint = ReportAbuseAnalytics:getAbuseReportSessionEntryPoint(),
				variant = AbuseReportBuilder.Constants.Variant.NM
			}, data.reportAnythingState, data.reportAnythingAnalytics.getAccumulatedParameters())

			Players:ReportAbuseV3(Players.LocalPlayer, experienceReportRequest)

			data.analyticsDispatch({ type = Constants.AnalyticsActions.SetSubmissionCompleted })
			local toastMessageFromAbuseReason = getToastMessageFromAbuseReason(abuseReason, true)
			data.onReportComplete(toastMessageFromAbuseReason)
		else
			spawn(function()
				local placeId = tostring(game.PlaceId)
				local v = "N/A"
				local v2 = "N/A"
				pcall(function()
					local productInfoAsync = MarketplaceService:GetProductInfoAsync(game.PlaceId, Enum.InfoType.Asset)
					v = productInfoAsync.Name
					v2 = productInfoAsync.Description
				end)
				Players:ReportAbuse(
					nil,
					abuseReason,
					(string.format(
						"User Report: \n    %s \nPlace Title: \n    %s \nPlaceId: \n    %s \nPlace Description: \n    %s \n",
						p.comment,
						v,
						placeId,
						v2
					))
				)
			end)
			data.analyticsDispatch({ type = Constants.AnalyticsActions.SetSubmissionCompleted })
			local toastMessageFromAbuseReason = getToastMessageFromAbuseReason(abuseReason)
			data.onReportComplete(toastMessageFromAbuseReason)
		end
	end
end

SubmitReportButtonMenuConfig.fieldLabel = ""
SubmitReportButtonMenuConfig.componentName = "SubmitButton"
return SubmitReportButtonMenuConfig
