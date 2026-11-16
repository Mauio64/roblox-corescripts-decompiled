local ContentProvider = game:GetService("ContentProvider")
local GuiService = game:GetService("GuiService")
local Base64 = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/Base64")
local PurchaseFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseFlow")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Misc/Constants")
local MarketplaceService = game:GetService("MarketplaceService")
local BrowserService = game:GetService("BrowserService")
local HttpService = game:GetService("HttpService")
local v5 = nil

pcall(function()
	local PlatformService = game:GetService("PlatformService")
	v5 = PlatformService
end)

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags")
local getFStringVNGWebshopUrl = SharedFlags.GetFStringVNGWebshopUrl
local function isInExperienceBuyRobuxRoutingEnabled()
	return SharedFlags.FFlagEnableBuyRobuxNewRouting and SharedFlags.FFlagEnableBuyRobuxNewRoutingInExperience
end

local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps").UrlBuilder.UrlBuilder

local v6 = string.gsub(ContentProvider.BaseUrl:lower(), "/m.", "/www.")

local function addContextToUrl(value, items)
	for k, item in items do
		if not item then
			continue
		end

		if value:find("?") then
			value ..= ("&%s=%s"):format(k, item)
		else
			value ..= ("?%s=%s"):format(k, item)
		end
	end

	return value
end

return {
	new = function()
		local v8 = {}

		setmetatable(v8, {
			__tostring = function(): string
				return "Service(PlatformInterface)"
			end
		})

		function v8.startRobuxUpsellWebByFlow(p2, p3)
			if p2 == PurchaseFlow.RobuxUpsellV2 or p2 == PurchaseFlow.LargeRobuxUpsell then
				GuiService:OpenBrowserWindow(("%supgrades/paymentmethods?ap=%s"):format(v6, p3))
			elseif
				SharedFlags.FFlagEnableBuyRobuxNewRouting
				and SharedFlags.FFlagEnableBuyRobuxNewRoutingInExperience
			then
				require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/BuyRobuxInExperience").openBuyRobux({ productId = p3 }, function(p4)
					GuiService:OpenBrowserWindow(p4)
				end, "PurchasePrompt.startRobuxUpsellWebByFlow")
			else
				GuiService:OpenBrowserWindow(("%sUpgrades/Robux.aspx?product_id=%s"):format(v6, p3))
			end
		end

		function v8.startRobuxUpsellWebByFlowWithContext(p2, p3, p4)
			local v9 = p3 == PurchaseFlow.RobuxUpsellV2 or p3 == PurchaseFlow.LargeRobuxUpsell

			if
				SharedFlags.FFlagEnableBuyRobuxNewRouting
				and SharedFlags.FFlagEnableBuyRobuxNewRoutingInExperience
				and not v9
			then
				require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/BuyRobuxInExperience").openBuyRobux(
					{ productId = p4, analyticId = p2.analyticId },
					function(p5)
						GuiService:OpenBrowserWindow(p5)
					end,
					"PurchasePrompt.startRobuxUpsellWebByFlowWithContext"
				)
				return
			end

			local v10

			if v9 then
				v10 = ("%supgrades/paymentmethods?ap=%s"):format(v6, p4)
			else
				v10 = ("%sUpgrades/Robux.aspx?product_id=%s"):format(v6, p4)
			end

			GuiService:OpenBrowserWindow(addContextToUrl(v10, p2))
		end

		function v8.openSecuritySettings(p2)
			if p2 then
				GuiService:OpenBrowserWindow((("%smy/account?challenge=%s#!/security"):format(
					v6,
					(Base64.Encode(p2))
				)))
			else
				GuiService:OpenBrowserWindow((("%smy/account#!/security"):format(v6)))
			end
		end

		function v8.openTermsOfUse()
			GuiService:OpenBrowserWindow((urlBuilder.static.about.terms()))
		end

		function v8.openTermsOfUseDMCCA()
			BrowserService:SendCommand((HttpService:JSONEncode({
				command = "open",
				url = Constants.TermsOfUse.DMCCAUrl
			})))
		end

		function v8.openRobuxStore()
			if
				SharedFlags.FFlagEnableBuyRobuxNewRouting
				and SharedFlags.FFlagEnableBuyRobuxNewRoutingInExperience
			then
				require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/BuyRobuxInExperience").openBuyRobux({}, function(p2)
					GuiService:OpenBrowserWindow(p2)
				end, "PurchasePrompt.openRobuxStore")
			else
				GuiService:OpenBrowserWindow(("%sUpgrades/Robux.aspx"):format(v6))
			end
		end

		function v8.openRobuxStoreWithContext(p2, p3)
			if
				SharedFlags.FFlagEnableBuyRobuxNewRouting
				and SharedFlags.FFlagEnableBuyRobuxNewRoutingInExperience
			then
				require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/BuyRobuxInExperience").openBuyRobux(
					{ productId = p3, analyticId = p2.analyticId },
					function(p4)
						GuiService:OpenBrowserWindow(p4)
					end,
					"PurchasePrompt.openRobuxStoreWithContext"
				)
				return
			end

			local v9 = ("%sUpgrades/Robux.aspx"):format(v6)

			if p3 then
				v9 ..= ("?product_id=%s"):format(p3)
			end

			GuiService:OpenBrowserWindow(addContextToUrl(v9, p2))
		end

		function v8.openPaymentsPageWithContext(p2, p3)
			GuiService:OpenBrowserWindow(addContextToUrl(
				("%supgrades/paymentmethods?ap=%s"):format(v6, p3),
				p2
			))
		end

		function v8.promptNativePurchaseWithLocalPlayer(p2)
			return MarketplaceService:PromptNativePurchaseWithLocalPlayer(p2)
		end

		function v8.promptNativePurchase(p2, p3)
			return MarketplaceService:PromptNativePurchase(p2, p3)
		end

		function v8.beginPlatformStorePurchase(p2)
			return v5:BeginPlatformStorePurchase(p2)
		end

		function v8.openVngStore(p2)
			if not p2 or p2 == "" then
				p2 = getFStringVNGWebshopUrl()
			end

			GuiService:OpenBrowserWindow(p2)
		end

		return v8
	end
}
