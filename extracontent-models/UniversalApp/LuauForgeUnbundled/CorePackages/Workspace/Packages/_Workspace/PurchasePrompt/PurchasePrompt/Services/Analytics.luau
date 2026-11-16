local Players = game:GetService("Players")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getPaymentPlatform")

local GetFFlagEnableLuobuInGameUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/GetFFlagEnableLuobuInGameUpsell")
local GetFFlagUsePlatformNameForUnknown = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/GetFFlagUsePlatformNameForUnknown")
local GetFFlagEnableQuestIAPAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/GetFFlagEnableQuestIAPAnalytics")

return {
	new = function()
		local v5 = {}

		setmetatable(v5, {
			__tostring = function(): string
				return "Service(Analytics)"
			end
		})

		local function GetPlatformString()
			local platform = UserInputService:GetPlatform()

			local v6 = not GetFFlagUsePlatformNameForUnknown() and "UNKNOWN" or tostring(platform)
			local platformString

			if platform == Enum.Platform.Windows then
				platformString = "Windows"
			elseif platform == Enum.Platform.OSX then
				platformString = "OSX"
			elseif platform == Enum.Platform.IOS then
				platformString = "IOS"
			elseif platform == Enum.Platform.Android then
				local userAgent = HttpService:GetUserAgent()
				local v7 = string.find(userAgent, "AmazonAppStore") and "Amazon" or "Android"

				platformString = GetFFlagEnableQuestIAPAnalytics() and string.find(userAgent, "OculusQuest3Store") and "Quest" or v7
			elseif platform == Enum.Platform.XBoxOne then
				platformString = "XBoxOne"
			elseif platform == Enum.Platform.UWP then
				platformString = "UWP"
			else
				platformString = if platform == Enum.Platform.PS4 then "PlayStation" else v6
			end

			if GetFFlagEnableLuobuInGameUpsell() then
				platformString += "-Luobu"
			end

			return platformString
		end

		local function ReportPlatformCounter(p2)
			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:ReportCounter(p2 .. GetPlatformString())
		end

		function v5.sendCounter(p2)
			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:ReportCounter(p2)
		end

		local function ReportEvent(p2, options)
			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:SetRBXEvent("client", "InGamePrompt", p2, options or {})
		end

		function v5.signalEvent(p2, options)
			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:SetRBXEvent("client", "InGamePrompt", p2, options or {})
		end

		function v5.reportRobuxUpsellStarted()
			return MarketplaceService:ReportRobuxUpsellStarted()
		end

		function v5.signalPurchaseSuccess(p2, p3, p4, p5)
			if p3 == Enum.InfoType.Product then
				MarketplaceService:SignalClientPurchaseSuccess(p5.receipt, Players.LocalPlayer.UserId, p2)
			else
				MarketplaceService:ReportAssetSale(p2, p4)
			end
		end

		function v5.signalAdultLegalTextShown()
			RbxAnalyticsService:SetRBXEvent("client", "InGamePrompt", "AdultLegalTextShown", {
				gameID = game.GameId
			})
		end

		function v5.signalFailedPurchasePostUpsell()
			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:ReportCounter("FailedBalanceCheckPostUpsell" .. GetPlatformString())
		end

		function v5.signalProductPurchaseShown(p2, p3)
			local v6 = {
				gameID = game.GameId,
				productId = p2,
				requestType = tostring(p3)
			}

			if not RunService:IsStudio() then
				RbxAnalyticsService:SetRBXEvent("client", "InGamePrompt", "ProductPurchaseShown", v6 or {})
			end

			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:ReportCounter("ProductPurchaseShown" .. GetPlatformString())
		end

		function v5.signalProductPurchaseUpsellShown(p2, p3, p4)
			local v6 = {
				gameID = game.GameId,
				productId = p2,
				requestType = tostring(p3),
				iapProductId = p4
			}

			if not RunService:IsStudio() then
				RbxAnalyticsService:SetRBXEvent(
					"client",
					"InGamePrompt",
					"ProductPurchaseUpsellShown",
					v6 or {}
				)
			end

			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:ReportCounter("ProductPurchaseUpsellShown" .. GetPlatformString())
		end

		function v5.signalProductPurchaseConfirmed(p2, p3)
			local v6 = {
				gameID = game.GameId,
				productId = p2,
				requestType = tostring(p3)
			}

			if not RunService:IsStudio() then
				RbxAnalyticsService:SetRBXEvent(
					"client",
					"InGamePrompt",
					"ProductPurchaseConfirmed",
					v6 or {}
				)
			end

			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:ReportCounter("ProductPurchaseConfirmed" .. GetPlatformString())
		end

		function v5.signalProductPurchaseUpsellConfirmed(p2, p3, p4)
			local v6 = {
				gameID = game.GameId,
				productId = p2,
				requestType = tostring(p3),
				iapProductId = p4
			}

			if not RunService:IsStudio() then
				RbxAnalyticsService:SetRBXEvent(
					"client",
					"InGamePrompt",
					"ProductPurchaseUpsellConfirmed",
					v6 or {}
				)
			end

			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:ReportCounter("ProductPurchaseUpsellConfirmed" .. GetPlatformString())
		end

		function v5.signalScaryModalShown(p2, p3, value)
			local v6 = {
				gameID = game.GameId,
				productId = p2,
				requestType = p3,
				iapProductId = value or ""
			}

			if not RunService:IsStudio() then
				RbxAnalyticsService:SetRBXEvent("client", "InGamePrompt", "ScaryModalShown", v6 or {})
			end

			local v7 = "ScaryModalShown" .. p3

			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:ReportCounter(v7 .. GetPlatformString())
		end

		function v5.signalScaryModalConfirmed(p2, p3, value)
			local v6 = {
				gameID = game.GameId,
				productId = p2,
				requestType = p3,
				iapProductId = value or ""
			}

			if not RunService:IsStudio() then
				RbxAnalyticsService:SetRBXEvent("client", "InGamePrompt", "ScaryModalConfirmed", v6 or {})
			end

			local v7 = "ScaryModalConfirmed" .. p3

			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:ReportCounter(v7 .. GetPlatformString())
		end

		function v5.signalScaryModalCanceled(p2, p3, value)
			local v6 = {
				gameID = game.GameId,
				productId = p2,
				requestType = p3,
				iapProductId = value or ""
			}

			if not RunService:IsStudio() then
				RbxAnalyticsService:SetRBXEvent("client", "InGamePrompt", "ScaryModalCanceled", v6 or {})
			end

			local v7 = "ScaryModalCanceled" .. p3

			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:ReportCounter(v7 .. GetPlatformString())
		end

		function v5.signalXboxInGamePurchaseCanceled(p2, p3, value)
			local v6 = {
				gameID = game.GameId,
				productId = p2,
				requestType = p3,
				iapProductId = value or ""
			}

			if not RunService:IsStudio() then
				RbxAnalyticsService:SetRBXEvent(
					"client",
					"InGamePrompt",
					"XboxPaymentsInGamePurchaseCanceled",
					v6 or {}
				)
			end

			if not RunService:IsStudio() then
				RbxAnalyticsService:ReportCounter("XboxPaymentsInGamePurchaseCanceled")
			end
		end

		function v5.signalXboxInGamePurchaseSuccess(p2, p3, value)
			local v6 = {
				gameID = game.GameId,
				productId = p2,
				requestType = p3,
				iapProductId = value or ""
			}

			if not RunService:IsStudio() then
				RbxAnalyticsService:SetRBXEvent(
					"client",
					"InGamePrompt",
					"XboxPaymentsInGamePurchaseSuccess",
					v6 or {}
				)
			end

			if not RunService:IsStudio() then
				RbxAnalyticsService:ReportCounter("XboxPaymentsInGamePurchaseSuccess")
			end
		end

		function v5.signalXboxInGamePurchaseFailure(p2, p3, value)
			local v6 = {
				gameID = game.GameId,
				productId = p2,
				requestType = p3,
				iapProductId = value or ""
			}

			if not RunService:IsStudio() then
				RbxAnalyticsService:SetRBXEvent(
					"client",
					"InGamePrompt",
					"XboxPaymentsInGamePurchaseFailure",
					v6 or {}
				)
			end

			if not RunService:IsStudio() then
				RbxAnalyticsService:ReportCounter("XboxPaymentsInGamePurchaseFailure")
			end
		end

		function v5.signalTwoSVSettingsErrorShown(p2, p3)
			local v6 = { gameID = game.GameId, productId = p2, requestType = p3 }

			if not RunService:IsStudio() then
				RbxAnalyticsService:SetRBXEvent("client", "InGamePrompt", "2SVSettingsErrorShown", v6 or {})
			end

			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:ReportCounter("2SVSettingsErrorShown" .. GetPlatformString())
		end

		function v5.signalTwoSVSettingsErrorConfirmed(p2, p3)
			local v6 = { gameID = game.GameId, productId = p2, requestType = p3 }

			if not RunService:IsStudio() then
				RbxAnalyticsService:SetRBXEvent(
					"client",
					"InGamePrompt",
					"2SVSettingsErrorConfirmed",
					v6 or {}
				)
			end

			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:ReportCounter("2SVSettingsErrorConfirmed" .. GetPlatformString())
		end

		function v5.signalRobuxUpsellInGameIXP(p2)
			local v6 = {}

			if not RunService:IsStudio() then
				RbxAnalyticsService:SetRBXEvent("client", "InGamePrompt", "RobuxUpsellInGameIXP", v6 or {})
			end

			if p2 then
				if RunService:IsStudio() then
					return
				end

				RbxAnalyticsService:ReportCounter("RobuxUpsellInGameIXP" .. GetPlatformString())
			end
		end

		function v5.signalAvatarCreationPurchaseSubmit()
			RbxAnalyticsService:SetRBXEvent("client", "InGamePrompt", "AvatarCreationPurchaseSubmit", {
				gameID = game.GameId
			})

			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:ReportCounter("AvatarCreationPurchaseSubmit" .. GetPlatformString())
		end

		function v5.signalUserSettingEligibilityModal(p2)
			local v6 = { gameID = game.GameId, requestType = p2 }

			if not RunService:IsStudio() then
				RbxAnalyticsService:SetRBXEvent(
					"client",
					"InGamePrompt",
					"UserSettingEligibilityModalShown",
					v6 or {}
				)
			end

			local v7 = "UserSettingEligibilityModalShown" .. p2

			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:ReportCounter(v7 .. GetPlatformString())
		end

		function v5.signalEconomicRestrictionError(p2, p3)
			local v6 = { gameID = game.GameId, violationType = p2, timeoutMinutes = p3 }

			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:SetRBXEvent(
				"client",
				"InGamePrompt",
				"EconomicRestrictionErrorShown",
				v6 or {}
			)
		end

		return v5
	end
}
