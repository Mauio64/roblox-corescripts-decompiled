local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local SharedFlags = require(parent.SharedFlags)

local ContentProvider = game:GetService("ContentProvider")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local WebViewService = game:GetService("WebViewService")

local v = nil

pcall(function()
	local PlatformService = game:GetService("PlatformService")
	v = PlatformService
end)

local UpsellFlow = require(PurchasePrompt.Enums.UpsellFlow)
local getUpsellFlow = require(PurchasePrompt.NativeUpsell.getUpsellFlow)
local GetFFlagEnablePaymentSessionIdInRobuxPurchase = require(PurchasePrompt.Flags.GetFFlagEnablePaymentSessionIdInRobuxPurchase)

local getEngineFeaturePromptNativePurchaseWithContext = require(PurchasePrompt.Flags.getEngineFeaturePromptNativePurchaseWithContext)
local FFlagEnableBonusJwtInShop = SharedFlags.FFlagEnableBonusJwtInShop

local function getWebBaseUrl() -- 1 equivalent call inferred from this helper
	local baseUrl = ContentProvider.BaseUrl:lower()
	return (string.gsub(baseUrl, "/m%.", "/www."))
end

local function openRobuxPackageWebView(formatted: string, onWebViewClosed) -- 1 equivalent call inferred from this helper
	local onWindowClosedConnection = nil
	onWindowClosedConnection = WebViewService.OnWindowClosed:Connect(function()
		WebViewService:CloseWindow()

		if onWindowClosedConnection then
			onWindowClosedConnection:Disconnect()
			onWindowClosedConnection = nil
		end

		if onWebViewClosed then
			onWebViewClosed()
		end
	end)
	WebViewService:OpenWindow(formatted, "", true)
end

local function tryLaunchNativePurchaseWithContext(data, paymentSessionId: string)
	local purchaseType = data.purchaseType
	local isInApp = data.isInApp

	if purchaseType == nil or isInApp == nil then
		return false
	end

	local v2 = MarketplaceService
	local promptNativePurchaseWithContext = v2.PromptNativePurchaseWithContext

	if typeof(promptNativePurchaseWithContext) ~= "function" then
		return false
	end

	local v3 = { paymentSessionId = 0, purchaseType = 0, isInApp = 0 }

	if paymentSessionId == "" then
		paymentSessionId = nil
	end

	v3.paymentSessionId = paymentSessionId
	v3.purchaseType = purchaseType
	v3.isInApp = isInApp

	local v4 = false
	pcall(function()
		promptNativePurchaseWithContext(v2, data.mobileProductId, v3)
		v4 = true

		if data.onNativePurchaseLaunched ~= nil then
			data.onNativePurchaseLaunched()
		end
	end)
	return v4
end

local function startPurchase(data, p: string)
	local mobileProductId = data.mobileProductId
	local productId = data.productId

	local upsellFlow = getUpsellFlow((UserInputService:GetPlatform()))

	if upsellFlow == UpsellFlow.Mobile then
		if getEngineFeaturePromptNativePurchaseWithContext() and tryLaunchNativePurchaseWithContext(data, p) then
			return
		end

		local localPlayer = Players.LocalPlayer
		local engineFeature = game:GetEngineFeature("NativePurchaseWithLocalPlayer")
		local engineFeature2 = game:GetEngineFeature("PromptNativePurchaseWithPaymentSessionId")

		pcall(function()
			local v2 = MarketplaceService

			local promptNativePurchaseWithLocalPlayerWithPaymentSessionId = v2.PromptNativePurchaseWithLocalPlayerWithPaymentSessionId
			local promptNativePurchaseWithLocalPlayer = v2.PromptNativePurchaseWithLocalPlayer
			local promptNativePurchaseWithPaymentSessionId = v2.PromptNativePurchaseWithPaymentSessionId
			local promptNativePurchase = v2.PromptNativePurchase

			if
				engineFeature
				and engineFeature2
				and typeof(promptNativePurchaseWithLocalPlayerWithPaymentSessionId) == "function"
			then
				promptNativePurchaseWithLocalPlayerWithPaymentSessionId(v2, mobileProductId, p)
			elseif engineFeature and typeof(promptNativePurchaseWithLocalPlayer) == "function" then
				promptNativePurchaseWithLocalPlayer(v2, mobileProductId)
			elseif engineFeature2 and typeof(promptNativePurchaseWithPaymentSessionId) == "function" then
				promptNativePurchaseWithPaymentSessionId(v2, localPlayer, mobileProductId, p)
			elseif typeof(promptNativePurchase) == "function" then
				promptNativePurchase(v2, localPlayer, mobileProductId)
			else
				error("MarketplaceService has no PromptNativePurchase APIs bound")
			end

			if data.onNativePurchaseLaunched ~= nil then
				data.onNativePurchaseLaunched()
			end
		end)
	elseif upsellFlow == UpsellFlow.Xbox then
		if v == nil then
			return
		end

		pcall(function()
			v:BeginPlatformStorePurchase(mobileProductId)
		end)
	elseif upsellFlow == UpsellFlow.Web then
		if productId == nil then
			return
		end

		local formatted = ("%supgrades/paymentmethods?ap=%s"):format(getWebBaseUrl(), (tostring(productId))) -- inferred equivalent call

		if p ~= "" then
			formatted = ("%s&paymentSessionId=%s"):format(formatted, p)
		end

		pcall(function()
			openRobuxPackageWebView(formatted, data.onWebViewClosed) -- inferred equivalent call
		end)
	end
end

local function launchRobuxPackagePurchase(data)
	local paymentSessionId = GetFFlagEnablePaymentSessionIdInRobuxPurchase() and data.paymentSessionId or ""

	if RunService:IsStudio() then
		return nil
	end

	if FFlagEnableBonusJwtInShop then
		local upsellFlow = getUpsellFlow(UserInputService:GetPlatform())
		local v2

		if upsellFlow == UpsellFlow.Mobile then
			v2 = false
		else
			v2 = upsellFlow ~= UpsellFlow.Web
		end

		local bonusJwt = data.bonusJwt
		local redeemBonusToken = data.redeemBonusToken

		if not v2 and typeof(bonusJwt) == "string" and bonusJwt ~= "" and redeemBonusToken ~= nil then
			local success, result = pcall(function()
				return redeemBonusToken(bonusJwt, game.GameId)
			end)

			if not success then
				return nil
			end

			if typeof(result) == "table" and typeof(result.andThen) == "function" then
				return result:andThen(function(value)
					startPurchase(data, typeof(value) ~= "string" and "" or value)
				end)
			end

			return nil
		end
	end

	startPurchase(data, paymentSessionId)
	return nil
end

return launchRobuxPackagePurchase
