local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local ContentProvider = game:GetService("ContentProvider")
local GuiService = game:GetService("GuiService")
local Base64 = require(PurchasePrompt.Utils.Base64)
local PurchaseFlow = require(PurchasePrompt.Enums.PurchaseFlow)
local Constants = require(PurchasePrompt.Misc.Constants)
local MarketplaceService = game:GetService("MarketplaceService")
local BrowserService = game:GetService("BrowserService")
local HttpService = game:GetService("HttpService")
local PlatformService = nil

pcall(function() -- line: 15
	-- upvalues: PlatformService (ref)
	PlatformService = game:GetService("PlatformService")
end)

local GetFStringVNGWebshopUrl = require(PurchasePromptParent.SharedFlags).GetFStringVNGWebshopUrl
local UrlBuilder = require(PurchasePromptParent.PurchasePromptDeps).UrlBuilder.UrlBuilder
local v14 = string.gsub(ContentProvider.BaseUrl:lower(), "/m.", "/www.")
local t1 = {}

local function addContextToUrl(s1: string, p1) -- line: 32
	for v19, v20 in p1 do
		if v20 then
			s1 = if not s1:find("?") then s1 .. ("?%s=%s"):format(v19, v20) else s1 .. ("&%s=%s"):format(v19, v20)
		end
	end

	return s1
end

function t1.new() -- line: 45
	-- upvalues: MarketplaceService (copy), v14 (copy), GuiService (copy), addContextToUrl (copy), PurchaseFlow (copy), Base64 (copy), UrlBuilder (copy), HttpService (copy), Constants (copy), BrowserService (copy), PlatformService (ref), GetFStringVNGWebshopUrl (copy)
	local t2 = {}

	setmetatable(t2, {
		__tostring = function() -- line: 49
			return "Service(PlatformInterface)"
		end
	})

	function t2.signalMockPurchasePremium() -- line: 54
		-- upvalues: MarketplaceService (copy)
		MarketplaceService:SignalMockPurchasePremium()
	end
	function t2.startPremiumUpsell(p2) -- line: 58
		-- upvalues: v14 (copy), GuiService (copy)
		local v23 = ("%supgrades/paymentmethods?ap=%d"):format(v14, p2)

		GuiService:OpenBrowserWindow(v23)
	end
	function t2.startPremiumUpsellWithContext(t3: {[any]: any}, p3) -- line: 64
		-- upvalues: v14 (copy), addContextToUrl (copy), GuiService (copy)
		local v26 = ("%supgrades/paymentmethods?ap=%d"):format(v14, p3)
		local v27 = addContextToUrl(v26, t3)

		GuiService:OpenBrowserWindow(v27)
	end
	function t2.startRobuxUpsellWebByFlow(p4, s2: string) -- line: 70
		-- upvalues: PurchaseFlow (copy), GuiService (copy), v14 (copy)
		if p4 == PurchaseFlow.RobuxUpsellV2 or p4 == PurchaseFlow.LargeRobuxUpsell then
			GuiService:OpenBrowserWindow(("%supgrades/paymentmethods?ap=%s"):format(v14, s2))

			return
		end

		GuiService:OpenBrowserWindow(("%sUpgrades/Robux.aspx?product_id=%s"):format(v14, s2))
	end
	function t2.startRobuxUpsellWebByFlowWithContext(t4: {[any]: any}, p5, s3: string) -- line: 78
		-- upvalues: PurchaseFlow (copy), v14 (copy), addContextToUrl (copy), GuiService (copy)
		local v33 = if not (p5 == PurchaseFlow.RobuxUpsellV2 or p5 == PurchaseFlow.LargeRobuxUpsell) then ("%sUpgrades/Robux.aspx?product_id=%s"):format(v14, s3) else ("%supgrades/paymentmethods?ap=%s"):format(v14, s3)
		local v34 = addContextToUrl(v33, t4)

		GuiService:OpenBrowserWindow(v34)
	end
	function t2.openSecuritySettings(s4: string?) -- line: 89
		-- upvalues: Base64 (copy), v14 (copy), GuiService (copy)
		if s4 then
			local v36 = Base64.Encode(s4)
			local v37 = ("%smy/account?challenge=%s#!/security"):format(v14, v36)

			GuiService:OpenBrowserWindow(v37)

			return
		end

		local v38 = ("%smy/account#!/security"):format(v14)

		GuiService:OpenBrowserWindow(v38)
	end
	function t2.openTermsOfUse() -- line: 103
		-- upvalues: UrlBuilder (copy), GuiService (copy)
		local v39 = UrlBuilder.static.about.terms()

		GuiService:OpenBrowserWindow(v39)
	end
	function t2.openTermsOfUseDMCCA() -- line: 109
		-- upvalues: HttpService (copy), Constants (copy), BrowserService (copy)
		local json = HttpService:JSONEncode({
			command = "open",
			url = Constants.TermsOfUse.DMCCAUrl
		})

		BrowserService:SendCommand(json)
	end
	function t2.openRobuxStore() -- line: 117
		-- upvalues: GuiService (copy), v14 (copy)
		GuiService:OpenBrowserWindow(("%sUpgrades/Robux.aspx"):format(v14))
	end
	function t2.openRobuxStoreWithContext(t5: {[any]: any}, s5: string?) -- line: 121
		-- upvalues: v14 (copy), addContextToUrl (copy), GuiService (copy)
		local v43 = ("%sUpgrades/Robux.aspx"):format(v14)

		if s5 then
			v43 ..= ("?product_id=%s"):format(s5)
		end

		local v44 = addContextToUrl(v43, t5)

		GuiService:OpenBrowserWindow(v44)
	end
	function t2.openPaymentsPageWithContext(t6: {[any]: any}, s6: string) -- line: 130
		-- upvalues: v14 (copy), addContextToUrl (copy), GuiService (copy)
		local v47 = ("%supgrades/paymentmethods?ap=%s"):format(v14, s6)
		local v48 = addContextToUrl(v47, t6)

		GuiService:OpenBrowserWindow(v48)
	end
	function t2.promptNativePurchaseWithLocalPlayer(p6) -- line: 136
		-- upvalues: MarketplaceService (copy)
		return MarketplaceService:PromptNativePurchaseWithLocalPlayer(p6)
	end
	function t2.promptNativePurchase(p7, p8) -- line: 140
		-- upvalues: MarketplaceService (copy)
		return MarketplaceService:PromptNativePurchase(p7, p8)
	end
	function t2.beginPlatformStorePurchase(p9) -- line: 144
		-- upvalues: PlatformService (ref)
		return PlatformService:BeginPlatformStorePurchase(p9)
	end
	function t2.openVngStore(s7: string) -- line: 148
		-- upvalues: GetFStringVNGWebshopUrl (copy), GuiService (copy)
		if not s7 or s7 == "" then
			s7 = GetFStringVNGWebshopUrl()
		end

		GuiService:OpenBrowserWindow(s7)
	end

	return t2
end

return t1
