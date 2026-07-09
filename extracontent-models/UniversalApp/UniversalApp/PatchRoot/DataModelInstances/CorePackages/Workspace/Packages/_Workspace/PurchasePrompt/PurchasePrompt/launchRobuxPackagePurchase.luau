local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local ContentProvider = game:GetService("ContentProvider")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local WebViewService = game:GetService("WebViewService")
local PlatformService = nil

pcall(function() -- line: 52
	-- upvalues: PlatformService (ref)
	PlatformService = game:GetService("PlatformService")
end)

local UpsellFlow = require(PurchasePrompt.Enums.UpsellFlow)
local getUpsellFlow = require(PurchasePrompt.NativeUpsell.getUpsellFlow)
local GetFFlagEnablePaymentSessionIdInRobuxPurchase = require(PurchasePrompt.Flags.GetFFlagEnablePaymentSessionIdInRobuxPurchase)

local function getWebBaseUrl() -- line: 83
	-- upvalues: ContentProvider (copy)
	local v15 = ContentProvider.BaseUrl:lower()

	return (string.gsub(v15, "/m%.", "/www."))
end
local function openRobuxPackageWebView(s1: string, p1: ((...any) -> ...any)?) -- line: 105
	-- upvalues: WebViewService (copy)
	local u18 = nil

	u18 = WebViewService.OnWindowClosed:Connect(function() -- line: 107
		-- upvalues: WebViewService (copy), u18 (ref), p1 (copy)
		WebViewService:CloseWindow()

		if u18 then
			u18:Disconnect()
			u18 = nil
		end

		if p1 then
			p1()
		end
	end)
	WebViewService:OpenWindow(s1, "", true)
end
local function launchRobuxPackagePurchase(t1: {[any]: any}) -- line: 120
	-- upvalues: GetFFlagEnablePaymentSessionIdInRobuxPurchase (copy), RunService (copy), UserInputService (copy), getUpsellFlow (copy), UpsellFlow (copy), Players (copy), MarketplaceService (copy), PlatformService (ref), ContentProvider (copy), WebViewService (copy)
	local mobileProductId = t1.mobileProductId
	local productId = t1.productId
	local v22 = not GetFFlagEnablePaymentSessionIdInRobuxPurchase() and "" or (t1.paymentSessionId or "")

	if RunService:IsStudio() then
		return
	end

	local Platform = UserInputService:GetPlatform()
	local v24 = getUpsellFlow(Platform)

	if v24 == UpsellFlow.Mobile then
		local LocalPlayer = Players.LocalPlayer
		local EngineFeature = game:GetEngineFeature("NativePurchaseWithLocalPlayer")
		local EngineFeature2 = game:GetEngineFeature("PromptNativePurchaseWithPaymentSessionId")

		pcall(function() -- line: 157
			-- upvalues: MarketplaceService (copy), EngineFeature (copy), EngineFeature2 (copy), mobileProductId (copy), v22 (copy), LocalPlayer (copy)
			local v30 = MarketplaceService
			local PromptNativePurchaseWithLocalPlayerWithPaymentSessionId = v30.PromptNativePurchaseWithLocalPlayerWithPaymentSessionId
			local PromptNativePurchaseWithLocalPlayer = v30.PromptNativePurchaseWithLocalPlayer
			local PromptNativePurchaseWithPaymentSessionId = v30.PromptNativePurchaseWithPaymentSessionId
			local PromptNativePurchase = v30.PromptNativePurchase

			if EngineFeature and (EngineFeature2 and typeof(PromptNativePurchaseWithLocalPlayerWithPaymentSessionId) == "function") then
				PromptNativePurchaseWithLocalPlayerWithPaymentSessionId(v30, mobileProductId, v22)

				return
			end

			if EngineFeature and typeof(PromptNativePurchaseWithLocalPlayer) == "function" then
				PromptNativePurchaseWithLocalPlayer(v30, mobileProductId)

				return
			end

			if EngineFeature2 and typeof(PromptNativePurchaseWithPaymentSessionId) == "function" then
				PromptNativePurchaseWithPaymentSessionId(v30, LocalPlayer, mobileProductId, v22)

				return
			end

			if typeof(PromptNativePurchase) == "function" then
				PromptNativePurchase(v30, LocalPlayer, mobileProductId)

				return
			end

			error("MarketplaceService has no PromptNativePurchase APIs bound")
		end)

		return
	end

	if v24 == UpsellFlow.Xbox then
		if PlatformService == nil then
			return
		end

		pcall(function() -- line: 196
			-- upvalues: PlatformService (ref), mobileProductId (copy)
			PlatformService:BeginPlatformStorePurchase(mobileProductId)
		end)

		return
	end

	if v24 == UpsellFlow.Web then
		if productId == nil then
			return
		end

		local v28 = ContentProvider.BaseUrl:lower()
		local u29 = ("%supgrades/paymentmethods?ap=%s"):format(string.gsub(v28, "/m%.", "/www."), (tostring(productId)))

		if v22 ~= "" then
			u29 = ("%s&paymentSessionId=%s"):format(u29, v22)
		end

		pcall(function() -- line: 210
			-- upvalues: u29 (ref), t1 (copy), WebViewService (copy)
			local v35 = u29
			local onWebViewClosed = t1.onWebViewClosed
			local u37 = nil

			u37 = WebViewService.OnWindowClosed:Connect(function() -- line: 107
				-- upvalues: WebViewService (copy), u37 (ref), onWebViewClosed (copy)
				WebViewService:CloseWindow()

				if u37 then
					u37:Disconnect()
					u37 = nil
				end

				if onWebViewClosed then
					onWebViewClosed()
				end
			end)
			WebViewService:OpenWindow(v35, "", true)
		end)
	end
end

return launchRobuxPackagePurchase
