local ParentParent = script.Parent.Parent
local Players = game:GetService("Players")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

require(ParentParent.Utils.getPaymentPlatform)

local GetFFlagEnableLuobuInGameUpsell = require(ParentParent.Flags.GetFFlagEnableLuobuInGameUpsell)
local GetFFlagUsePlatformNameForUnknown = require(ParentParent.Flags.GetFFlagUsePlatformNameForUnknown)
local GetFFlagEnableQuestIAPAnalytics = require(ParentParent.Flags.GetFFlagEnableQuestIAPAnalytics)

return {
	new = function() -- line: 18
		-- upvalues: UserInputService (copy), GetFFlagUsePlatformNameForUnknown (copy), HttpService (copy), GetFFlagEnableQuestIAPAnalytics (copy), GetFFlagEnableLuobuInGameUpsell (copy), RunService (copy), RbxAnalyticsService (copy), MarketplaceService (copy), Players (copy)
		local t1 = {}

		setmetatable(t1, {
			__tostring = function() -- line: 22
				return "Service(Analytics)"
			end
		})

		local function GetPlatformString() -- line: 27
			-- upvalues: UserInputService (copy), GetFFlagUsePlatformNameForUnknown (copy), HttpService (copy), GetFFlagEnableQuestIAPAnalytics (copy), GetFFlagEnableLuobuInGameUpsell (copy)
			local Platform = UserInputService:GetPlatform()
			local s1 = "UNKNOWN"

			if GetFFlagUsePlatformNameForUnknown() then
				s1 = tostring(Platform)
			end

			if Platform == Enum.Platform.Windows then
				s1 = "Windows"
			elseif Platform == Enum.Platform.OSX then
				s1 = "OSX"
			elseif Platform == Enum.Platform.IOS then
				s1 = "IOS"
			elseif Platform == Enum.Platform.Android then
				local UserAgent = HttpService:GetUserAgent()

				s1 = not string.find(UserAgent, "AmazonAppStore") and "Android" or "Amazon"

				if GetFFlagEnableQuestIAPAnalytics() and string.find(UserAgent, "OculusQuest3Store") then
					s1 = "Quest"
				end
			elseif Platform == Enum.Platform.XBoxOne then
				s1 = "XBoxOne"
			elseif Platform == Enum.Platform.UWP then
				s1 = "UWP"
			elseif Platform == Enum.Platform.PS4 then
				s1 = "PlayStation"
			end

			if GetFFlagEnableLuobuInGameUpsell() then
				s1 += "-Luobu"
			end

			return s1
		end
		local function ReportPlatformCounter(p1) -- line: 65
			-- upvalues: RunService (copy), RbxAnalyticsService (copy), GetPlatformString (copy)
			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:ReportCounter(p1 .. GetPlatformString())
		end

		function t1.sendCounter(s2: string) -- line: 72
			-- upvalues: RunService (copy), RbxAnalyticsService (copy)
			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:ReportCounter(s2)
		end

		local function ReportEvent(p2, p3) -- line: 79
			-- upvalues: RunService (copy), RbxAnalyticsService (copy)
			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:SetRBXEvent("client", "InGamePrompt", p2, p3 or {})
		end

		function t1.signalEvent(p4, p5) -- line: 86
			-- upvalues: RunService (copy), RbxAnalyticsService (copy)
			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:SetRBXEvent("client", "InGamePrompt", p4, p5 or {})
		end
		function t1.reportRobuxUpsellStarted() -- line: 90
			-- upvalues: MarketplaceService (copy)
			return MarketplaceService:ReportRobuxUpsellStarted()
		end
		function t1.signalPurchaseSuccess(p6, p7, p8, p9) -- line: 94
			-- upvalues: MarketplaceService (copy), Players (copy)
			if p7 == Enum.InfoType.Product then
				MarketplaceService:SignalClientPurchaseSuccess(p9.receipt, Players.LocalPlayer.UserId, p6)

				return
			end

			MarketplaceService:ReportAssetSale(p6, p8)
		end
		function t1.signalPremiumUpsellShownPremium() -- line: 102
			-- upvalues: RbxAnalyticsService (copy), RunService (copy), GetPlatformString (copy)
			RbxAnalyticsService:SetRBXEvent("client", "InGamePrompt", "PremiumUpsellShownPremium", {
				gameID = game.GameId
			})

			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:ReportCounter("PremiumUpsellShownPremium" .. GetPlatformString())
		end
		function t1.signalPremiumUpsellShownNonPremium() -- line: 107
			-- upvalues: RbxAnalyticsService (copy), RunService (copy), GetPlatformString (copy)
			RbxAnalyticsService:SetRBXEvent("client", "InGamePrompt", "PremiumUpsellShownNonPremium", {
				gameID = game.GameId
			})

			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:ReportCounter("PremiumUpsellShownNonPremium" .. GetPlatformString())
		end
		function t1.signalPremiumUpsellConfirmed() -- line: 112
			-- upvalues: RbxAnalyticsService (copy), RunService (copy), GetPlatformString (copy)
			RbxAnalyticsService:SetRBXEvent("client", "InGamePrompt", "PremiumUpsellConfirmed", {
				gameID = game.GameId
			})

			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:ReportCounter("PremiumUpsellConfirmed" .. GetPlatformString())
		end
		function t1.signalPremiumUpsellPrecheckFail() -- line: 117
			-- upvalues: RbxAnalyticsService (copy), RunService (copy), GetPlatformString (copy)
			RbxAnalyticsService:SetRBXEvent("client", "InGamePrompt", "PremiumUpsellPrecheckFail", {
				gameID = game.GameId
			})

			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:ReportCounter("PremiumUpsellPrecheckFail" .. GetPlatformString())
		end
		function t1.signalPremiumUpsellInvalidProducts() -- line: 122
			-- upvalues: RbxAnalyticsService (copy), RunService (copy), GetPlatformString (copy)
			RbxAnalyticsService:SetRBXEvent("client", "InGamePrompt", "PremiumUpsellInvalidProducts", {
				gameID = game.GameId
			})

			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:ReportCounter("PremiumUpsellInvalidProducts" .. GetPlatformString())
		end
		function t1.signalPremiumUpsellInvalidPlatform() -- line: 127
			-- upvalues: RbxAnalyticsService (copy), RunService (copy), GetPlatformString (copy)
			RbxAnalyticsService:SetRBXEvent("client", "InGamePrompt", "PremiumUpsellInvalidPlatform", {
				gameID = game.GameId
			})

			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:ReportCounter("PremiumUpsellInvalidPlatform" .. GetPlatformString())
		end
		function t1.signalAdultLegalTextShown() -- line: 132
			-- upvalues: RbxAnalyticsService (copy)
			RbxAnalyticsService:SetRBXEvent("client", "InGamePrompt", "AdultLegalTextShown", {
				gameID = game.GameId
			})
		end
		function t1.signalFailedPurchasePostUpsell() -- line: 136
			-- upvalues: RunService (copy), RbxAnalyticsService (copy), GetPlatformString (copy)
			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:ReportCounter("FailedBalanceCheckPostUpsell" .. GetPlatformString())
		end
		function t1.signalProductPurchaseShown(p10, p11) -- line: 140
			-- upvalues: RunService (copy), RbxAnalyticsService (copy), GetPlatformString (copy)
			local t2 = {
				gameID = game.GameId,
				productId = p10,
				requestType = tostring(p11)
			}

			if not RunService:IsStudio() then
				RbxAnalyticsService:SetRBXEvent("client", "InGamePrompt", "ProductPurchaseShown", t2 or {})
			end

			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:ReportCounter("ProductPurchaseShown" .. GetPlatformString())
		end
		function t1.signalProductPurchaseUpsellShown(p12, p13, p14) -- line: 149
			-- upvalues: RunService (copy), RbxAnalyticsService (copy), GetPlatformString (copy)
			local t3 = {
				gameID = game.GameId,
				productId = p12,
				requestType = tostring(p13),
				iapProductId = p14
			}

			if not RunService:IsStudio() then
				RbxAnalyticsService:SetRBXEvent("client", "InGamePrompt", "ProductPurchaseUpsellShown", t3 or {})
			end

			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:ReportCounter("ProductPurchaseUpsellShown" .. GetPlatformString())
		end
		function t1.signalProductPurchaseConfirmed(p15, p16) -- line: 159
			-- upvalues: RunService (copy), RbxAnalyticsService (copy), GetPlatformString (copy)
			local t4 = {
				gameID = game.GameId,
				productId = p15,
				requestType = tostring(p16)
			}

			if not RunService:IsStudio() then
				RbxAnalyticsService:SetRBXEvent("client", "InGamePrompt", "ProductPurchaseConfirmed", t4 or {})
			end

			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:ReportCounter("ProductPurchaseConfirmed" .. GetPlatformString())
		end
		function t1.signalProductPurchaseUpsellConfirmed(p17, p18, p19) -- line: 168
			-- upvalues: RunService (copy), RbxAnalyticsService (copy), GetPlatformString (copy)
			local t5 = {
				gameID = game.GameId,
				productId = p17,
				requestType = tostring(p18),
				iapProductId = p19
			}

			if not RunService:IsStudio() then
				RbxAnalyticsService:SetRBXEvent("client", "InGamePrompt", "ProductPurchaseUpsellConfirmed", t5 or {})
			end

			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:ReportCounter("ProductPurchaseUpsellConfirmed" .. GetPlatformString())
		end
		function t1.signalScaryModalShown(p20, p21, p22) -- line: 178
			-- upvalues: RunService (copy), RbxAnalyticsService (copy), GetPlatformString (copy)
			local t6 = {
				gameID = game.GameId,
				productId = p20,
				requestType = p21,
				iapProductId = p22 or ""
			}

			if not RunService:IsStudio() then
				RbxAnalyticsService:SetRBXEvent("client", "InGamePrompt", "ScaryModalShown", t6 or {})
			end

			local v46 = "ScaryModalShown" .. p21

			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:ReportCounter(v46 .. GetPlatformString())
		end
		function t1.signalScaryModalConfirmed(p23, p24, p25) -- line: 188
			-- upvalues: RunService (copy), RbxAnalyticsService (copy), GetPlatformString (copy)
			local t7 = {
				gameID = game.GameId,
				productId = p23,
				requestType = p24,
				iapProductId = p25 or ""
			}

			if not RunService:IsStudio() then
				RbxAnalyticsService:SetRBXEvent("client", "InGamePrompt", "ScaryModalConfirmed", t7 or {})
			end

			local v51 = "ScaryModalConfirmed" .. p24

			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:ReportCounter(v51 .. GetPlatformString())
		end
		function t1.signalScaryModalCanceled(p26, p27, p28) -- line: 198
			-- upvalues: RunService (copy), RbxAnalyticsService (copy), GetPlatformString (copy)
			local t8 = {
				gameID = game.GameId,
				productId = p26,
				requestType = p27,
				iapProductId = p28 or ""
			}

			if not RunService:IsStudio() then
				RbxAnalyticsService:SetRBXEvent("client", "InGamePrompt", "ScaryModalCanceled", t8 or {})
			end

			local v56 = "ScaryModalCanceled" .. p27

			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:ReportCounter(v56 .. GetPlatformString())
		end
		function t1.signalXboxInGamePurchaseCanceled(p29, p30, p31) -- line: 208
			-- upvalues: RunService (copy), RbxAnalyticsService (copy)
			local t9 = {
				gameID = game.GameId,
				productId = p29,
				requestType = p30,
				iapProductId = p31 or ""
			}

			if not RunService:IsStudio() then
				RbxAnalyticsService:SetRBXEvent("client", "InGamePrompt", "XboxPaymentsInGamePurchaseCanceled", t9 or {})
			end

			if not RunService:IsStudio() then
				RbxAnalyticsService:ReportCounter("XboxPaymentsInGamePurchaseCanceled")
			end
		end
		function t1.signalXboxInGamePurchaseSuccess(p32, p33, p34) -- line: 220
			-- upvalues: RunService (copy), RbxAnalyticsService (copy)
			local t10 = {
				gameID = game.GameId,
				productId = p32,
				requestType = p33,
				iapProductId = p34 or ""
			}

			if not RunService:IsStudio() then
				RbxAnalyticsService:SetRBXEvent("client", "InGamePrompt", "XboxPaymentsInGamePurchaseSuccess", t10 or {})
			end

			if not RunService:IsStudio() then
				RbxAnalyticsService:ReportCounter("XboxPaymentsInGamePurchaseSuccess")
			end
		end
		function t1.signalXboxInGamePurchaseFailure(p35, p36, p37) -- line: 232
			-- upvalues: RunService (copy), RbxAnalyticsService (copy)
			local t11 = {
				gameID = game.GameId,
				productId = p35,
				requestType = p36,
				iapProductId = p37 or ""
			}

			if not RunService:IsStudio() then
				RbxAnalyticsService:SetRBXEvent("client", "InGamePrompt", "XboxPaymentsInGamePurchaseFailure", t11 or {})
			end

			if not RunService:IsStudio() then
				RbxAnalyticsService:ReportCounter("XboxPaymentsInGamePurchaseFailure")
			end
		end
		function t1.signalTwoSVSettingsErrorShown(p38, p39) -- line: 244
			-- upvalues: RunService (copy), RbxAnalyticsService (copy), GetPlatformString (copy)
			local t12 = {
				gameID = game.GameId,
				productId = p38,
				requestType = p39
			}

			if not RunService:IsStudio() then
				RbxAnalyticsService:SetRBXEvent("client", "InGamePrompt", "2SVSettingsErrorShown", t12 or {})
			end

			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:ReportCounter("2SVSettingsErrorShown" .. GetPlatformString())
		end
		function t1.signalTwoSVSettingsErrorConfirmed(p40, p41) -- line: 253
			-- upvalues: RunService (copy), RbxAnalyticsService (copy), GetPlatformString (copy)
			local t13 = {
				gameID = game.GameId,
				productId = p40,
				requestType = p41
			}

			if not RunService:IsStudio() then
				RbxAnalyticsService:SetRBXEvent("client", "InGamePrompt", "2SVSettingsErrorConfirmed", t13 or {})
			end

			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:ReportCounter("2SVSettingsErrorConfirmed" .. GetPlatformString())
		end
		function t1.signalRobuxUpsellInGameIXP(p42) -- line: 262
			-- upvalues: RunService (copy), RbxAnalyticsService (copy), GetPlatformString (copy)
			if not RunService:IsStudio() then
				RbxAnalyticsService:SetRBXEvent("client", "InGamePrompt", "RobuxUpsellInGameIXP", {} or {})
			end

			if p42 then
				if RunService:IsStudio() then
					return
				end

				RbxAnalyticsService:ReportCounter("RobuxUpsellInGameIXP" .. GetPlatformString())
			end
		end
		function t1.signalAvatarCreationPurchaseSubmit() -- line: 269
			-- upvalues: RbxAnalyticsService (copy), RunService (copy), GetPlatformString (copy)
			RbxAnalyticsService:SetRBXEvent("client", "InGamePrompt", "AvatarCreationPurchaseSubmit", {
				gameID = game.GameId
			})

			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:ReportCounter("AvatarCreationPurchaseSubmit" .. GetPlatformString())
		end
		function t1.signalUserSettingEligibilityModal(p43) -- line: 274
			-- upvalues: RunService (copy), RbxAnalyticsService (copy), GetPlatformString (copy)
			local t14 = {
				gameID = game.GameId,
				requestType = p43
			}

			if not RunService:IsStudio() then
				RbxAnalyticsService:SetRBXEvent("client", "InGamePrompt", "UserSettingEligibilityModalShown", t14 or {})
			end

			local v78 = "UserSettingEligibilityModalShown" .. p43

			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:ReportCounter(v78 .. GetPlatformString())
		end
		function t1.signalEconomicRestrictionError(p44, p45) -- line: 282
			-- upvalues: RunService (copy), RbxAnalyticsService (copy)
			local t15 = {
				gameID = game.GameId,
				violationType = p44,
				timeoutMinutes = p45
			}

			if RunService:IsStudio() then
				return
			end

			RbxAnalyticsService:SetRBXEvent("client", "InGamePrompt", "EconomicRestrictionErrorShown", t15 or {})
		end

		return t1
	end
}
