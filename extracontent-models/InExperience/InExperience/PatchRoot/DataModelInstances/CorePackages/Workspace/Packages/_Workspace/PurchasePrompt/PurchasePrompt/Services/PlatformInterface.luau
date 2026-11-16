local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local ContentProvider = game:GetService("ContentProvider")
local GuiService = game:GetService("GuiService")
local Base64 = require(PurchasePrompt.Utils.Base64)
local PurchaseFlow = require(PurchasePrompt.Enums.PurchaseFlow)
local Constants = require(PurchasePrompt.Misc.Constants)
local MarketplaceService = game:GetService("MarketplaceService")
local BrowserService = game:GetService("BrowserService")
local HttpService = game:GetService("HttpService")
local v = nil

pcall(function()
	local PlatformService = game:GetService("PlatformService")
	v = PlatformService
end)

local SharedFlags = require(parent.SharedFlags)
local GetFStringVNGWebshopUrl = SharedFlags.GetFStringVNGWebshopUrl
local function isInExperienceBuyRobuxRoutingEnabled() -- 4 equivalent calls inferred from this helper
	return SharedFlags.FFlagEnableBuyRobuxNewRouting and SharedFlags.FFlagEnableBuyRobuxNewRoutingInExperience
end

local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local UrlBuilder = PurchasePromptDeps.UrlBuilder.UrlBuilder

local v2 = string.gsub(ContentProvider.BaseUrl:lower(), "/m.", "/www.")

local function addContextToUrl(value: string, items)
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
		local v3 = {}

		setmetatable(v3, {
			__tostring = function(): string
				return "Service(PlatformInterface)"
			end
		})

		function v3.startRobuxUpsellWebByFlow(p, productId: string)
			if p == PurchaseFlow.RobuxUpsellV2 or p == PurchaseFlow.LargeRobuxUpsell then
				GuiService:OpenBrowserWindow(("%supgrades/paymentmethods?ap=%s"):format(v2, productId))
			elseif isInExperienceBuyRobuxRoutingEnabled() then -- inferred equivalent call
				local BuyRobuxInExperience = require(parent.BuyRobuxInExperience)
				BuyRobuxInExperience.openBuyRobux({ productId = productId }, function(p2: string)
					GuiService:OpenBrowserWindow(p2)
				end, "PurchasePrompt.startRobuxUpsellWebByFlow")
			else
				GuiService:OpenBrowserWindow(("%sUpgrades/Robux.aspx?product_id=%s"):format(v2, productId))
			end
		end

		function v3.startRobuxUpsellWebByFlowWithContext(p, p2, productId: string)
			local v4 = p2 == PurchaseFlow.RobuxUpsellV2 or p2 == PurchaseFlow.LargeRobuxUpsell

			if isInExperienceBuyRobuxRoutingEnabled() and not v4 then -- inferred equivalent call
				local BuyRobuxInExperience = require(parent.BuyRobuxInExperience)
				BuyRobuxInExperience.openBuyRobux(
					{ productId = productId, analyticId = p.analyticId },
					function(p3: string)
						GuiService:OpenBrowserWindow(p3)
					end,
					"PurchasePrompt.startRobuxUpsellWebByFlowWithContext"
				)
			else
				local v5

				if v4 then
					v5 = ("%supgrades/paymentmethods?ap=%s"):format(v2, productId)
				else
					v5 = ("%sUpgrades/Robux.aspx?product_id=%s"):format(v2, productId)
				end

				GuiService:OpenBrowserWindow(addContextToUrl(v5, p))
			end
		end

		function v3.openSecuritySettings(p: string?)
			if p then
				GuiService:OpenBrowserWindow((("%smy/account?challenge=%s#!/security"):format(v2, (Base64.Encode(p)))))
			else
				GuiService:OpenBrowserWindow((("%smy/account#!/security"):format(v2)))
			end
		end

		function v3.openTermsOfUse()
			GuiService:OpenBrowserWindow((UrlBuilder.static.about.terms()))
		end

		function v3.openTermsOfUseDMCCA()
			BrowserService:SendCommand((HttpService:JSONEncode({
				command = "open",
				url = Constants.TermsOfUse.DMCCAUrl
			})))
		end

		function v3.openRobuxStore()
			if isInExperienceBuyRobuxRoutingEnabled() then -- inferred equivalent call
				local BuyRobuxInExperience = require(parent.BuyRobuxInExperience)
				BuyRobuxInExperience.openBuyRobux({}, function(p: string)
					GuiService:OpenBrowserWindow(p)
				end, "PurchasePrompt.openRobuxStore")
			else
				GuiService:OpenBrowserWindow(("%sUpgrades/Robux.aspx"):format(v2))
			end
		end

		function v3.openRobuxStoreWithContext(p, productId: string?)
			if isInExperienceBuyRobuxRoutingEnabled() then -- inferred equivalent call
				local BuyRobuxInExperience = require(parent.BuyRobuxInExperience)
				BuyRobuxInExperience.openBuyRobux(
					{ productId = productId, analyticId = p.analyticId },
					function(p2: string)
						GuiService:OpenBrowserWindow(p2)
					end,
					"PurchasePrompt.openRobuxStoreWithContext"
				)
			else
				local v4 = ("%sUpgrades/Robux.aspx"):format(v2)

				if productId then
					v4 ..= ("?product_id=%s"):format(productId)
				end

				GuiService:OpenBrowserWindow(addContextToUrl(v4, p))
			end
		end

		function v3.openPaymentsPageWithContext(p, p2: string)
			GuiService:OpenBrowserWindow(addContextToUrl(("%supgrades/paymentmethods?ap=%s"):format(v2, p2), p))
		end

		function v3.promptNativePurchaseWithLocalPlayer(p)
			return MarketplaceService:PromptNativePurchaseWithLocalPlayer(p)
		end

		function v3.promptNativePurchase(p, p2)
			return MarketplaceService:PromptNativePurchase(p, p2)
		end

		function v3.beginPlatformStorePurchase(p)
			return v:BeginPlatformStorePurchase(p)
		end

		function v3.openVngStore(p: string)
			if not p or p == "" then
				p = GetFStringVNGWebshopUrl()
			end

			GuiService:OpenBrowserWindow(p)
		end

		return v3
	end
}
