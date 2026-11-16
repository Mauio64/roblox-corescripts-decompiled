local parent = script.Parent.Parent
local Players = game:GetService("Players")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

require(parent.Utils.getPaymentPlatform)

local GetFFlagEnableLuobuInGameUpsell = require(parent.Flags.GetFFlagEnableLuobuInGameUpsell)
local GetFFlagUsePlatformNameForUnknown = require(parent.Flags.GetFFlagUsePlatformNameForUnknown)
local GetFFlagEnableQuestIAPAnalytics = require(parent.Flags.GetFFlagEnableQuestIAPAnalytics)

return {
	new = function()
		local v = {}

		setmetatable(v, {
			__tostring = function(): string
				return "Service(Analytics)"
			end
		})

		local function GetPlatformString()
			local platform = UserInputService:GetPlatform()

			local v2 = not GetFFlagUsePlatformNameForUnknown() and "UNKNOWN" or tostring(platform)
			local platformString

			if platform == Enum.Platform.Windows then
				platformString = "Windows"
			elseif platform == Enum.Platform.OSX then
				platformString = "OSX"
			elseif platform == Enum.Platform.IOS then
				platformString = "IOS"
			elseif platform == Enum.Platform.Android then
				local userAgent = HttpService:GetUserAgent()
				local v3 = string.find(userAgent, "AmazonAppStore") and "Amazon" or "Android"

				platformString = GetFFlagEnableQuestIAPAnalytics()
					and string.find(userAgent, "OculusQuest3Store")
					and "Quest"
					or v3
			elseif platform == Enum.Platform.XBoxOne then
				platformString = "XBoxOne"
			elseif platform == Enum.Platform.UWP then
				platformString = "UWP"
			elseif platform == Enum.Platform.PS4 then
				platformString = "PlayStation"
			else
				platformString = v2
			end

			if GetFFlagEnableLuobuInGameUpsell() then
				platformString += "-Luobu"
			end

			return platformString
		end

		local function ReportPlatformCounter(p) -- 13 equivalent calls inferred from this helper
			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:ReportCounter(p .. GetPlatformString())
		end

		function v.sendCounter(p: string)
			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:ReportCounter(p)
		end

		local function ReportEvent(p, options) -- 16 equivalent calls inferred from this helper
			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:SetRBXEvent("client", "InGamePrompt", p, options or {})
		end

		function v.signalEvent(p, options)
			ReportEvent(p, options) -- inferred equivalent call
		end

		function v.reportRobuxUpsellStarted()
			return MarketplaceService:ReportRobuxUpsellStarted()
		end

		function v.signalPurchaseSuccess(p, p2, p3, p4)
			if p2 == Enum.InfoType.Product then
				MarketplaceService:SignalClientPurchaseSuccess(p4.receipt, Players.LocalPlayer.UserId, p)
			else
				MarketplaceService:ReportAssetSale(p, p3)
			end
		end

		function v.signalAdultLegalTextShown()
			RbxAnalyticsService:SetRBXEvent("client", "InGamePrompt", "AdultLegalTextShown", {
				gameID = game.GameId
			})
		end

		function v.signalFailedPurchasePostUpsell()
			ReportPlatformCounter("FailedBalanceCheckPostUpsell") -- inferred equivalent call
		end

		function v.signalProductPurchaseShown(productId, p)
			ReportEvent("ProductPurchaseShown", { -- inferred equivalent call
				gameID = game.GameId,
				productId = productId,
				requestType = tostring(p)
			})
			ReportPlatformCounter("ProductPurchaseShown") -- inferred equivalent call
		end

		function v.signalProductPurchaseUpsellShown(productId, p, iapProductId)
			ReportEvent("ProductPurchaseUpsellShown", { -- inferred equivalent call
				gameID = game.GameId,
				productId = productId,
				requestType = tostring(p),
				iapProductId = iapProductId
			})
			ReportPlatformCounter("ProductPurchaseUpsellShown") -- inferred equivalent call
		end

		function v.signalProductPurchaseConfirmed(productId, p)
			ReportEvent("ProductPurchaseConfirmed", { -- inferred equivalent call
				gameID = game.GameId,
				productId = productId,
				requestType = tostring(p)
			})
			ReportPlatformCounter("ProductPurchaseConfirmed") -- inferred equivalent call
		end

		function v.signalProductPurchaseUpsellConfirmed(productId, p, iapProductId)
			ReportEvent("ProductPurchaseUpsellConfirmed", { -- inferred equivalent call
				gameID = game.GameId,
				productId = productId,
				requestType = tostring(p),
				iapProductId = iapProductId
			})
			ReportPlatformCounter("ProductPurchaseUpsellConfirmed") -- inferred equivalent call
		end

		function v.signalScaryModalShown(productId, requestType, value)
			ReportEvent("ScaryModalShown", { -- inferred equivalent call
				gameID = game.GameId,
				productId = productId,
				requestType = requestType,
				iapProductId = value or ""
			})

			ReportPlatformCounter("ScaryModalShown" .. requestType) -- inferred equivalent call
		end

		function v.signalScaryModalConfirmed(productId, requestType, value)
			ReportEvent("ScaryModalConfirmed", { -- inferred equivalent call
				gameID = game.GameId,
				productId = productId,
				requestType = requestType,
				iapProductId = value or ""
			})

			ReportPlatformCounter("ScaryModalConfirmed" .. requestType) -- inferred equivalent call
		end

		function v.signalScaryModalCanceled(productId, requestType, value)
			ReportEvent("ScaryModalCanceled", { -- inferred equivalent call
				gameID = game.GameId,
				productId = productId,
				requestType = requestType,
				iapProductId = value or ""
			})

			ReportPlatformCounter("ScaryModalCanceled" .. requestType) -- inferred equivalent call
		end

		function v.signalXboxInGamePurchaseCanceled(productId, requestType, value)
			ReportEvent("XboxPaymentsInGamePurchaseCanceled", { -- inferred equivalent call
				gameID = game.GameId,
				productId = productId,
				requestType = requestType,
				iapProductId = value or ""
			})

			if not RunService:IsStudio() then
				RbxAnalyticsService:ReportCounter("XboxPaymentsInGamePurchaseCanceled")
			end
		end

		function v.signalXboxInGamePurchaseSuccess(productId, requestType, value)
			ReportEvent("XboxPaymentsInGamePurchaseSuccess", { -- inferred equivalent call
				gameID = game.GameId,
				productId = productId,
				requestType = requestType,
				iapProductId = value or ""
			})

			if not RunService:IsStudio() then
				RbxAnalyticsService:ReportCounter("XboxPaymentsInGamePurchaseSuccess")
			end
		end

		function v.signalXboxInGamePurchaseFailure(productId, requestType, value)
			ReportEvent("XboxPaymentsInGamePurchaseFailure", { -- inferred equivalent call
				gameID = game.GameId,
				productId = productId,
				requestType = requestType,
				iapProductId = value or ""
			})

			if not RunService:IsStudio() then
				RbxAnalyticsService:ReportCounter("XboxPaymentsInGamePurchaseFailure")
			end
		end

		function v.signalTwoSVSettingsErrorShown(productId, requestType)
			ReportEvent("2SVSettingsErrorShown", { -- inferred equivalent call
				gameID = game.GameId,
				productId = productId,
				requestType = requestType
			})
			ReportPlatformCounter("2SVSettingsErrorShown") -- inferred equivalent call
		end

		function v.signalTwoSVSettingsErrorConfirmed(productId, requestType)
			ReportEvent("2SVSettingsErrorConfirmed", { -- inferred equivalent call
				gameID = game.GameId,
				productId = productId,
				requestType = requestType
			})
			ReportPlatformCounter("2SVSettingsErrorConfirmed") -- inferred equivalent call
		end

		function v.signalRobuxUpsellInGameIXP(p)
			ReportEvent("RobuxUpsellInGameIXP", {}) -- inferred equivalent call

			if p then
				ReportPlatformCounter("RobuxUpsellInGameIXP") -- inferred equivalent call
			end
		end

		function v.signalAvatarCreationPurchaseSubmit()
			RbxAnalyticsService:SetRBXEvent("client", "InGamePrompt", "AvatarCreationPurchaseSubmit", {
				gameID = game.GameId
			})
			ReportPlatformCounter("AvatarCreationPurchaseSubmit") -- inferred equivalent call
		end

		function v.signalUserSettingEligibilityModal(requestType)
			ReportEvent("UserSettingEligibilityModalShown", { -- inferred equivalent call
				gameID = game.GameId,
				requestType = requestType
			})

			ReportPlatformCounter("UserSettingEligibilityModalShown" .. requestType) -- inferred equivalent call
		end

		function v.signalEconomicRestrictionError(violationType, timeoutMinutes)
			ReportEvent("EconomicRestrictionErrorShown", { -- inferred equivalent call
				gameID = game.GameId,
				violationType = violationType,
				timeoutMinutes = timeoutMinutes
			})
		end

		return v
	end
}
