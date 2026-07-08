local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

require(AbuseReportMenu.Components.Types)

local Constants = require(AbuseReportMenu.Components.Constants)
local TnSIXPWrapper = require(AbuseReportMenu.IXP.TnSIXPWrapper)
local AbuseReportBuilder = require(AbuseReportMenu.ReportAnything.Utility.AbuseReportBuilder)
local ReportAbuseAnalytics = require(AbuseReportMenu.Analytics.ReportAbuseAnalytics)
local getToastMessageFromAbuseReason = require(AbuseReportMenu.MenuConfigs.getToastMessageFromAbuseReason)

return {
	componentType = "button",
	variant = "primary",
	fieldLabel = "",
	componentName = "SubmitButton",
	getIsVisible = function(_) -- line: 14
		return true
	end,
	getIconSrc = function(_) -- line: 18
		return ""
	end,
	getButtonLabel = function(_) -- line: 21
		return "SubmitButton"
	end,
	onClick = function(p4, _, p6) -- line: 24
		-- upvalues: Players (copy), TnSIXPWrapper (copy), AbuseReportBuilder (copy), ReportAbuseAnalytics (copy), Constants (copy), getToastMessageFromAbuseReason (copy), MarketplaceService (copy)
		local abuseReason = p4.abuseReason

		if abuseReason ~= nil and Players.LocalPlayer ~= nil then
			if TnSIXPWrapper.getReportAnythingExperienceEnabled() then
				local v16 = AbuseReportBuilder.buildExperienceReportRequest({
					localUserId = Players.LocalPlayer.UserId,
					placeId = game.PlaceId,
					abuseComment = p4.comment,
					abuseReason = abuseReason,
					menuEntryPoint = ReportAbuseAnalytics:getAbuseReportSessionEntryPoint(),
					variant = AbuseReportBuilder.Constants.Variant.NM
				}, p6.reportAnythingState, p6.reportAnythingAnalytics.getAccumulatedParameters())

				Players:ReportAbuseV3(Players.LocalPlayer, v16)
				p6.analyticsDispatch({
					type = Constants.AnalyticsActions.SetSubmissionCompleted
				})

				local v17 = getToastMessageFromAbuseReason(abuseReason, true)

				p6.onReportComplete(v17)

				return
			end

			spawn(function() -- line: 49
				-- upvalues: MarketplaceService (copy), p4 (copy), Players (copy), abuseReason (copy)
				local str = tostring(game.PlaceId)
				local s1 = "N/A"
				local s2 = "N/A"

				pcall(function() -- line: 51
					-- upvalues: MarketplaceService (copy), s1 (ref), s2 (ref)
					if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
						local ProductInfoAsync = MarketplaceService:GetProductInfoAsync(game.PlaceId, Enum.InfoType.Asset)

						s1 = ProductInfoAsync.Name
						s2 = ProductInfoAsync.Description

						return
					end

					local ProductInfo = MarketplaceService:GetProductInfo(game.PlaceId, Enum.InfoType.Asset)

					s1 = ProductInfo.Name
					s2 = ProductInfo.Description
				end)

				local v22 = string.format("User Report: \n    %s \nPlace Title: \n    %s \nPlaceId: \n    %s \nPlace Description: \n    %s \n", p4.comment, s1, str, s2)

				Players:ReportAbuse(nil, abuseReason, v22)
			end)
			p6.analyticsDispatch({
				type = Constants.AnalyticsActions.SetSubmissionCompleted
			})

			local v18 = getToastMessageFromAbuseReason(abuseReason)

			p6.onReportComplete(v18)
		end
	end
}
